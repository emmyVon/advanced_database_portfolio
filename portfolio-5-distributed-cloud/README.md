# Portfolio 5 — Distributed and Cloud Database Exercise

## Goal

Explain how Greenfield Hospital could maintain access to appointment and clinical data if a database server fails or staff access the system from multiple locations. This folder is an architecture and verification exercise; it does not claim that cloud replication has already been deployed.

## Proposed architecture

- One PostgreSQL primary accepts writes.
- One or more standby replicas receive changes through PostgreSQL streaming replication.
- The application uses a controlled connection endpoint and role-based database credentials.
- Backups are stored separately from the database host and periodically tested by restoring to a non-production environment.
- Monitoring checks replica lag, storage, connection count, failed backups and availability.

## Concepts applied

- **Replication:** keeps copies of data on another server. It can improve read availability and recovery options, but replication is not a replacement for backups.
- **Availability:** a standby can support recovery after a primary failure. Failover needs monitoring, a decision process and fencing to avoid two writable primaries.
- **Consistency:** synchronous replication can wait for standby acknowledgement, reducing the chance of losing acknowledged writes but potentially increasing latency or reducing write availability during network problems. Asynchronous replication generally lowers write latency but can lose recent unreplicated changes if the primary fails.
- **Sharding:** partitions data across servers, for example by clinic/site or a carefully selected patient-key strategy. It adds routing and operational complexity and should not be introduced without a demonstrated scale requirement.
- **Security:** encrypt connections, restrict privileges, keep secrets outside GitHub, log privileged actions and minimise access to sensitive clinical records.

## Practical evidence option

If you can access two Linux VMs or cloud database instances, configure a PostgreSQL primary and standby using the official PostgreSQL documentation, then capture a status query such as `SELECT pg_is_in_recovery();` on the standby and a replication status query on the primary. Do not expose public database ports without appropriate network controls.

If you cannot deploy two servers, submit the architecture diagram, a clearly labelled configuration walkthrough, and a discussion of trade-offs. Label this as a design exercise rather than claiming a live replication test.

## Questions to answer in your own words

1. Which records need strong consistency at booking time, and why?
2. What would happen if a replica were several seconds behind?
3. Why is a replica not the same as an independent backup?
4. How would the application behave during primary failure?
5. What extra complexity would sharding introduce?
