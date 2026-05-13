const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

class DoctorController {
  // GET /api/v1/doctors
  async getDoctors(req, res) {
    try {
      const { search, specialty } = req.query;

      // Build filter criteria
      const whereClause = {};

      if (search && search.trim() !== '') {
        whereClause.full_name = {
          contains: search.trim(),
          mode: 'insensitive',
        };
      }

      if (specialty && specialty.trim() !== '' && specialty.toLowerCase() !== 'all') {
        whereClause.specialization = {
          contains: specialty.trim(),
          mode: 'insensitive',
        };
      }

      const doctors = await prisma.doctor.findMany({
        where: whereClause,
        orderBy: { full_name: 'asc' },
      });

      return res.status(200).json({
        success: true,
        data: doctors,
      });
    } catch (error) {
      console.error('Error in getDoctors:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to retrieve doctors list',
      });
    }
  }

  // GET /api/v1/doctors/:id
  async getDoctorById(req, res) {
    try {
      const { id } = req.params;

      const doctor = await prisma.doctor.findUnique({
        where: { id },
      });

      if (!doctor) {
        return res.status(404).json({
          success: false,
          error: 'Doctor not found',
        });
      }

      return res.status(200).json({
        success: true,
        data: doctor,
      });
    } catch (error) {
      console.error('Error in getDoctorById:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to retrieve doctor details',
      });
    }
  }

  // POST /api/v1/doctors
  async createDoctor(req, res) {
    let uploadedFilePath = null;

    try {
      const {
        full_name,
        gender,
        email,
        phone_number,
        address,
        specialization,
        experience,
        education,
        license_number,
        status,
        working_hours,
        rating,
        total_reviews,
        total_patients,
        surgeries,
        patients_increase_percent,
        username,
        password,
      } = req.body;

      // ── 1. Basic validation BEFORE touching the file system ──────────────
      if (!full_name) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(400).json({ success: false, error: 'Full name is required' });
      }

      // ── 2. Uniqueness checks (username + email) — BEFORE uploading file ──
      const trimmedUsername = username ? username.trim() : null;
      const trimmedEmail = email ? email.trim() : (trimmedUsername ? `${trimmedUsername}@carebot.local` : null);

      if (trimmedUsername) {
        const existingUser = await prisma.user.findUnique({ where: { username: trimmedUsername } });
        if (existingUser) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(409).json({ 
            success: false, 
            error: `The username "${trimmedUsername}" is already taken. Please choose another.` 
          });
        }
      }

      if (trimmedEmail) {
        // Check both User and Doctor tables for email uniqueness
        const existingUserEmail = await prisma.user.findUnique({ where: { email: trimmedEmail } });
        const existingDoctorEmail = await prisma.doctor.findFirst({ where: { email: trimmedEmail } });
        
        if (existingUserEmail || existingDoctorEmail) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(409).json({ 
            success: false, 
            error: `The email "${trimmedEmail}" is already registered. Please use a different email.` 
          });
        }
      }

      // ── 3. Determine profile image URL ───────────────────────────────────
      let finalProfileImageUrl = 'images/doctors/default.jpg';
      if (req.file) {
        uploadedFilePath = req.file.path;
        finalProfileImageUrl = `uploads/${req.file.filename}`;
      }

      // ── 4. Hash password with bcrypt ─────────────────────────────────────
      let passwordHash = null;
      if (username && password) {
        const bcrypt = require('bcryptjs');
        passwordHash = await bcrypt.hash(password, 12);
      }

      // ── 5. Atomic DB Transaction: create User + Doctor + AvailabilitySlots
      const newDoctor = await prisma.$transaction(async (tx) => {
        // 5a. Create User account (if username + password provided)
        let newUser = null;
        if (trimmedUsername && passwordHash) {
          newUser = await tx.user.create({
            data: {
              username: trimmedUsername,
              email: trimmedEmail,
              password_hash: passwordHash,
              full_name: full_name.trim(),
              role: 'DOCTOR',
            },
          });
        }

        // 5b. Create Doctor profile
        const created = await tx.doctor.create({
          data: {
            user_id: newUser ? newUser.id : null,
            full_name: full_name.trim(),
            profile_image_url: finalProfileImageUrl,
            gender: gender || 'Male',
            email: email || '',
            phone_number: phone_number || '',
            address: address || '',
            specialization: specialization || 'General Practice',
            experience: experience || '',
            education: education || 'MBBS',
            license_number: license_number || '',
            status: status || 'Available',
            working_hours: working_hours || '9AM - 2PM',
            rating: rating ? parseFloat(rating) : 0.0,
            total_reviews: total_reviews ? parseInt(total_reviews) : 0,
            total_patients: total_patients ? parseInt(total_patients) : 0,
            surgeries: surgeries ? parseInt(surgeries) : 0,
            patients_increase_percent: patients_increase_percent ? parseFloat(patients_increase_percent) : 0.0,
          },
        });

        // 5c. Auto-generate default availability slots
        const defaultSlots = [
          '09.00:AM', '09.30:AM', '10.00:AM', '10.30:AM',
          '11.30:AM', '12.00:PM', '02.00:PM', '02.30:PM',
        ];
        for (const slot of defaultSlots) {
          await tx.availabilitySlot.create({
            data: {
              doctor_id: created.id,
              time_slot: slot,
              is_booked: false,
            },
          });
        }

        return created;
      });

      // ── 6. NEVER return password_hash in response ─────────────────────────
      return res.status(201).json({ success: true, data: newDoctor });

    } catch (error) {
      console.error('Error in transactional createDoctor:', error);

      if (uploadedFilePath && fs.existsSync(uploadedFilePath)) {
        try {
          fs.unlinkSync(uploadedFilePath);
        } catch (unlinkErr) {
          console.error('Failed to clean up file on rollback:', unlinkErr);
        }
      }

      let errorMessage = 'Failed to create new doctor. Please try again.';
      
      // Detailed error handling for Prisma errors
      if (error.code === 'P2002') {
        const target = error.meta?.target;
        const field = Array.isArray(target) ? target.join(', ') : (target || 'field');
        errorMessage = `Conflict: ${field} already exists. Please use unique values.`;
      } else if (error.message) {
        errorMessage = error.message;
      }

      return res.status(409).json({ 
        success: false, 
        error: errorMessage 
      });
    }
  }


  // PUT /api/v1/doctors/:id
  async updateDoctor(req, res) {
    let uploadedFilePath = null;
    try {
      const { id } = req.params;
      const { username, password, ...updateData } = req.body;

      // 1. Check if doctor exists
      const existingDoctor = await prisma.doctor.findUnique({ 
        where: { id },
        include: { user: true }
      });

      if (!existingDoctor) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(404).json({ success: false, error: 'Doctor not found' });
      }

      // 2. Define allowed fields and filter body
      const allowedFields = [
        'full_name', 'gender', 'email', 'phone_number', 'address',
        'specialization', 'experience', 'education', 'license_number',
        'status', 'working_hours'
      ];

      const cleanedData = {};
      allowedFields.forEach(field => {
        if (updateData[field] !== undefined) {
          cleanedData[field] = updateData[field];
        }
      });

      // 3. Handle file upload
      if (req.file) {
        uploadedFilePath = req.file.path;
        cleanedData.profile_image_url = `uploads/${req.file.filename}`;
        
        if (existingDoctor.profile_image_url && 
            existingDoctor.profile_image_url.startsWith('uploads/') &&
            !existingDoctor.profile_image_url.includes('default.jpg')) {
          const oldPath = path.join(__dirname, '../../public', existingDoctor.profile_image_url);
          if (fs.existsSync(oldPath)) fs.unlink(oldPath, () => {});
        }
      }

      // 4. Handle numeric conversions
      if (updateData.rating !== undefined) cleanedData.rating = parseFloat(updateData.rating);
      if (updateData.total_reviews !== undefined) cleanedData.total_reviews = parseInt(updateData.total_reviews);
      if (updateData.total_patients !== undefined) cleanedData.total_patients = parseInt(updateData.total_patients);
      if (updateData.surgeries !== undefined) cleanedData.surgeries = parseInt(updateData.surgeries);
      if (updateData.patients_increase_percent !== undefined) {
        cleanedData.patients_increase_percent = parseFloat(updateData.patients_increase_percent);
      }

      // 5. Transactional update for Doctor and User
      const result = await prisma.$transaction(async (tx) => {
        // Update User account if provided
        if ((username || password) && existingDoctor.user_id) {
          const userData = {};
          if (username) userData.username = username;
          if (password) userData.password_hash = await bcrypt.hash(password, 10);
          
          await tx.user.update({
            where: { id: existingDoctor.user_id },
            data: userData,
          });
        }

        // Update Doctor profile
        return await tx.doctor.update({
          where: { id },
          data: cleanedData,
        });
      });

      return res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error) {
      console.error('Error in updateDoctor:', error);
      
      if (uploadedFilePath && fs.existsSync(uploadedFilePath)) {
        fs.unlinkSync(uploadedFilePath);
      }

      // Handle Unique Constraint (409 Conflict)
      if (error.code === 'P2002') {
        const target = error.meta?.target;
        const field = Array.isArray(target) ? target.join(', ') : (target || 'field');
        return res.status(409).json({ 
          success: false, 
          error: `Conflict: ${field} is already taken. Please use a different value.` 
        });
      }

      return res.status(409).json({ 
        success: false, 
        error: error.message || 'Failed to update doctor profile' 
      });
    }
  }

  // DELETE /api/v1/doctors/:id
  async deleteDoctor(req, res) {
    try {
      const { id } = req.params;

      await prisma.doctor.delete({
        where: { id },
      });

      return res.status(200).json({
        success: true,
        message: 'Doctor deleted successfully',
      });
    } catch (error) {
      console.error('Error in deleteDoctor:', error);
      if (error.code === 'P2025') {
        return res.status(404).json({
          success: false,
          error: 'Doctor not found to delete',
        });
      }
      return res.status(500).json({
        success: false,
        error: 'Failed to delete doctor',
      });
    }
  }

  // GET /api/v1/doctors/:id/timetable
  async getDoctorTimetable(req, res) {
    try {
      const { id } = req.params;

      const doctorExists = await prisma.doctor.findUnique({
        where: { id },
      });

      if (!doctorExists) {
        return res.status(404).json({
          success: false,
          error: 'Doctor not found',
        });
      }

      // Fetch appointments
      const appointments = await prisma.appointment.findMany({
        where: { doctor_id: id },
        orderBy: { appointment_time: 'asc' },
      });

      // Split into check-ups and urgent visits
      const checkUps = appointments.filter((app) => app.category === 'Check-up');
      const urgentVisits = appointments.filter((app) => app.category === 'Urgent visit');

      // Fetch availability slots
      const availabilitySlots = await prisma.availabilitySlot.findMany({
        where: { doctor_id: id },
        orderBy: { time_slot: 'asc' },
      });

      return res.status(200).json({
        success: true,
        data: {
          check_ups: checkUps,
          urgent_visits: urgentVisits,
          availability: availabilitySlots,
        },
      });
    } catch (error) {
      console.error('Error in getDoctorTimetable:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to retrieve doctor timetable',
      });
    }
  }
}

module.exports = new DoctorController();
