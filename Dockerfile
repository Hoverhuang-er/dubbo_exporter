# Build stage
FROM maven:3.8.6-openjdk-8 as Build
COPY . .
RUN mvn clean package -DskipTests
FROM amazon/aws-lambda-java:8.al2.2022.07.05.12 as runtime
# Install the Java runtime environment
COPY --from=build target/charts/dubbo_exporter.tgz .
RUN ls -alth
ARG JAR_FILE=target/charts/dubbo_exporter.tgz
ADD $JAR_FILE /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]