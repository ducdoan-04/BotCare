const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const fs = require('fs');

class PatientController {
  // GET /api/v1/patients
  async listPatients(req, res) {
    try {
      const { search, date } = req.query;

      // 1. Build filter
      let whereClause = {};
      if (search) {
        whereClause.full_name = { contains: search, mode: 'insensitive' };
      }

      // If date is provided, filter patients who have appointments on that date OR registered on that date
      if (date) {
        const targetDate = new Date(date);
        const startOfDay = new Date(targetDate.setHours(0, 0, 0, 0));
        const endOfDay = new Date(targetDate.setHours(23, 59, 59, 999));

        whereClause.OR = [
          {
            appointments: {
              some: {
                appointment_date: {
                  gte: startOfDay,
                  lte: endOfDay,
                },
              },
            },
          },
          {
            registered_at: {
              gte: startOfDay,
              lte: endOfDay,
            },
          },
        ];
      }

      // 2. Fetch Patients
      const patients = await prisma.patient.findMany({
        where: whereClause,
        include: {
          assigned_doctor: {
            select: { full_name: true }
          },
          // Include latest appointment to calculate last_visit_date
          appointments: {
            orderBy: { appointment_date: 'desc' },
            take: 1,
            select: { appointment_date: true }
          }
        },
        orderBy: { registered_at: 'desc' },
      });

      // Transform for UI (lastVisitDate)
      const formattedPatients = patients.map(p => ({
        ...p,
        last_visit_date: p.appointments.length > 0 ? p.appointments[0].appointment_date : null,
      }));

      // 3. Calculate Stats Optimized
      const now = new Date();
      const todayStart = new Date(now.setHours(0, 0, 0, 0));
      const yesterdayStart = new Date(new Date(todayStart).setDate(todayStart.getDate() - 1));

      // Use Promise.all for parallel count queries
      const [
        totalCount,
        yesterdayTotalCount,
        todayAppointments,
        yesterdayAppointments
      ] = await Promise.all([
        prisma.patient.count(),
        prisma.patient.count({ where: { registered_at: { lt: todayStart } } }),
        prisma.appointment.count({ where: { appointment_date: { gte: todayStart } } }),
        prisma.appointment.count({ where: { appointment_date: { gte: yesterdayStart, lt: todayStart } } })
      ]);

      const calculatePercent = (current, previous) => {
        if (previous === 0) return current > 0 ? 100 : 0;
        return ((current - previous) / previous * 100).toFixed(1);
      };

      const stats = {
        total_patients: {
          value: totalCount,
          percent_change: calculatePercent(totalCount, yesterdayTotalCount),
          is_increase: totalCount >= yesterdayTotalCount
        },
        appointments: {
          value: todayAppointments,
          percent_change: calculatePercent(todayAppointments, yesterdayAppointments),
          is_increase: todayAppointments >= yesterdayAppointments
        }
      };

      return res.status(200).json({
        success: true,
        data: formattedPatients,
        stats: stats
      });

    } catch (error) {
      console.error('Error listing patients:', error);
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }

  // POST /api/v1/patients
  async createPatient(req, res) {
    let uploadedFilePath = null;
    try {
      const {
        full_name, email, phone, address, country, state, city,
        blood_type, allergies, status, assigned_doctor_id, specialist_department
      } = req.body;

      if (!full_name) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(400).json({ success: false, error: 'Full name is required' });
      }

      let avatarUrl = 'images/avatars-patient/default.jpg';
      if (req.file) {
        uploadedFilePath = req.file.path;
        avatarUrl = `uploads/${req.file.filename}`;
      }

      const newPatient = await prisma.patient.create({
        data: {
          full_name: full_name.trim(),
          email: email ? email.trim() : null,
          phone: phone ? phone.trim() : null,
          address: address ? address.trim() : null,
          country: country || null,
          state: state || null,
          city: city || null,
          blood_type: blood_type || null,
          allergies: allergies || null,
          status: status || 'Under Treatment',
          specialist_department: specialist_department || null,
          assigned_doctor_id: assigned_doctor_id || null,
          avatar_url: avatarUrl,
        },
      });

      return res.status(201).json({ success: true, data: newPatient });

  // PUT /api/v1/patients/:id
  async updatePatient(req, res) {
    let uploadedFilePath = null;
    try {
      const { id } = req.params;
      const updateData = { ...req.body };

      // 1. Check if patient exists
      const existingPatient = await prisma.patient.findUnique({ where: { id } });
      if (!existingPatient) {
        if (req.file) fs.unlinkSync(req.file.path);
        return res.status(404).json({ success: false, error: 'Patient not found' });
      }

      // 2. Validation: Specialist vs Doctor
      if (updateData.specialist_department && updateData.assigned_doctor_id) {
        const doctor = await prisma.doctor.findUnique({
          where: { id: updateData.assigned_doctor_id }
        });
        
        // Specialization in schema is a string, e.g. "Cardiology"
        if (doctor && doctor.specialization && !doctor.specialization.toLowerCase().includes(updateData.specialist_department.toLowerCase())) {
          if (req.file) fs.unlinkSync(req.file.path);
          return res.status(400).json({ 
            success: false, 
            error: `Doctor ${doctor.full_name} does not belong to the ${updateData.specialist_department} department.` 
          });
        }
      }

      // 3. Handle File Upload
      if (req.file) {
        uploadedFilePath = req.file.path;
        updateData.avatar_url = `uploads/${req.file.filename}`;
        
        // Background: Delete old avatar if it's not the default
        if (existingPatient.avatar_url && !existingPatient.avatar_url.includes('default.jpg')) {
          const oldPath = path.join(__dirname, '../../public', existingPatient.avatar_url);
          if (fs.existsSync(oldPath)) fs.unlink(oldPath, () => {});
        }
      }

      // 4. Perform Partial Update
      // Clean up fields that shouldn't be updated or are empty strings
      const cleanedData = {};
      const allowedFields = [
        'full_name', 'email', 'phone', 'address', 'country', 'state', 'city',
        'blood_type', 'allergies', 'status', 'assigned_doctor_id', 'specialist_department', 'avatar_url'
      ];

      allowedFields.forEach(field => {
        if (updateData[field] !== undefined) {
          cleanedData[field] = updateData[field] === '' ? null : updateData[field];
        }
      });

      const updatedPatient = await prisma.patient.update({
        where: { id },
        data: cleanedData,
        include: {
          assigned_doctor: { select: { full_name: true } }
        }
      });

      return res.status(200).json({ success: true, data: updatedPatient });

    } catch (error) {
      console.error('Error updating patient:', error);
      if (uploadedFilePath && fs.existsSync(uploadedFilePath)) {
        fs.unlinkSync(uploadedFilePath);
      }
      return res.status(500).json({ success: false, error: 'Failed to update patient' });
    }
  }
}

module.exports = new PatientController();
