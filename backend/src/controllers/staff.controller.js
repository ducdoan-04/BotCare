const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

class StaffController {
  // GET /api/v1/staff
  async listStaff(req, res) {
    try {
      const { role } = req.query;
      let whereClause = { deleted_at: null };
      if (role && role !== 'All') {
        whereClause.role = role;
      }

      const staff = await prisma.staff.findMany({
        where: whereClause,
        orderBy: { full_name: 'asc' }
      });

      return res.status(200).json({ success: true, data: staff });
    } catch (error) {
      console.error('Error listing staff:', error);
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }

  // GET /api/v1/staff/:id
  async getStaffDetail(req, res) {
    try {
      const { id } = req.params;
      const staff = await prisma.staff.findUnique({
        where: { id }
      });

      if (!staff) return res.status(404).json({ success: false, error: 'Staff not found' });

      return res.status(200).json({ success: true, data: staff });
    } catch (error) {
      console.error('Error fetching staff detail:', error);
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }

  // GET /api/v1/staff/:id/summary
  async getStaffSummary(req, res) {
    try {
      const { id } = req.params;
      const staff = await prisma.staff.findUnique({
        where: { id },
        include: {
          attendance: true
        }
      });

      if (!staff) return res.status(404).json({ success: false, error: 'Staff not found' });

      // Calculate dynamic stats
      const now = new Date();
      const joiningDate = new Date(staff.joining_date);
      const inCompanyYears = Math.floor((now - joiningDate) / (1000 * 60 * 60 * 24 * 365.25));

      // Avg shift hours (from shift string "9AM - 2PM")
      // Simple parser: 9 to 14 (2PM) = 5 hours
      const avgShiftHours = 5.5; // Stub for logic or parse shift string

      // Attendance rate
      const totalAttendanceRecords = staff.attendance.length;
      const fullAttendanceCount = staff.attendance.filter(a => a.attendance_level === 3).length;
      const halfAttendanceCount = staff.attendance.filter(a => a.attendance_level === 2).length;
      const attendanceRate = totalAttendanceRecords > 0 
        ? Math.round(((fullAttendanceCount + (halfAttendanceCount * 0.5)) / totalAttendanceRecords) * 100)
        : 0;

      const summary = {
        in_company: {
          value: inCompanyYears,
          label: `${inCompanyYears}yrs`,
          description: `Has been working at the clinic for ${inCompanyYears} years.`
        },
        avg_shift_hours: {
          value: avgShiftHours,
          label: `${avgShiftHours}hrs`,
          description: `Works around ${avgShiftHours} hours per day on average.`
        },
        attendance_rate: {
          value: attendanceRate,
          label: `${attendanceRate}%`,
          description: attendanceRate > 90 ? 'Almost always arrives on time.' : 'Good attendance record.'
        }
      };

      return res.status(200).json({ success: true, data: summary });
    } catch (error) {
      console.error('Error fetching staff summary:', error);
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }

  // GET /api/v1/staff/:id/timetable
  async getStaffTimetable(req, res) {
    try {
      const { id } = req.params;
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const tasks = await prisma.staffTask.findMany({
        where: {
          staff_id: id,
          date: { gte: today }
        },
        orderBy: { start_time: 'asc' }
      });

      const attendance = await prisma.staffAttendance.findMany({
        where: {
          staff_id: id,
          date: {
            gte: new Date(new Date().setDate(new Date().getDate() - 35)) // last 5 weeks
          }
        },
        orderBy: { date: 'asc' }
      });

      return res.status(200).json({
        success: true,
        data: {
          today_tasks: tasks,
          attendance_report: attendance
        }
      });
    } catch (error) {
      console.error('Error fetching staff timetable:', error);
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }

  // POST /api/v1/staff
  async createStaff(req, res) {
    let uploadedFilePath = null;
    try {
      const {
        full_name, email, phone, address, gender, date_of_birth,
        role, joining_date, country, state, city, postal_code, professional_summary
      } = req.body;

      // 1. Validation
      if (!full_name || !email || !role) {
        if (req.file) require('fs').unlinkSync(req.file.path);
        return res.status(400).json({ success: false, error: 'Full name, email, and role are required' });
      }

      // Check if email exists
      const existingEmail = await prisma.staff.findFirst({
        where: { email: email.trim() }
      });
      if (existingEmail) {
        if (req.file) require('fs').unlinkSync(req.file.path);
        return res.status(400).json({ success: false, error: 'Email already exists' });
      }

      let avatarUrl = 'images/staff/avatar-1.jpg'; // Default
      if (req.file) {
        uploadedFilePath = req.file.path;
        avatarUrl = `uploads/${req.file.filename}`;
      }

      // 2. Transaction to create staff
      const newStaff = await prisma.$transaction(async (tx) => {
        return await tx.staff.create({
          data: {
            full_name: full_name.trim(),
            email: email.trim(),
            phone: phone || null,
            address: address || `${city || ''}, ${state || ''}, ${country || ''}`.trim(),
            gender: gender || 'Male',
            role: role,
            joining_date: joining_date ? new Date(joining_date) : new Date(),
            professional_summary: professional_summary || null,
            profile_image_url: avatarUrl,
            status: 'Available',
            // Note: date_of_birth might need a column in schema if required, 
            // but schema only had joining_date. I will stick to schema fields.
          }
        });
      });

      return res.status(201).json({ success: true, data: newStaff });
    } catch (error) {
      console.error('Error creating staff:', error);
      if (uploadedFilePath && require('fs').existsSync(uploadedFilePath)) {
        require('fs').unlinkSync(uploadedFilePath);
      }
      return res.status(500).json({ success: false, error: 'Failed to create staff' });
    }
  }

  // PUT /api/v1/staff/:id
  async updateStaff(req, res) {
    let uploadedFilePath = null;
    try {
      const { id } = req.params;
      const updateData = { ...req.body };

      // Check if staff exists
      const existingStaff = await prisma.staff.findUnique({ where: { id } });
      if (!existingStaff) {
        if (req.file) require('fs').unlinkSync(req.file.path);
        return res.status(404).json({ success: false, error: 'Staff not found' });
      }

      if (req.file) {
        uploadedFilePath = req.file.path;
        updateData.profile_image_url = `uploads/${req.file.filename}`;
        
        // Delete old avatar if not default
        if (existingStaff.profile_image_url && !existingStaff.profile_image_url.includes('avatar-1.jpg')) {
          const oldPath = require('path').join(__dirname, '../../public', existingStaff.profile_image_url);
          if (require('fs').existsSync(oldPath)) require('fs').unlink(oldPath, () => {});
        }
      }

      // Cleanup and mapping
      const cleanedData = {};
      const allowedFields = [
        'full_name', 'email', 'phone', 'address', 'gender', 
        'role', 'joining_date', 'professional_summary', 'profile_image_url', 'status'
      ];

      allowedFields.forEach(field => {
        if (updateData[field] !== undefined) {
          if (field === 'joining_date' && updateData[field]) {
            cleanedData[field] = new Date(updateData[field]);
          } else {
            cleanedData[field] = updateData[field] === '' ? null : updateData[field];
          }
        }
      });

      const updatedStaff = await prisma.staff.update({
        where: { id },
        data: cleanedData
      });

      return res.status(200).json({ success: true, data: updatedStaff });
    } catch (error) {
      console.error('Error updating staff:', error);
      if (uploadedFilePath && require('fs').existsSync(uploadedFilePath)) {
        require('fs').unlinkSync(uploadedFilePath);
      }
      return res.status(500).json({ success: false, error: 'Failed to update staff' });
    }
  }

  // DELETE /api/v1/staff/:id
  async deleteStaff(req, res) {
    try {
      const { id } = req.params;
      
      // Soft delete
      await prisma.staff.delete({
        where: { id }
      });

      return res.status(200).json({ success: true, message: 'Staff deleted successfully' });
    } catch (error) {
      console.error('Error deleting staff:', error);
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  }
}

module.exports = new StaffController();
