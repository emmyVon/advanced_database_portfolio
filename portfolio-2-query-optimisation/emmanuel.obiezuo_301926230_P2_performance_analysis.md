## OPTIMISATION ANALYSIS

To evaluate the performance of the database, I had to compare the Execution without indexing and the execution with indexing applied on the appointment table.

## Before Optimisation (Baseline Execution Plan):

When querying a large Appointment table without an index on PatientID, the database engine must scan every row to find matches. This becomes inefficient especially when trying to find upcoming appointments or appointment with a specific patient

- Query Strategy: The database engine performed a Seq Scan (Sequential Scan) on the appointments table, meaning it had to read through over 10,000 rows in the table to find matches for patient_id = 1
- Memory and I/O: The operation required 104 shared buffer hits (Buffers: shared hit=104) to process the query.
- Execution Time: The total execution time to complete this query was 38.035 ms.

## Index Applied

CREATE INDEX idx_appointments_patient_time ON hospital.appointments(patient_id, scheduled_at DESC);

## After Optimisation (Optimised Execution Plan)

- Query Strategy: The database engine successfully utilized an Index Scan using the idx_appointments_patient_time index. This indicates a composite index was applied, covering both the patient_id and the scheduled_at columns.
- Memory and I/O: The data retrieval became much more efficient, dropping to only 26 shared buffer hits for execution (Buffers: shared hit=26)
- Execution Time: The total execution time dropped significantly to 6.286 ms

## Conclusion

Application of the index yield a significant performance improvement. The excution time was reduced from 38.035 ms to 6.286 ms. Furthermore, by eliminating the sequential scan and the in-memory heapsort, the database drastically reduced the disk I/O and memory overhead required to process the query (from 104 buffer hits down to 26). In a busy hospital environment where patient records are queried constantly, this optimization prevents the server's CPU and memory from bottlenecking
