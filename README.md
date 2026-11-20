# Task Tracker API

A RESTful Task Tracker API built with Java and Spring Boot to create, manage, update, and delete tasks.

[![CI](https://github.com/Gagana0819/Gagana0819-task-tracker-devops/actions/workflows/ci.yml/badge.svg)](https://github.com/Gagana0819/Gagana0819-task-tracker-devops/actions/workflows/ci.yml)

## Tech Stack

- **Java:** 21
- **Framework:** Spring Boot 4.1
- **Build Tool:** Maven
- **Database:** PostgreSQL 17 (Docker Compose); H2 in-memory for tests

## Run Locally

Clone the repository and navigate to the project directory.

Run tests:

```bash
./mvnw test
```

Build the project:

```bash
./mvnw package
```

Run the application:

```bash
java -jar target/task-tracker-0.0.1-SNAPSHOT.jar
```

The application will run on the default port `8080`.

## API Endpoints

| Method | Path | Success Code |
|---|---|---|
| POST | `/api/tasks` | 201 Created |
| GET | `/api/tasks` | 200 OK |
| GET | `/api/tasks/{id}` | 200 OK |
| PUT | `/api/tasks/{id}` | 200 OK |
| DELETE | `/api/tasks/{id}` | 204 No Content |

## Configuration

The application supports environment-based configuration.

**Change server port** (the variable must be on the same line as the command, or `export`ed first):

```bash
SERVER_PORT=9090 java -jar target/task-tracker-0.0.1-SNAPSHOT.jar
```

**Configure database connection:**

```bash
SPRING_DATASOURCE_URL=jdbc:h2:mem:tasktracker
```

These environment variables can be configured before starting the application.

## Run as a Linux service (systemd)

```bash
# One-time: a dedicated user, and the jar installed in /opt
sudo useradd --system --no-create-home --shell /usr/sbin/nologin tasktracker
./mvnw -q package -DskipTests
sudo mkdir -p /opt/task-tracker
sudo cp target/task-tracker-0.0.1-SNAPSHOT.jar /opt/task-tracker/app.jar
sudo chown -R tasktracker:tasktracker /opt/task-tracker

# Install and start the service
sudo cp deploy/task-tracker.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now task-tracker

# Check it
systemctl status task-tracker
journalctl -u task-tracker -f
./scripts/smoke-test.sh
```

## Run with Docker Compose

1. Create your environment file (then set your own password in `.env`):

   ```bash
   cp .env.example .env
   ```

2. Build and start the app and PostgreSQL:

   ```bash
   docker compose up -d --build
   docker compose ps   # wait until both show "healthy"
   ```

3. Test it:

   ```bash
   ./scripts/smoke-test.sh
   ```

4. Stop it (your data stays in the `pgdata` volume):

   ```bash
   docker compose down
   ```

## CI/CD

- Every PR builds, tests and smoke-tests the Docker image.
- Every merge to `main` publishes `ghcr.io/gagana0819/gagana0819-task-tracker-devops` with the tags `latest` and `sha-<commit>`.

```bash
docker pull ghcr.io/gagana0819/gagana0819-task-tracker-devops:latest
```

## Roadmap

- [x] Step 0 – Workstation setup (WSL, Java, Docker, SSH)
- [x] Step 1 – Build the app
- [x] Step 2 – Git & GitHub workflow
- [x] Step 3 – Linux & shell basics
- [x] Step 4 – Docker & Docker Compose
- [x] Step 5 – CI with GitHub Actions
- [ ] Step 6 – Cloud server & CD
- [ ] Step 7 – Infrastructure as Code (Terraform, Ansible)
- [ ] Step 8 – Monitoring & logging (Prometheus, Grafana)
- [ ] Step 9 – Kubernetes basics
- [ ] Step 10 – Wrap-up

---

**Project:** Task Tracker API · **Status:** In Development
