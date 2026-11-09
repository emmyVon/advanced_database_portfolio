

-- query to find upcoming appointments

SELECT
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.doctor_id,
    a.scheduled_at
FROM hospital.appointments AS a
JOIN hospital.patients AS p
    ON a.patient_id = p.patient_id
JOIN hospital.doctors AS d
    ON a.doctor_id = d.doctor_id
WHERE a.scheduled_at >= CURRENT_TIMESTAMP
ORDER BY a.scheduled_at ASC;

--query to find upcoming appoinment by doctor_id
SELECT
    a.appointment_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    a.scheduled_at,
	d.doctor_id,
	d.first_name || ' ' || d.last_name AS doctor_name,
    a.status
FROM hospital.appointments a
JOIN hospital.patients p
    ON a.patient_id = p.patient_id
JOIN hospital.doctors AS d
	ON a.doctor_id = d.doctor_id
WHERE a.doctor_id = 1
  AND a.scheduled_at >= CURRENT_DATE
ORDER BY a.scheduled_at;


-- Get Patient Medical Record
SELECT p.patient_id, p.first_name, p.last_name,
       a.scheduled_at, c.recorded_at, c.notes,
       dg.diagnosis_code, dg.description AS diagnosis
FROM hospital.patients p
JOIN hospital.appointments a ON a.patient_id = p.patient_id
JOIN hospital.consultations c ON c.appointment_id = a.appointment_id
LEFT JOIN hospital.consultation_diagnoses cd ON cd.consultation_id = c.consultation_id
LEFT JOIN hospital.diagnoses dg ON dg.diagnosis_id = cd.diagnosis_id
WHERE p.email = 'joe.doe@example.com'
ORDER BY c.recorded_at DESC;

-- EXECUTION PLAN FOR QUERY OPTIMISATION
EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM hospital.appointments
WHERE patient_id = 1
ORDER BY scheduled_at DESC
LIMIT 20;
