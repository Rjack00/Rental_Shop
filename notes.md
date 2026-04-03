# Docker + PostgreSQL Workflow (Reusable Template)

## Container Setup

### Create and start PostgreSQL container
```
docker run -d \
  --name <containerName> \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres
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

## Database Setup

### Create database
`docker exec -it <containerName> psql -U postgres -c "CREATE DATABASE <dbname>;"`

### List databases
`docker exec -it <containerName> psql -U postgres -c "\l"`

---

## Running SQL Files

### Load schema (tables)
`docker exec -i <containerName> psql -U postgres -d <dbname> < schema.sql`

### Load data (seed data)
`docker exec -i <containerName> psql -U postgres -d <dbname> < data.sql`

---

## Open PostgreSQL (interactive)

`docker exec -it <containerName> psql -U postgres -d <dbname>`

### Useful inside psql
\dt        -- list tables
\d table   -- describe table
\q         -- quit

---

## Run Single Queries from Bash

### Set reusable variable (recommended)
`PSQL="docker exec -i <containerName> psql -U postgres -d <dbname> -t -P pager=off -c"`

### Example usage
`$PSQL "SELECT * FROM table_name;"`

---

## Notes

- PostgreSQL runs INSIDE the container (not installed locally)
- Data is stored inside the container (deleted if container is removed)
- Always keep `.sql` files as your source of truth
- Use `-i` (not `-it`) for scripts to avoid terminal issues
- `-P pager=off` prevents output from getting stuck in a pager
- Port `5432` is default; change host port if running multiple containers:
  - Example: `-p 5433:5432`

---

## Reset Workflow (Clean Rebuild)

`docker stop <containerName>`
`docker rm <containerName>`
```
docker run -d \
  --name <containerName> \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres
```
`docker exec -it <containerName> psql -U postgres -c "CREATE DATABASE <dbname>;"`

`docker exec -i <containerName> psql -U postgres -d <dbname> < schema.sql`
`docker exec -i <containerName> psql -U postgres -d <dbname> < data.sql`

---

## Common Issues

### Container name already exists
→ Run: `docker rm <containerName>`

### Port already in use
→ Change port: `-p 5433:5432`

### Command hangs / requires pressing 'q'
→ Missing: -P pager=off

### Database not found
→ Make sure you created it before loading schema/data

### Container not running
→ Run: `docker start <containerName>`