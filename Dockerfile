# FROM eclipse-temurin:17-jdk-alpine 
# EXPOSE 8080
# ENV APP_HOME /usr/src/app
# COPY target/*.jar $APP_HOME/app.jar
# WORKDIR $APP_HOME
# CMD ["java", "-jar", "app.jar"]


# Stage 1: Build the application using a Maven image
FROM maven:3.9.0-eclipse-temurin-17-alpine as build

# Set the working directory inside the container
WORKDIR /build

# Copy your Maven project files (pom.xml and src)
COPY pom.xml .
COPY src ./src

# Run the Maven build to create the JAR file (you can change to your specific profile)
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM eclipse-temurin:17-jdk-alpine

# Expose the port your application will run on
EXPOSE 8080

# Set the working directory in the runtime container
ENV APP_HOME /usr/src/app
WORKDIR $APP_HOME

# Copy only the JAR file from the build stage
COPY --from=build /build/target/*.jar $APP_HOME/app.jar

# Command to run the JAR file
CMD ["java", "-jar", "app.jar"]
