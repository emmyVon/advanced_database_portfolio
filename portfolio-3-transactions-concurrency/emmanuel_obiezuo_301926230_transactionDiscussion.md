## COMMIT

```sql
BEGIN;
UPDATE appointments
SET status = 'completed'
WHERE appointment_id = 2;
COMMIT;

```

- update is committed and the status of appointment_id 2 is now 'completed'

## ROLLBACK

```sql
BEGIN;
UPDATE appointments
SET status = 'cancelled'
WHERE appointment_id = 2;
SELECT appointment_id, status FROM appointments WHERE appointment_id = 2;

ROLLBACK;

SELECT appointment_id, status FROM appointments WHERE appointment_id = 2;
```

- returns status of 'completed' for appointment_id 2 because 'cancelled' update was rolledback/reversed

## Transaction concurrency mechanism

To demonstrate concurrency control and isolation in the hospital database, a scenario was simulated where two separate database sessions attempt to modify the exact same appointment record simultaneously

- SESSION A
  Starts a transaction (BEGIN;) to update the status of appointment_id = 2 to 'scheduled'. Because the transaction was started but no COMMIT or ROLLBACK command was issued yet, the database placed a row-level lock on appointment_id = 2

- SESSION B
  While Session A was still active and holding the lock, a second tab session B attempted to start a new transaction to update the exact same appointment_id = 2 to a status of 'completed'. As shown in the screenshot, Session B was blocked and placed in a "Waiting for the query to complete..." state. This demonstrates the database's concurrency control mechanism actively preventing a "dirty write" by forcing Session B to wait until Session A releases its lock.

- Resolution/ Final Result
  Once Session A completes its transaction (either by committing or rolling back), Session B is unblocked and allowed to execute its update. The final screenshot ("concurrentupdate_final_result.png") shows the result of a SELECT query on appointment_id = 2, confirming that the status was successfully updated to 'completed' by the second session after the lock was released

- Conclusion
  This implementation proves that the database correctly handles concurrent modification attempts. By utilizing transactions and default row-level locking, the system ensures data integrity and prevents conflicting updates when multiple hospital staff members try to edit the same patient's appointment at the same time

## Transaction Isolation

This demonstration shows how the REPEATABLE READ isolation level prevents a phenomenon known as a Non-Repeatable Read (where reading the same row twice inside one transaction produces two different results because another session committed changes in between).

- SESSION A
  Tries to get the sum bill of a patient after discharge. BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ takes a snapshot of the database at the start of the query

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT
    b.bill_id,
    b.status,
    SUM(bi.quantity * bi.unit_price) AS total_amount
FROM hospital.bills b
JOIN hospital.bill_items bi ON b.bill_id = bi.bill_id
WHERE b.bill_id = 1
GROUP BY b.bill_id, b.status;

```

- SESSION B
  Attempts to insert and commit a new bill while session A is still active and not commited.

```sql
BEGIN;

-- Add a new pharmacy charge to the same bill
INSERT INTO hospital.bill_items (bill_id, description, quantity, unit_price)
VALUES (1, 'Pharmacy - Antibiotics', 1.00, 35.00);

-- Permanently commit the new charge
COMMIT;
```

- Session A
  Trys to read the query again but doesn't take account the insert of Session B till the transaction is COMMITTED OR ROLLBACK.

```sql
  SELECT
    b.bill_id,
    b.status,
    SUM(bi.quantity * bi.unit_price) AS total_amount
FROM hospital.bills b
JOIN hospital.bill_items bi ON b.bill_id = bi.bill_id
WHERE b.bill_id = 1
GROUP BY b.bill_id, b.status;
```
