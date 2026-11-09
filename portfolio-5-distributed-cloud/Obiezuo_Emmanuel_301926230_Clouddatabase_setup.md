## Architecture and Setup

As a critical-mission Industry, the scalability, security and reliability of the hospital database is high importance.The system will be deployed on a managed cloud relational database service, such as Amazon RDS (PostgreSQL) or Azure SQL Database

## REPLICATION

In a hospital/Clinic setting, system downtime can disrupt patient care. To prevent this, we implement two types of replication

- Synchronous Replication: The primary database continuously copies every transaction (like a new Appointment or Bill) to a standby replica in a different physical location (Availability Zone). If the primary server crashes, the system automatically fails over to the standby with zero data loss, ensuring High Availability.

- Asynchronous Read Replicas: Heavy analytical queries (e.g., hospital administrators running monthly revenue reports using the Bill and Payment tables) can slow down the database. We route these read-only queries to a separate "Read Replica" server so the primary server remains fast for doctors and receptionists handling real-time patients.

## SHARDING AND PARTITIONING

As the clinic operates over several years, tables like Consultation, Prescription, and BillItem will grow massively and there may expansions by creation of branches. To handle data distribution the following techniques will be adopted:

- Horizontal Sharding (by Location/Branch): If GraceCare Hospital opens multiple branches, data can be sharded using a BranchID. All patient records and appointments for Branch A reside on one shard, while Branch B data resides on another.
- Time-Based Partitioning: For tables like Appointment and Bill, we can partition the data by year. Current year records (2026) are kept on high-speed solid-state drives (SSDs) for fast access, while historical records (e.g., 2020-2023) are moved to cheaper, slower storage tiers.

## Availability Vs Consistency (CAP Thorem)

Consistency in the hospital design is paramount. Updates made on patient's Diagnosis or prescription of new Medication, must be immediately visible to the pharmacy and billing departments. The clinic cannot risk a doctor making a medical decision based on outdated (stale) data.
Therefore, our distributed hospital database prioritizes CP (Consistency and Partition Tolerance) over absolute Availability. If a network partition occurs between database nodes, the system will temporarily pause write operations (sacrificing availability) rather than allowing conflicting or out-of-sync medical records to be saved
