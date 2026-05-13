const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  // 1. Seed User
  const email = 'receptionist@carebot.com';
  const password = 'password123';
  const existingUser = await prisma.user.findUnique({ where: { email } });

  if (!existingUser) {
    const salt = await bcrypt.genSalt(10);
    const password_hash = await bcrypt.hash(password, salt);
    await prisma.user.create({
      data: {
        username: 'nola_hawkins',
        email,
        password_hash,
        full_name: 'Nola Hawkins',
        role: 'RECEPTIONIST',
      },
    });
    console.log(`Created default user: ${email} / ${password}`);
  } else {
    console.log('Default user already exists');
  }

  // 2. Seed Polyclinics
  const polyclinics = [
    { id: 'general', name: 'General' },
    { id: 'pediatrics', name: 'Pediatrics' },
    { id: 'cardiology', name: 'Cardiology' },
    { id: 'dermatology', name: 'Dermatology' },
  ];
  for (const pc of polyclinics) {
    await prisma.polyclinic.upsert({
      where: { id: pc.id },
      update: {},
      create: pc,
    });
  }
  console.log('Polyclinics seeded.');

  // 3. Seed Doctors
  const doctors = [
    {
      id: 'a1111111-1111-1111-1111-111111111111',
      full_name: 'Dr. Dianne Russell',
      profile_image_url: 'images/avatars-doctor/avatar-1.jpg',
      gender: 'Female',
      email: 'dianne.russell@carebot.com',
      phone_number: '+1 (555) 019-2834',
      address: '123 Medical Center Dr, NY',
      specialization: 'General Practitioner',
      experience: '12+ Years',
      education: 'MD from Harvard Medical School',
      license_number: 'LIC-908273',
      status: 'Available',
      working_hours: '9AM - 2PM',
      rating: 4.8,
      total_reviews: 120,
      total_patients: 230,
      surgeries: 90,
      patients_increase_percent: 3.5,
    },
    {
      id: 'b2222222-2222-2222-2222-222222222222',
      full_name: 'Dr. Jacob Jones',
      profile_image_url: 'images/avatars-doctor/avatar-2.jpg',
      gender: 'Male',
      email: 'jacob.jones@carebot.com',
      phone_number: '+1 (555) 019-5829',
      address: '456 Cardiovascular Ave, LA',
      specialization: 'Cardiology',
      experience: '15+ Years',
      education: 'PhD in Cardiology, Stanford University',
      license_number: 'LIC-582910',
      status: 'Available',
      working_hours: '9AM - 2PM',
      rating: 4.9,
      total_reviews: 198,
      total_patients: 340,
      surgeries: 150,
      patients_increase_percent: 5.2,
    },
    {
      id: 'c3333333-3333-3333-3333-333333333333',
      full_name: 'Dr. Mona Flores',
      profile_image_url: 'images/avatars-doctor/avatar-3.jpg',
      gender: 'Female',
      email: 'mona.flores@carebot.com',
      phone_number: '+1 (555) 019-3829',
      address: '789 Skin Care Lane, SF',
      specialization: 'Dermatology',
      experience: '8+ Years',
      education: 'MD from Johns Hopkins School of Medicine',
      license_number: 'LIC-192837',
      status: 'Available',
      working_hours: '9AM - 2PM',
      rating: 4.5,
      total_reviews: 120,
      total_patients: 185,
      surgeries: 45,
      patients_increase_percent: 2.1,
    },
    {
      id: 'd4444444-4444-4444-4444-444444444444',
      full_name: 'Dr. Alicia Wexer',
      profile_image_url: 'images/avatars-doctor/avatar-4.jpg',
      gender: 'Female',
      email: 'alicia.wexer@carebot.com',
      phone_number: '+1 (555) 019-9028',
      address: '101 Dermatology Way, SF',
      specialization: 'Dermatology',
      experience: '10+ Years',
      education: 'MD from Yale University',
      license_number: 'LIC-102938',
      status: 'Available',
      working_hours: '9AM - 2PM',
      rating: 4.7,
      total_reviews: 135,
      total_patients: 210,
      surgeries: 60,
      patients_increase_percent: 4.0,
    },
  ];

  for (const doc of doctors) {
    await prisma.doctor.upsert({
      where: { id: doc.id },
      update: {},
      create: doc,
    });

    // Create default slots for each doctor if they don't have slots
    const slotCount = await prisma.availabilitySlot.count({ where: { doctor_id: doc.id } });
    if (slotCount === 0) {
      const defaultSlots = [
        '09.00:AM',
        '09.30:AM',
        '10.00:AM',
        '10.30:AM',
        '11.30:AM',
        '12.00:PM',
        '02.00:PM',
        '02.30:PM',
      ];
      await Promise.all(
        defaultSlots.map((slot) =>
          prisma.availabilitySlot.create({
            data: {
              doctor_id: doc.id,
              time_slot: slot,
              is_booked: slot === '09.00:AM' || slot === '12.00:PM',
            },
          })
        )
      );
    }
  }
  console.log('Doctors and availability slots seeded.');

  // 4. Seed some Appointments (for Dianne Russell)
  const appCount = await prisma.appointment.count();
  if (appCount === 0) {
    const apps = [
      {
        doctor_id: 'a1111111-1111-1111-1111-111111111111',
        patient_name: 'Leslie Alexander',
        consultation_type: 'Routine check up',
        appointment_time: '09:40 AM',
        category: 'Check-up',
        status: 'Confirm',
      },
      {
        doctor_id: 'a1111111-1111-1111-1111-111111111111',
        patient_name: 'Leslie Alexander',
        consultation_type: 'Routine check up',
        appointment_time: '09:40 AM',
        category: 'Check-up',
        status: 'Canceled',
      },
      {
        doctor_id: 'a1111111-1111-1111-1111-111111111111',
        patient_name: 'Leslie Alexander',
        consultation_type: 'Routine check up',
        appointment_time: '09:40 AM',
        category: 'Check-up',
        status: 'Pending',
      },
      {
        doctor_id: 'a1111111-1111-1111-1111-111111111111',
        patient_name: 'Savannah Nguyen',
        consultation_type: 'Dermatology consultation',
        appointment_time: '09:40 AM',
        category: 'Urgent visit',
        status: 'Confirm',
      },
    ];

    for (const app of apps) {
      await prisma.appointment.create({ data: app });
    }
    console.log('Appointments seeded.');
  }

  // 5. Seed Patients
  const patientCount = await prisma.patient.count();
  if (patientCount === 0) {
    const patients = [
      { name: 'Leslie Alexander', status: 'under_treatment' },
      { name: 'Savannah Nguyen', status: 'recovered' },
    ];
    for (const p of patients) {
      await prisma.patient.create({ data: p });
    }
    console.log('Patients seeded.');
  }

  // 6. Seed Notifications
  const notifCount = await prisma.notification.count();
  if (notifCount === 0) {
    const notifications = [
      { title: 'Message from Lucy', message: 'Lucy sent you a secure message.', type: 'message', is_read: false },
      { title: 'New patients added', message: '3 new patients registered in general ward.', type: 'alert', is_read: true },
      { title: 'Your leave is approved', message: 'HR approved your personal leave request.', type: 'alert', is_read: false },
    ];
    for (const n of notifications) {
      await prisma.notification.create({ data: n });
    }
    console.log('Notifications seeded.');
  }

  console.log('Database seeded successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
