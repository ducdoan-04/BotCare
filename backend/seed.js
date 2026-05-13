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
    { id: 'neurology', name: 'Neurology' },
  ];
  for (const pc of polyclinics) {
    await prisma.polyclinic.upsert({
      where: { id: pc.id },
      update: {},
      create: pc,
    });
  }
  console.log('Polyclinics seeded.');

  // 3. Seed Doctors (Matching Screenshot)
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
    {
      id: 'e5555555-5555-5555-5555-555555555555',
      full_name: 'Dr. Leslie Alexander',
      profile_image_url: 'images/avatars-doctor/avatar-5.jpg',
      gender: 'Female',
      email: 'leslie.alexander@carebot.com',
      phone_number: '+1 (555) 019-7722',
      address: '202 Pediatrics Dr, Chicago',
      specialization: 'Pediatrics',
      experience: '14+ Years',
      education: 'MD from Columbia Medical',
      license_number: 'LIC-772211',
      status: 'Available',
      working_hours: '9AM - 2PM',
      rating: 4.6,
      total_reviews: 150,
      total_patients: 280,
      surgeries: 0,
      patients_increase_percent: 3.1,
    },
  ];

  for (const doc of doctors) {
    await prisma.doctor.upsert({
      where: { id: doc.id },
      update: doc,
      create: doc,
    });
  }
  console.log('Doctors seeded.');

  // 4. Seed Patients (Exact Match for Screenshot)
  const patients = [
    {
      id: 'p1111111-1111-1111-1111-111111111111',
      full_name: 'James Morrison',
      email: 'james.m@example.com',
      phone: '(480) 555-0103',
      address: '6391 Elgin St. Celina, Delaware 10299',
      country: 'United States',
      state: 'Delaware',
      city: 'Celina',
      blood_type: 'O+',
      allergies: 'Peanuts',
      status: 'Under Treatment',
      specialist_department: 'General Practitioner',
      assigned_doctor_id: 'a1111111-1111-1111-1111-111111111111', // Dr. Dianne Russell
      avatar_url: 'images/avatars-patient/avatar-1.jpg',
      registered_at: new Date(),
    },
    {
      id: 'p2222222-2222-2222-2222-222222222222',
      full_name: 'Clara Evans',
      email: 'clara.e@example.com',
      phone: '(406) 555-0120',
      address: '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      country: 'United States',
      state: 'Connecticut',
      city: 'Syracuse',
      blood_type: 'A-',
      allergies: 'None',
      status: 'Recovered',
      specialist_department: 'Dermatology',
      assigned_doctor_id: 'c3333333-3333-3333-3333-333333333333', // Dr. Mona Flores
      avatar_url: 'images/avatars-patient/avatar-2.jpg',
      registered_at: new Date(),
    },
    {
      id: 'p3333333-3333-3333-3333-333333333333',
      full_name: 'Anthony Ramirez',
      email: 'anthony.r@example.com',
      phone: '(208) 555-0112',
      address: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
      country: 'United States',
      state: 'Hawaii',
      city: 'Shiloh',
      blood_type: 'B+',
      allergies: 'Dust',
      status: 'Under Treatment',
      specialist_department: 'Dermatology',
      assigned_doctor_id: 'd4444444-4444-4444-4444-444444444444', // Dr. Alicia Wexer
      avatar_url: 'images/avatars-patient/avatar-3.jpg',
      registered_at: new Date(),
    },
    {
      id: 'p4444444-4444-4444-4444-444444444444',
      full_name: 'Lillian Hart',
      email: 'lillian.h@example.com',
      phone: '(239) 555-0108',
      address: '4140 Parker Rd. Allentown, New Mexico 31134',
      country: 'United States',
      state: 'New Mexico',
      city: 'Allentown',
      blood_type: 'AB-',
      allergies: 'Pollen',
      status: 'Recovered',
      specialist_department: 'Pediatrics',
      assigned_doctor_id: 'e5555555-5555-5555-5555-555555555555', // Dr. Leslie Alexander
      avatar_url: 'images/avatars-patient/avatar-4.jpg',
      registered_at: new Date(),
    },
    {
      id: 'p5555555-5555-5555-5555-555555555555',
      full_name: 'Daniel Novak',
      email: 'daniel.n@example.com',
      phone: '(302) 555-0107',
      address: '2715 Ash Dr. San Jose, South Dakota 83475',
      country: 'United States',
      state: 'South Dakota',
      city: 'San Jose',
      blood_type: 'O-',
      allergies: 'None',
      status: 'Under Treatment',
      specialist_department: 'Cardiology',
      assigned_doctor_id: 'b2222222-2222-2222-2222-222222222222', // Dr. Jacob Jones
      avatar_url: 'images/avatars-patient/avatar-5.jpg',
      registered_at: new Date(),
    },
    {
      id: 'p6666666-6666-6666-6666-666666666666',
      full_name: 'Johan Diserw',
      email: 'johan.d@example.com',
      phone: '(219) 555-0114',
      address: '3891 Ranchview Dr. Richardson, California 62639',
      country: 'United States',
      state: 'California',
      city: 'Richardson',
      blood_type: 'A+',
      allergies: 'None',
      status: 'Under Treatment',
      specialist_department: 'General Practitioner',
      assigned_doctor_id: 'a1111111-1111-1111-1111-111111111111', // Dr. Dianne Russell
      avatar_url: 'images/avatars-patient/avatar-6.jpg',
      registered_at: new Date(),
    },
  ];

  for (const p of patients) {
    await prisma.patient.upsert({
      where: { id: p.id },
      update: p,
      create: p,
    });
  }
  console.log('Patients seeded.');

  // 5. Seed some Appointments (To generate stats)
  const today = new Date();
  const yesterday = new Date();
  yesterday.setDate(today.getDate() - 1);

  // Clear existing appointments to avoid duplication or conflicts if id is not provided
  await prisma.appointment.deleteMany({});

  const apps = [
    {
      doctor_id: 'a1111111-1111-1111-1111-111111111111',
      patient_id: 'p1111111-1111-1111-1111-111111111111',
      patient_name: 'James Morrison',
      consultation_type: 'Routine check up',
      appointment_time: '09:40 AM',
      appointment_date: today,
      category: 'Check-up',
      status: 'Confirm',
    },
    {
      doctor_id: 'b2222222-2222-2222-2222-222222222222',
      patient_id: 'p5555555-5555-5555-5555-555555555555',
      patient_name: 'Daniel Novak',
      consultation_type: 'Heart examination',
      appointment_time: '10:30 AM',
      appointment_date: today,
      category: 'Check-up',
      status: 'Confirm',
    },
    // Seed some for yesterday to show trends
    {
      doctor_id: 'a1111111-1111-1111-1111-111111111111',
      patient_name: 'Past Patient',
      consultation_type: 'Emergency',
      appointment_time: '02:00 PM',
      appointment_date: yesterday,
      category: 'Urgent visit',
      status: 'Confirm',
    },
  ];

  for (const app of apps) {
    await prisma.appointment.create({ data: app });
  }
  console.log('Appointments seeded.');

  // 6. Seed Notifications
  await prisma.notification.deleteMany({});
  const notifications = [
    { title: 'Message from Lucy', message: 'Lucy sent you a secure message.', type: 'message', is_read: false },
    { title: 'New patients added', message: '6 new patients registered in today.', type: 'alert', is_read: true },
    { title: 'Appointments for today', message: 'You have 260 appointments scheduled for today.', type: 'alert', is_read: false },
  ];
  for (const n of notifications) {
    await prisma.notification.create({ data: n });
  }
  console.log('Notifications seeded.');

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
