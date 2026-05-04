import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

export const getDashboardData = query({
  args: {},
  handler: async (ctx) => {
    const doctors = await ctx.db.query("doctors").order("desc").collect();
    const patients = await ctx.db.query("patients").order("desc").collect();
    const appointments = await ctx.db.query("appointments").order("desc").collect();
    const polyclinics = await ctx.db.query("polyclinics").order("desc").collect();
    const notifications = await ctx.db.query("notifications").order("desc").collect();

    return {
      doctors,
      patients,
      appointments,
      polyclinics,
      notifications
    };
  },
});

export const seedDashboardData = mutation({
  args: {},
  handler: async (ctx) => {
    const now = Date.now();

    // 1. Seed Doctors
    const doctorsData = [
      { name: "DR. Johan Henry", specialty: "General Practitioners", availability: "Available", createdAt: now },
      { name: "DR. David Cooper", specialty: "Cardiology", availability: "Available", createdAt: now + 1000 },
      { name: "DR. Brooklyn Simmons", specialty: "Dermatology", availability: "Available at 2:30 PM", createdAt: now + 2000 },
      { name: "DR. Theresa Webb", specialty: "Pediatrics", availability: "Available at 2:35 PM", createdAt: now + 3000 },
    ];
    for (const doc of doctorsData) await ctx.db.insert("doctors", doc);

    // 2. Seed Patients
    const patientsData = [
      { status: "under_treatment", date: "Wed", createdAt: now },
      { status: "under_treatment", date: "Thu", createdAt: now + 1000 },
      { status: "recovered", date: "Fri", createdAt: now + 2000 },
      { status: "recovered", date: "San", createdAt: now + 3000 }, // Typo in UI image "San" instead of Sun/Sat
    ];
    for (const p of patientsData) await ctx.db.insert("patients", p);

    // 3. Seed Appointments
    const appointmentsData = [
      { patientName: "Jacob Jones", disease: "Headache Disease", time: "Today 09:40 AM", createdAt: now },
      { patientName: "Jenny Wilson", disease: "Abdominal Pain", time: "Today 10:40 AM", createdAt: now + 1000 },
      { patientName: "Jacob Jones", disease: "Swelling", time: "Today 11:20 AM", createdAt: now + 2000 },
      { patientName: "Jacob Jones", disease: "Cardiology", time: "Today 12:10 PM", createdAt: now + 3000 },
    ];
    for (const app of appointmentsData) await ctx.db.insert("appointments", app);

    // 4. Seed Polyclinics
    const polyclinicsData = [
      { name: "General", patientCount: 80, createdAt: now },
      { name: "Pediatrics", patientCount: 50, createdAt: now + 1000 },
      { name: "Cardiology", patientCount: 40, createdAt: now + 2000 },
      { name: "Dermatology", patientCount: 30, createdAt: now + 3000 },
    ];
    for (const poly of polyclinicsData) await ctx.db.insert("polyclinics", poly);

    // 5. Seed Notifications
    const notificationsData = [
      { title: "Message from Lucy", timeString: "32 minutes ago", type: "message", isRead: false, createdAt: now },
      { title: "New patients added", timeString: "1 hours ago", type: "new_patient", isRead: true, createdAt: now + 1000 },
      { title: "Your leave is approved", timeString: "2 hours ago", type: "leave_approved", isRead: false, createdAt: now + 2000 },
      { title: "Jacob receb file.pdf", timeString: "4 hours ago", type: "file", isRead: true, createdAt: now + 3000 },
      { title: "Message from Jacob", timeString: "32 minutes ago", type: "message", isRead: false, createdAt: now + 4000 },
    ];
    for (const notif of notificationsData) await ctx.db.insert("notifications", notif);

    return "Seeded Successfully";
  }
});
