const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');
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
          equals: specialty.trim(),
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
      if (username) {
        const existingUser = await prisma.user.findUnique({ where: { username: username.trim() } });
        if (existingUser) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(409).json({ success: false, error: `Username "${username}" is already taken. Please choose another.` });
        }
      }

      if (email) {
        const existingEmail = await prisma.user.findFirst({ where: { email: email.trim() } });
        if (existingEmail) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(409).json({ success: false, error: `Email "${email}" is already registered to another account.` });
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
        if (username && passwordHash) {
          newUser = await tx.user.create({
            data: {
              username: username.trim(),
              email: email ? email.trim() : `${username.trim()}@carebot.local`,
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

      // ROLLBACK FILE SYSTEM: delete uploaded avatar if DB transaction failed
      if (uploadedFilePath && fs.existsSync(uploadedFilePath)) {
        try {
          fs.unlinkSync(uploadedFilePath);
          console.log(`Cleaned up orphaned upload on rollback: ${uploadedFilePath}`);
        } catch (unlinkErr) {
          console.error('Failed to clean up file on rollback:', unlinkErr);
        }
      }

      // Handle Prisma unique constraint errors gracefully
      if (error.code === 'P2002') {
        const field = error.meta?.target?.[0] || 'field';
        return res.status(409).json({ success: false, error: `${field} already exists. Please use a different value.` });
      }

      return res.status(500).json({ success: false, error: 'Failed to create new doctor. Please try again.' });
    }
  }


  // PUT /api/v1/doctors/:id
  async updateDoctor(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;

      // Remove relationships or ID from body if passed accidentally
      delete updateData.id;
      delete updateData.appointments;
      delete updateData.availability_slots;

      // Handle conversions
      if (updateData.rating !== undefined) updateData.rating = parseFloat(updateData.rating);
      if (updateData.total_reviews !== undefined) updateData.total_reviews = parseInt(updateData.total_reviews);
      if (updateData.total_patients !== undefined) updateData.total_patients = parseInt(updateData.total_patients);
      if (updateData.surgeries !== undefined) updateData.surgeries = parseInt(updateData.surgeries);
      if (updateData.patients_increase_percent !== undefined) {
        updateData.patients_increase_percent = parseFloat(updateData.patients_increase_percent);
      }

      const updatedDoctor = await prisma.doctor.update({
        where: { id },
        data: updateData,
      });

      return res.status(200).json({
        success: true,
        data: updatedDoctor,
      });
    } catch (error) {
      console.error('Error in updateDoctor:', error);
      if (error.code === 'P2025') {
        return res.status(404).json({
          success: false,
          error: 'Doctor not found to update',
        });
      }
      return res.status(500).json({
        success: false,
        error: 'Failed to update doctor profile',
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
