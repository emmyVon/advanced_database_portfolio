# Portfolio 1 — Database Design and Modelling

## Case study

Greenfield Hospital is a simulated outpatient clinic. The system stores patients, doctors, appointments, consultations, diagnoses, prescriptions and laboratory orders/results. Reception staff book appointments; clinicians record consultations; laboratory staff manage results.

## Business requirements

The database must support these activities:

1. Register each patient and assign a unique patient number.
2. Store doctors' details and their medical specializations.
3. Record the departments or specialties in which doctors work.
4. Schedule appointments between patients and doctors.
5. Record consultations and clinical notes.
6. Associate one or more diagnoses with a consultation.
7. Allow doctors to prescribe medications during consultations.
8. Store prescribed medicines, dosages, and treatment instructions.
9. Generate bills for consultations and other services.
10. Record payments against bills and identify outstanding balances.
11. Maintain relationships between all records without unnecessary duplication.
12. Restrict access to confidential patient and medical information according to staff roles.

## Scope and assumptions

To keep the project manageable, we'll use these assumptions:

- One patient can have many appointments.
- One doctor can attend to many patients.
- An appointment may result in one consultation, but a cancelled or missed appointment may have none.
- A consultation may have multiple diagnoses and prescriptions.
- A prescription may contain several medication items.
- A bill may contain multiple bill items and receive multiple payments.
- Every consultation is associated with a patient and a doctor.
- The initial system focuses on outpatient care rather than hospital admission, surgery, laboratory workflows, or inpatient bed management.

## Entities and attributes

| Entity                | Important Attributes                                                |
| --------------------- | ------------------------------------------------------------------- |
| Patient               | PatientID, FirstName, LastName, DOB, Phone, Email                   |
| Department            | DepartmentID, DepartmentName                                        |
| Doctor                | DoctorID, DepartmentID, FirstName, LastName, LicenseNo              |
| Appointment           | AppointmentID, PatientID, DoctorID, AppointmentDate, Status         |
| Consultation          | ConsultationID, AppointmentID, PatientID, DoctorID, Notes           |
| Diagnosis             | DiagnosisID, DiagnosisCode, DiagnosisName                           |
| ConsultationDiagnosis | ConsultationID, DiagnosisID                                         |
| Medication            | MedicationID, MedicationName, Strength, Form                        |
| Prescription          | PrescriptionID, ConsultationID, PrescribedAt                        |
| PrescriptionItem      | PrescriptionItemID, PrescriptionID, MedicationID, Dosage, Frequency |
| Bill                  | BillID, PatientID, ConsultationID, BillDate, Status                 |
| BillItem              | BillItemID, BillID, Description, Quantity, UnitPrice                |
| Payment               | PaymentID, BillID, Amount, PaidAt, Method                           |

## Design assumptions

- A patient may have many appointments; each appointment belongs to one patient and one doctor.
- A doctor belongs to one department.
- An appointment may lead to zero or one consultation; cancelled/no-show appointments may have none.
- A consultation can record multiple diagnoses and multiple prescriptions.
- A prescription contains one or more medication lines.
- A laboratory order may contain one or more test items; a result is recorded for each ordered test item.
- All records are fictional. Real deployments require privacy, access-control, audit and regulatory review.

## Normalisation

- **1NF:** Each column stores one value; repeating diagnoses and medication lines are placed in separate related tables rather than comma-separated lists.
- **2NF:** Tables with composite keys (such as `prescription_items`) have non-key attributes that depend on the whole key. Medication details are stored in `medications`, not repeated in every prescription item.
- **3NF:** Non-key attributes depend on the key, the whole key, and nothing but the key. Department name is stored in `departments` and referenced by `doctors`; patient contact details are stored once in `patients`.
- This avoids common update, insertion and deletion anomalies. Some read-heavy systems may intentionally denormalise selected data, but that should be measured and documented.

## Files

- `sql/01_schema.sql`: PostgreSQL tables, keys, constraints and indexes.
- `er-diagram.mmd`: Mermaid ER diagram source. Paste into Mermaid Live Editor or use a Mermaid-compatible Markdown preview to render it.
- `relational-schema.md`: readable relational schema.
