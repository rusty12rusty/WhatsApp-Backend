###############################################
# Stage 1: Build the application (Maven Layer)
###############################################
FROM maven:3.8.3-openjdk-17 AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml & download dependencies (cached layer)
COPY pom.xml .
RUN mvn -B dependency:resolve dependency:resolve-plugins

# Copy source code
COPY src ./src

# Build jar
RUN mvn -B clean package -DskipTests


###############################################
# Stage 2: Run the application (Runtime Layer)
###############################################
FROM amazoncorretto:17-alpine-jdk AS runtime

# Set working directory
WORKDIR /app

# Copy built jar from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
