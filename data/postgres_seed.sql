-- Fictional sample data only. Run after 01_schema.sql.
INSERT INTO departments(name, location) VALUES
 ('General Practice', 'Block A'),
 ('Laboratory', 'Block B'),
 ('Paediatrics', 'Block A');

INSERT INTO doctors(department_id, first_name, last_name, email, specialty)
SELECT department_id, 'Ada', 'Okafor', 'ada.okafor@example.test', 'General Practitioner'
FROM departments WHERE name = 'General Practice';
INSERT INTO doctors(department_id, first_name, last_name, email, specialty)
SELECT department_id, 'Tunde', 'Bello', 'tunde.bello@example.test', 'Paediatrician'
FROM departments WHERE name = 'Paediatrics';

INSERT INTO patients(first_name, last_name, date_of_birth, sex, phone, email) VALUES
 ('Mina', 'Adebayo', '1994-04-12', 'female', '08000000001', 'mina.adebayo@example.test'),
 ('Jonah', 'Eze', '1987-09-03', 'male', '08000000002', 'jonah.eze@example.test'),
 ('Lara', 'James', '2017-02-18', 'female', '08000000003', 'lara.james@example.test');

INSERT INTO appointments(patient_id, doctor_id, scheduled_at, status, reason)
SELECT p.patient_id, d.doctor_id, v.scheduled_at::timestamptz, v.status, v.reason
FROM (VALUES
 ('mina.adebayo@example.test', 'ada.okafor@example.test', '2026-10-12 09:00+01', 'completed', 'Routine check-up'),
 ('jonah.eze@example.test', 'ada.okafor@example.test', '2026-10-17 10:30+01', 'scheduled', 'Follow-up visit'),
 ('lara.james@example.test', 'tunde.bello@example.test', '2026-10-18 11:00+01', 'scheduled', 'General consultation')
) AS v(patient_email, doctor_email, scheduled_at, status, reason)
JOIN patients p ON p.email = v.patient_email
JOIN doctors d ON d.email = v.doctor_email;

INSERT INTO consultations(appointment_id, notes)
SELECT appointment_id, 'Fictional consultation note for database testing.'
FROM appointments WHERE status = 'completed';

INSERT INTO diagnoses(code, description) VALUES
 ('DX-001', 'Routine examination'),
 ('DX-002', 'Seasonal allergy symptoms');

INSERT INTO consultation_diagnoses(consultation_id, diagnosis_id, notes)
SELECT c.consultation_id, d.diagnosis_id, 'Sample diagnosis for portfolio demonstration'
FROM consultations c CROSS JOIN diagnoses d WHERE d.code = 'DX-001';

INSERT INTO medications(name, strength, dosage_form) VALUES
 ('Sample medication A', '10 mg', 'tablet'),
 ('Sample medication B', '5 ml', 'oral solution');

INSERT INTO prescriptions(consultation_id, instructions)
SELECT consultation_id, 'Follow clinician instructions; fictional example only.'
FROM consultations;

INSERT INTO prescription_items(prescription_id, medication_id, dose, frequency, duration_days, quantity)
SELECT p.prescription_id, m.medication_id, '1 unit', 'As directed in the example', 5, 5
FROM prescriptions p CROSS JOIN medications m WHERE m.name = 'Sample medication A';

INSERT INTO lab_tests(test_code, name) VALUES
 ('CBC', 'Complete blood count'),
 ('GLU', 'Blood glucose');

INSERT INTO lab_orders(consultation_id, status)
SELECT consultation_id, 'completed' FROM consultations;

INSERT INTO lab_order_items(lab_order_id, lab_test_id, result_text, result_status, resulted_at)
SELECT lo.lab_order_id, lt.lab_test_id, 'Illustrative result only', 'normal', CURRENT_TIMESTAMP
FROM lab_orders lo CROSS JOIN lab_tests lt WHERE lt.test_code = 'CBC';
