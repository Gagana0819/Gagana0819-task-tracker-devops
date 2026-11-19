# Task Tracker API (A)

A RESTful Task Tracker API built with Java and Spring Boot to create, manage, update, and delete tasks.

## Tech Stack

- **Java:** 21
- **Framework:** Spring Boot 4.1
- **Build Tool:** Maven
- **Database:** H2 (PostgreSQL planned for later)

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

**Change server port:**

```bash
SERVER_PORT=9090
```

**Configure database connection:**

```bash
SPRING_DATASOURCE_URL=jdbc:h2:mem:tasktracker
```

These environment variables can be configured before starting the application.

## Roadmap

- [x] Step 0 – Project setup
- [x] Step 1 – Initial application configuration
- [x] Step 2 – Basic API implementation
- [ ] Step 3 – Task management improvements
- [ ] Step 4 – Database configuration
- [ ] Step 5 – Validation and error handling
- [ ] Step 6 – API documentation
- [ ] Step 7 – Unit and integration testing
- [ ] Step 8 – PostgreSQL integration
- [ ] Step 9 – Docker configuration
- [ ] Step 10 – Deployment

---

**Project:** Task Tracker API  
**Status:** In Development