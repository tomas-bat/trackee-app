FROM eclipse-temurin:17-jdk AS build

WORKDIR /workspace

COPY . .

RUN chmod +x ./gradlew \
    && ./gradlew --no-daemon :backend:buildFatJar

FROM eclipse-temurin:17-jre AS runtime

WORKDIR /app

COPY --from=build /workspace/backend/build/libs/backend-all.jar /app/backend.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/backend.jar"]
