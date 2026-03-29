#
# Build stage
#
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /home/app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

#
# Package stage
#
FROM eclipse-temurin:17-alpine
WORKDIR /home/app
COPY --from=build /home/app/target/api-alpha-jar-with-dependencies.jar ./api.jar
CMD java -DMOUNTED_DIR=$MOUNTED_DIR -cp api.jar com.grid.and.cloud.api.Application
