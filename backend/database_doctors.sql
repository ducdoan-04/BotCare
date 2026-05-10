-- Create doctors table
CREATE TABLE "doctors" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "full_name" TEXT NOT NULL,
    "profile_image_url" TEXT,
    "gender" TEXT,
    "email" TEXT,
    "phone_number" TEXT,
    "address" TEXT,
    "specialization" TEXT,
    "experience" TEXT,
    "education" TEXT,
    "license_number" TEXT,
    "status" TEXT NOT NULL DEFAULT 'Available',
    "working_hours" TEXT DEFAULT '9AM - 2PM',
    "rating" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "total_reviews" INTEGER NOT NULL DEFAULT 0,
    "total_patients" INTEGER NOT NULL DEFAULT 0,
    "surgeries" INTEGER NOT NULL DEFAULT 0,
    "patients_increase_percent" DOUBLE PRECISION NOT NULL DEFAULT 0.0,

    CONSTRAINT "doctors_pkey" PRIMARY KEY ("id")
);

-- Create appointments table
CREATE TABLE "appointments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "doctor_id" UUID NOT NULL,
    "patient_name" TEXT NOT NULL,
    "consultation_type" TEXT NOT NULL,
    "appointment_time" TEXT NOT NULL,
    "category" TEXT NOT NULL, -- 'Check-up', 'Urgent visit'
    "status" TEXT NOT NULL, -- 'Confirm', 'Canceled', 'Pending'

    CONSTRAINT "appointments_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "appointments_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("id") ON DELETE CASCADE
);

-- Create availability_slots table
CREATE TABLE "availability_slots" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "doctor_id" UUID NOT NULL,
    "time_slot" TEXT NOT NULL,
    "is_booked" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "availability_slots_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "availability_slots_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("id") ON DELETE CASCADE
);

-- Insert Seed Data for Doctors
INSERT INTO "doctors" (
    "id", "full_name", "profile_image_url", "gender", "email", "phone_number", "address", 
    "specialization", "experience", "education", "license_number", "status", "working_hours", 
    "rating", "total_reviews", "total_patients", "surgeries", "patients_increase_percent"
) VALUES 
('a1111111-1111-1111-1111-111111111111', 'Dr. Dianne Russell', 'images/doctors/dianne_russell.jpg', 'Female', 'dianne.russell@carebot.com', '+1 (555) 019-2834', '123 Medical Center Dr, NY', 'General Practitioner', '12+ Years', 'MD from Harvard Medical School', 'LIC-908273', 'Available', '9AM - 2PM', 4.8, 150, 230, 90, 3.5),
('b2222222-2222-2222-2222-222222222222', 'Dr. Jacob Jones', 'images/doctors/jacob_jones.jpg', 'Male', 'jacob.jones@carebot.com', '+1 (555) 019-5829', '456 Cardiovascular Ave, LA', 'Cardiology', '15+ Years', 'PhD in Cardiology, Stanford University', 'LIC-582910', 'Available', '9AM - 2PM', 4.9, 198, 340, 150, 5.2),
('c3333333-3333-3333-3333-333333333333', 'Dr. Mona Flores', 'images/doctors/mona_flores.jpg', 'Female', 'mona.flores@carebot.com', '+1 (555) 019-3829', '789 Skin Care Lane, SF', 'Dermatology', '8+ Years', 'MD from Johns Hopkins School of Medicine', 'LIC-192837', 'Available', '9AM - 2PM', 4.5, 120, 185, 45, 2.1),
('d4444444-4444-4444-4444-444444444444', 'Dr. Alicia Wexer', 'images/doctors/alicia_wexer.jpg', 'Female', 'alicia.wexer@carebot.com', '+1 (555) 019-9028', '101 Dermatology Way, SF', 'Dermatology', '10+ Years', 'MD from Yale University', 'LIC-102938', 'Available', '9AM - 2PM', 4.7, 135, 210, 60, 4.0);

-- Insert Seed Data for Appointments (for Dr. Dianne Russell)
INSERT INTO "appointments" ("doctor_id", "patient_name", "consultation_type", "appointment_time", "category", "status") VALUES 
('a1111111-1111-1111-1111-111111111111', 'Leslie Alexander', 'Routine check up', '09:40 AM', 'Check-up', 'Confirm'),
('a1111111-1111-1111-1111-111111111111', 'Leslie Alexander', 'Routine check up', '09:40 AM', 'Check-up', 'Canceled'),
('a1111111-1111-1111-1111-111111111111', 'Leslie Alexander', 'Routine check up', '09:40 AM', 'Check-up', 'Canceled'),
('a1111111-1111-1111-1111-111111111111', 'Leslie Alexander', 'Routine check up', '09:40 AM', 'Check-up', 'Pending'),
('a1111111-1111-1111-1111-111111111111', 'Savannah Nguyen', 'Dermatology consultation', '09:40 AM', 'Urgent visit', 'Pending'),
('a1111111-1111-1111-1111-111111111111', 'Savannah Nguyen', 'Dermatology consultation', '09:40 AM', 'Urgent visit', 'Confirm'),
('a1111111-1111-1111-1111-111111111111', 'Savannah Nguyen', 'Dermatology consultation', '09:40 AM', 'Urgent visit', 'Confirm'),
('a1111111-1111-1111-1111-111111111111', 'Savannah Nguyen', 'Dermatology consultation', '09:40 AM', 'Urgent visit', 'Confirm');

-- Insert Seed Data for Availability Slots (for Dr. Dianne Russell)
INSERT INTO "availability_slots" ("doctor_id", "time_slot", "is_booked") VALUES 
('a1111111-1111-1111-1111-111111111111', '09.00:AM', true),
('a1111111-1111-1111-1111-111111111111', '09.30:AM', false),
('a1111111-1111-1111-1111-111111111111', '10.00:AM', false),
('a1111111-1111-1111-1111-111111111111', '10.30:AM', false),
('a1111111-1111-1111-1111-111111111111', '11.30:AM', false),
('a1111111-1111-1111-1111-111111111111', '12.00:PM', true),
('a1111111-1111-1111-1111-111111111111', '02.00:PM', false),
('a1111111-1111-1111-1111-111111111111', '02.30:PM', false);
