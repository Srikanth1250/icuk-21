# ---- Stage 1: Build the WAR using Maven ----
FROM maven:3.8.8-eclipse-temurin-8 AS builder

# Set work directory
WORKDIR /app

# Copy the project files
COPY . .

# Build the WAR
RUN mvn clean package -DskipTests

# ---- Stage 2: Deploy to Tomcat ----
FROM tomcat:9.0-jdk8

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR file to Tomcat
COPY --from=builder /app/target/maven-web-application.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
