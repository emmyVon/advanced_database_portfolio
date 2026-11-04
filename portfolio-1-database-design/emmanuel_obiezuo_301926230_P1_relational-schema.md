# Relational schema

KEYS: **PK** = primary key, **FK** = foreign key, **UQ** = unique constraint.

- `departments(department_id PK, name UQ)`
- `doctors(doctor_id PK, department_id FK → departments, first_name, last_name, email UQ, specialty, active)`
- `patients(patient_id PK, first_name, last_name, date_of_birth, sex, phone, email UQ, created_at)`
- `appointments(appointment_id PK, patient_id FK → patients, doctor_id FK → doctors, scheduled_at, status, reason, created_at)`
- `consultations(consultation_id PK, appointment_id FK UQ → appointments, notes, recorded_at)`
- `diagnoses(diagnosis_id PK, diagnosis_code UQ,diagnosis_name, description)`
- `consultation_diagnoses(consultation_id PK/FK → consultations, diagnosis_id PK/FK → diagnoses, notes)`
- `medications(medication_id PK, name UQ, strength, dosage_form)`
- `prescriptions(prescription_id PK, consultation_id FK → consultations, prescribed_at, instructions)`
- `prescription_items(prescription_id PK/FK → prescriptions, medication_id PK/FK → medications, dose, frequency, duration_days, quantity)`
- `bill(bill_id PK,patient_id FK → patients, consultation_id FK → consultations, billdate, status)`
- `payment(payment_id PK, bill_id FK → bill, amount, paidat,method)`

Important constraints include valid status values, non-negative durations/quantities, unique email/code fields, and foreign keys that prevent orphaned clinical records.

## Normalisation

- **1NF:** Each column stores one value; repeating diagnoses and medication lines are placed in separate related tables rather than comma-separated lists.
- **2NF:** Tables with composite keys (such as `prescription_items`) have non-key attributes that depend on the whole key. Medication details are stored in `medications`, not repeated in every prescription item.
- **3NF:** Non-key attributes depend on the key, the whole key, and nothing but the key. Department name is stored in `departments` and referenced by `doctors`; patient contact details are stored once in `patients`.
- This avoids common update, insertion and deletion anomalies. Some read-heavy systems may intentionally denormalise selected data, but that should be measured and documented.
