# Use a lightweight base image with OpenJDK 17
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/database_service_project-0.0.1.jar /app

# Default command to run the JAR file
CMD ["java","-jar","database_service_project-0.0.1.jar"]

EXPOSE 8080
