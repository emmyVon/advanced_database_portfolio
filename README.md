# MIT 8103 Advanced Database Systems Portfolio

## Case study: GraceCare Hospital and Clinic Management System

This is a practical portfolio for the MIT 8103 Continuous Assessment. It uses a simulated hospital so that no real patient information is needed.

**Primary relational database:** PostgreSQL  
**NoSQL demonstration:** MongoDB document model  
**Cloud/distribution exercise:** PostgreSQL primary/replica design discussion and deployment checklist

## Portfolio map

- `portfolio-1-database-design/`: case study, relational schema, ER diagram (Mermaid), PostgreSQL DDL, normalisation.
- `portfolio-2-query-optimisation/`: representative queries, indexing experiment, `EXPLAIN ANALYZE` instructions and results template.
- `portfolio-3-transactions-concurrency/`: commit/rollback and isolation/concurrency experiments.
- `portfolio-4-nosql/`: MongoDB document examples and comparison with relational design.
- `portfolio-5-distributed-cloud/`: replication, sharding, availability, consistency and deployment exercise.
- `final-documentation/`: 2–3 page report outline, reflection prompts, references and AI-use declaration.
- `data/`: fictional seed data.

## Quick start (PostgreSQL)

1. Install PostgreSQL and open pgAdmin or `psql`.
2. Create a database named `gracecare_clinic`.
3. Run `portfolio-1-database-design/sql/01_schema.sql`.
4. Run `data/postgres_seed.sql`.
5. Run queries from Portfolio 2 and capture output.
6. Run Portfolio 3 experiments in two separate database sessions where indicated.
7. Save screenshots in the relevant `evidence/` folder. Do not claim a test passed unless you ran it.
