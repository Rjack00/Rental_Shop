# Bike Rental Shop Database

A PostgreSQL database project that models a bike rental shop, including customers, bikes, and rental transactions. Built as part of the FreeCodeCamp Relational Databases certification.

---

## Tech Stack

- PostgreSQL
- Docker
- SQL

---

## Project Structure

```
bike-rental-shop/
  schema.sql      # Table definitions and constraints
  data.sql        # Seed data (customers, bikes, rentals)
  queries.sql     # Example queries and reports
  README.md       # Project documentation
```

---

## Setup and Run (Docker)

### 1. Start PostgreSQL container

```
docker run -d \
  --name bike-db \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres
```

### 2. Create database

```
docker exec -it bike-db psql -U postgres -c "CREATE DATABASE bike_rental;"
```

### 3. Load schema

```
docker exec -i bike-db psql -U postgres -d bike_rental < schema.sql
```

### 4. Load data

```
docker exec -i bike-db psql -U postgres -d bike_rental < data.sql
```

### 5. (Optional) Open PostgreSQL shell

```
docker exec -it bike-db psql -U postgres -d bike_rental
```

---

## Container Management

### Start existing container
`docker start <containerName>`

### Stop container
`docker stop <containerName>`

### Remove container (deletes all data inside it)
`docker rm <containerName>`

### View running containers
`docker ps`

### View all containers (including stopped)
`docker ps -a`

---

## Open PostgreSQL (interactive)

`docker exec -it <containerName> psql -U postgres -d <dbname>`

---

## Example Queries

```sql
-- View all available bikes
SELECT * FROM bikes WHERE available = true;

-- View rental history with customer names
SELECT c.name, b.type, r.date_rented, r.date_returned
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN bikes b ON r.bike_id = b.bike_id;
```

---

## Cleanup

```
docker stop bike-db
docker rm bike-db
```

---

## Notes

- The database must be created before running `schema.sql`
- `schema.sql` and `data.sql` are designed to fully rebuild the database from scratch

---

## License

MIT License