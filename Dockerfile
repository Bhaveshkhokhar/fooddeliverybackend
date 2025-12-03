# ====== Stage 1: Build the JAR ======
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the full source code
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# ====== Stage 2: Run the JAR ======
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy built jar from stage 1
COPY --from=build /app/target/*.jar app.jar

# Expose port (change if your app uses different port)
EXPOSE 8080

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]
