# Stage 1: Build the app using Maven and Eclipse Temurin JDK 24
FROM maven:3.9.6-eclipse-temurin-24 as build

WORKDIR /app

# Copy pom.xml and download dependencies first (cache optimization)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Build the application (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Run the app using a smaller JRE 24 image
FROM eclipse-temurin:24-jre

WORKDIR /app

# Copy built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
