-- Insert sample data into the patients table
INSERT INTO hospital.patients (
    first_name,
    last_name,
    date_of_birth,
    sex,
    phone,
    email
)
VALUES (
    'Joe',
    'Doe',
    '1998-05-15',
    'male',
    '08012345678',
    'joe.doe@example.com'
);



-- Insert multiple appointments for a patient into database
INSERT INTO hospital.appointments (
    patient_id,
    doctor_id,
    scheduled_at
)
SELECT
    1 AS patient_id,
    d.doctor_id,
    NOW() - (n * INTERVAL '1 day') AS scheduled_at
FROM generate_series(1, 5000) AS n
JOIN (
    SELECT
        doctor_id,
        ROW_NUMBER() OVER (ORDER BY doctor_id) AS doctor_number,
        COUNT(*) OVER () AS total_doctors
    FROM hospital.doctors
) AS d
    ON d.doctor_number = ((n - 1) % d.total_doctors) + 1
WHERE EXISTS (
    SELECT 1
    FROM hospital.patients
    WHERE patient_id = 1
);


BEGIN;

-- STEP 1: Insert five sample patients
WITH new_patients AS (
    INSERT INTO hospital.patients (
        first_name,
        last_name,
        date_of_birth,
        sex,
        phone,
        email
    )
    VALUES
        ('John', 'Doe', '1990-04-12', 'male',
         '08030000001', 'john.doe.demo@example.com'),

        ('Mary', 'James', '1985-08-21', 'female',
         '08030000002', 'mary.james.demo@example.com'),

        ('David', 'Okafor', '2000-01-15', 'male',
         '08030000003', 'david.okafor.demo@example.com'),

        ('Grace', 'Adebayo', '1995-11-30', 'female',
         '08030000004', 'grace.adebayo.demo@example.com'),

        ('Peter', 'Musa', '1978-06-05', 'male',
         '08030000005', 'peter.musa.demo@example.com')

    RETURNING patient_id
)
SELECT patient_id
FROM new_patients;

-- STEP 2: Schedule appointments for the new patients
-- This assumes appointments has:
-- appointment_id, patient_id, doctor_id, scheduled_at
WITH new_patients AS (
    SELECT patient_id
    FROM hospital.patients
    WHERE email IN (
        'john.doe.demo@example.com',
        'mary.james.demo@example.com',
        'david.okafor.demo@example.com',
        'grace.adebayo.demo@example.com',
        'peter.musa.demo@example.com'
    )
),
available_doctors AS (
    SELECT doctor_id,
           ROW_NUMBER() OVER (ORDER BY doctor_id) AS rn
    FROM hospital.doctors
),
numbered_patients AS (
    SELECT patient_id,
           ROW_NUMBER() OVER (ORDER BY patient_id) AS rn
    FROM new_patients
)
INSERT INTO hospital.appointments (
    patient_id,
    doctor_id,
    scheduled_at
)
SELECT
    p.patient_id,
    d.doctor_id,
    CURRENT_TIMESTAMP + (p.rn * INTERVAL '1 day')
FROM numbered_patients p
JOIN available_doctors d
    ON d.rn = ((p.rn - 1) %
       (SELECT COUNT(*) FROM available_doctors)) + 1;

-- STEP 3: Check the appointments created
SELECT *
FROM hospital.appointments
ORDER BY scheduled_at DESC;

COMMIT;
