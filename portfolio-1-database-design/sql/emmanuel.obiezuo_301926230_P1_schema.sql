-- Greenfield Hospital / Clinic database schema
-- PostgreSQL. Run in a new, empty database.

CREATE SCHEMA IF NOT EXISTS hospital;

CREATE TABLE hospital.departments (
    department_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(120)
);

CREATE TABLE hospital.doctors (
    doctor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id BIGINT NOT NULL REFERENCES hospital.departments(department_id),
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE hospital.patients (
    patient_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    date_of_birth DATE NOT NULL CHECK (date_of_birth <= CURRENT_DATE),
    sex VARCHAR(20) NOT NULL CHECK (sex IN ('female', 'male')),
    phone VARCHAR(30),
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hospital.appointments (
    appointment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES hospital.patients(patient_id),
    doctor_id BIGINT NOT NULL REFERENCES hospital.doctors(doctor_id),
    scheduled_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no_show')),
    reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- Prevent two appointments for the same doctor at the exact same time.
    CONSTRAINT uq_doctor_appointment_time UNIQUE (doctor_id, scheduled_at)
);

CREATE TABLE hospital.consultations (
    consultation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id BIGINT NOT NULL UNIQUE REFERENCES hospital.appointments(appointment_id),
    notes TEXT NOT NULL,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
    
);


CREATE TABLE hospital.diagnoses (
    diagnosis_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnosis_code VARCHAR(30) NOT NULL UNIQUE,
    diagnosis_name VARCHAR(150) NOT NULL,
    description VARCHAR(250) NOT NULL
);

CREATE TABLE hospital.consultation_diagnoses (
    consultation_id BIGINT NOT NULL REFERENCES hospital.consultations(consultation_id) ON DELETE CASCADE,
    diagnosis_id BIGINT NOT NULL REFERENCES hospital.diagnoses(diagnosis_id),
    notes TEXT,
    PRIMARY KEY (consultation_id, diagnosis_id)
);

CREATE TABLE hospital.medications (
    medication_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    strength VARCHAR(80) NOT NULL,
    dosage_form VARCHAR(80) NOT NULL
);

CREATE TABLE hospital.prescriptions (
    prescription_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    consultation_id BIGINT NOT NULL REFERENCES hospital.consultations(consultation_id),
    prescribed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    instructions TEXT
);

CREATE TABLE hospital.prescription_items (
    prescription_id BIGINT NOT NULL REFERENCES hospital.prescriptions(prescription_id) ON DELETE CASCADE,
    medication_id BIGINT NOT NULL REFERENCES hospital.medications(medication_id),
    dose VARCHAR(80) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration_days INTEGER CHECK (duration_days IS NULL OR duration_days > 0),
    quantity NUMERIC(10,2) CHECK (quantity IS NULL OR quantity >= 0),
    PRIMARY KEY (prescription_id, medication_id)
);

CREATE TABLE hospital.bills (
    bill_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id BIGINT NOT NULL REFERENCES hospital.patients(patient_id),
    consultation_id BIGINT NOT NULL REFERENCES hospital.consultations(consultation_id),
    billdate TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMPc,
    status VARCHAR(20) NOT NULL DEFAULT 'not-paid' CHECK (status IN ('not-paid', 'paid')),
    CONSTRAINT uq_bill_consultation UNIQUE (consultation_id)
);

CREATE TABLE hospital.bill_items (
    bill_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bill_id BIGINT NOT NULL
        REFERENCES hospital.bills(bill_id) ON DELETE CASCADE,
    description VARCHAR(255) NOT NULL,
    quantity NUMERIC(10,2) NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE hospital.payments   (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bill_id BIGINT NOT NULL REFERENCES hospital.bills(bill_id),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    paid_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(40) NOT NULL
);

-- Baseline indexes. Primary/unique constraints already create supporting indexes.
CREATE INDEX idx_appointments_patient_time ON hospital.appointments(patient_id, scheduled_at DESC);
CREATE INDEX idx_appointments_doctor_time ON hospital.appointments(doctor_id, scheduled_at);
CREATE INDEX idx_consultations_recorded_at ON hospital.consultations(recorded_at DESC);
CREATE INDEX idx_lab_orders_consultation ON hospital.lab_orders(consultation_id);
CREATE INDEX idx_prescriptions_consultation ON hospital.prescriptions (consultation_id);
CREATE INDEX idx_bill_items_bill ON hospital.bill_items (bill_id);
CREATE INDEX idx_payments_bill ON hospital.payments (bill_id);
