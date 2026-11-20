# ---------- Stage 1: build the jar ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace

# Copy only the build files first, so the dependency download is cached
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw -B -q dependency:go-offline

# Now copy the source code and build (tests run in CI, Step 5)
COPY src src
RUN ./mvnw -B -q package -DskipTests

# ---------- Stage 2: the small runtime image ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Never run as root inside a container
RUN groupadd --system app && useradd --system --gid app --no-create-home app

COPY --from=build /workspace/target/*.jar app.jar
USER app

EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -fsS http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
