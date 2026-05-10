-- Drop tables if they exist (cascade)
DROP TABLE IF EXISTS "appointments" CASCADE;
DROP TABLE IF EXISTS "doctors" CASCADE;
DROP TABLE IF EXISTS "patients" CASCADE;
DROP TABLE IF EXISTS "notifications" CASCADE;
DROP TABLE IF EXISTS "polyclinics" CASCADE;

-- Create Polyclinics table
CREATE TABLE "polyclinics" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    CONSTRAINT "polyclinics_pkey" PRIMARY KEY ("id")
);

-- Create Doctors table
CREATE TABLE "doctors" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "next_available" TEXT,
    "avatar" TEXT,
    "polyclinic_id" TEXT,
    CONSTRAINT "doctors_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "doctors_polyclinic_id_fkey" FOREIGN KEY ("polyclinic_id") REFERENCES "polyclinics"("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- Create Patients table
CREATE TABLE "patients" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "registered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- Create Appointments table
CREATE TABLE "appointments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "patient_id" UUID NOT NULL,
    "doctor_id" UUID NOT NULL,
    "reason" TEXT NOT NULL,
    "time" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    CONSTRAINT "appointments_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "appointments_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "appointments_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Create Notifications table
CREATE TABLE "notifications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- ==========================================
-- SEED DATA
-- ==========================================

-- Seed Polyclinics
INSERT INTO "polyclinics" ("id", "name") VALUES
('general', 'General'),
('pediatrics', 'Pediatrics'),
('cardiology', 'Cardiology'),
('dermatology', 'Dermatology');

-- Seed Doctors
INSERT INTO "doctors" ("id", "name", "status", "next_available", "avatar", "polyclinic_id") VALUES
('10000000-0000-0000-0000-000000000001', 'DR. Johan Henry', 'available', NULL, 'images/doctors/johan_henry.jpg', 'general'),
('10000000-0000-0000-0000-000000000002', 'DR. David Cooper', 'available', NULL, 'images/doctors/david_cooper.jpg', 'cardiology'),
('10000000-0000-0000-0000-000000000003', 'DR. Brooklyn Simmons', 'available', '2:30 PM', 'images/doctors/brooklyn_simmons.jpg', 'dermatology'),
('10000000-0000-0000-0000-000000000004', 'DR. Theresa Webb', 'available', '2:35 PM', 'images/doctors/theresa_webb.jpg', 'pediatrics');

-- To get total doctors to 120 (for dashboard count), let's insert dummy doctors or handle aggregated counts dynamically.
-- We can seed exactly 120 doctors, or write a query that returns 120 using SQL math or seed data.
-- Let's insert a loop of dummy doctors in Postgres:
DO $$
BEGIN
    FOR i IN 5..120 LOOP
        INSERT INTO "doctors" ("id", "name", "status", "next_available", "avatar", "polyclinic_id") 
        VALUES (
            gen_random_uuid(), 
            'DR. Dummy ' || i, 
            CASE WHEN i % 5 = 0 THEN 'away' ELSE 'available' END, 
            NULL, 
            NULL, 
            CASE 
                WHEN i % 4 = 0 THEN 'general'
                WHEN i % 4 = 1 THEN 'pediatrics'
                WHEN i % 4 = 2 THEN 'cardiology'
                ELSE 'dermatology'
            END
        );
    END LOOP;
END $$;

-- Seed Patients
-- Need Wed to Sun trend data
-- Wed under_treatment=75, recovered=52
-- Thu under_treatment=72, recovered=48
-- Fri under_treatment=85, recovered=58
-- Sat under_treatment=78, recovered=54
-- Sun under_treatment=70, recovered=61
-- Let's insert patients with exact registered dates
-- Assuming CURRENT_TIMESTAMP is Sunday, we backdate them:
DO $$
DECLARE
    today DATE := CURRENT_DATE;
BEGIN
    -- Wed (today - 4)
    FOR i IN 1..75 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'under_treatment', today - INTERVAL '4 days');
    END LOOP;
    FOR i IN 1..52 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'recovered', today - INTERVAL '4 days');
    END LOOP;

    -- Thu (today - 3)
    FOR i IN 1..72 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'under_treatment', today - INTERVAL '3 days');
    END LOOP;
    FOR i IN 1..48 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'recovered', today - INTERVAL '3 days');
    END LOOP;

    -- Fri (today - 2)
    FOR i IN 1..85 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'under_treatment', today - INTERVAL '2 days');
    END LOOP;
    FOR i IN 1..58 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'recovered', today - INTERVAL '2 days');
    END LOOP;

    -- Sat (today - 1)
    FOR i IN 1..78 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'under_treatment', today - INTERVAL '1 day');
    END LOOP;
    FOR i IN 1..54 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'recovered', today - INTERVAL '1 day');
    END LOOP;

    -- Sun (today)
    FOR i IN 1..70 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'under_treatment', today);
    END LOOP;
    FOR i IN 1..61 LOOP
        INSERT INTO "patients" ("name", "status", "registered_at") VALUES ('Patient ' || i, 'recovered', today);
    END LOOP;
END $$;

-- Seed Upcoming Appointments
-- Let's get 4 specific patients for the upcoming appointments
INSERT INTO "patients" ("id", "name", "status", "registered_at") VALUES
('20000000-0000-0000-0000-000000000001', 'Jacob Jones', 'under_treatment', CURRENT_TIMESTAMP),
('20000000-0000-0000-0000-000000000002', 'Jenny Wilson', 'under_treatment', CURRENT_TIMESTAMP);

INSERT INTO "appointments" ("id", "patient_id", "doctor_id", "reason", "time", "status") VALUES
(gen_random_uuid(), '20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'Headache Disease', CURRENT_DATE + TIME '09:40:00', 'pending'),
(gen_random_uuid(), '20000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000004', 'Abdominal Pain', CURRENT_DATE + TIME '10:40:00', 'pending'),
(gen_random_uuid(), '20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000003', 'Swelling', CURRENT_DATE + TIME '11:20:00', 'pending'),
(gen_random_uuid(), '20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000002', 'Cardiology', CURRENT_DATE + TIME '12:10:00', 'pending');

-- Seed more dummy appointments to total 260
DO $$
BEGIN
    FOR i IN 5..260 LOOP
        INSERT INTO "appointments" ("patient_id", "doctor_id", "reason", "time", "status") VALUES (
            '20000000-0000-0000-0000-000000000001',
            '10000000-0000-0000-0000-000000000001',
            'General Checkup ' || i,
            CURRENT_DATE - (i % 30) * INTERVAL '1 day' + (i % 8) * INTERVAL '1 hour',
            'completed'
        );
    END LOOP;
END $$;

-- Seed Notifications
INSERT INTO "notifications" ("title", "message", "type", "created_at", "is_read") VALUES
('Message from Lucy', 'Lucy sent you a secure message.', 'message', CURRENT_TIMESTAMP - INTERVAL '32 minutes', false),
('New patients added', '3 new patients registered in general ward.', 'alert', CURRENT_TIMESTAMP - INTERVAL '1 hour', true),
('Your leave is approved', 'HR approved your personal leave request.', 'alert', CURRENT_TIMESTAMP - INTERVAL '2 hours', false),
('Jacob recob file.pdf', 'New diagnostic files shared.', 'document', CURRENT_TIMESTAMP - INTERVAL '4 hours', true),
('Message from Jacob', 'Jacob responded to your prescription query.', 'message', CURRENT_TIMESTAMP - INTERVAL '32 minutes', false);
