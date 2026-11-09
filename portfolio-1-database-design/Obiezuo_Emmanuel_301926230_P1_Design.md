<!-- Case Study -->

GraceCare is a medium-sized healthcare facility that provides outpatient consultations, appointment scheduling, diagnosis, prescription management, and billing services.

Currently, the hospital stores patient records, doctor information, appointments, and payment details in separate files. This creates problems such as duplicate patient records, difficulty retrieving medical histories, appointment conflicts, and inaccurate billing.

The hospital wants a centralized relational database that allows authorized staff to manage patient information efficiently while preserving the accuracy and confidentiality of medical records.

## Business requirements

The database must support these activities:

1. Register each patient and assign a unique patient number.
2. Store doctors' details and their departments.
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
- All records are fictional. Real deployments require privacy, access-control, audit and regulatory review.
