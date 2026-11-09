# Portfolio 4 — NoSQL and Advanced Data Models

This portfolio models a consultation document in MongoDB. The relational database remains the system of record for the SQL activities; the document example demonstrates when a nested, read-oriented representation may be useful.

## Suitability and trade-offs

A document can retrieve a consultation and its related summary in one read, allowing doctors to instantly retrieve a complete medical record in one read operation without expensive SQL joins, improving application performance for read-heavy clinical dashboards and its structure can evolve when different consultations contain different types of data. However, embedding duplicates information such as a patient's display name and medication details. Updating duplicated values consistently becomes harder, and very large or frequently changing arrays may be poor candidates for embedding.

The relational model is preferable for strong foreign-key integrity, structured relationships, and multi-table transactions. The document model may be useful for a read-optimised consultation summary, audit snapshot, or flexible clinical payload.

## Evidence to capture

- MongoDB version / connection (hide credentials).
- Successful insert output.
- `find()` result.
- Short explanation comparing the document model with the relational schema.
