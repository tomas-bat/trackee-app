FROM eclipse-temurin:17-jdk AS build

WORKDIR /workspace

COPY . .

RUN chmod +x ./gradlew \
    && ./gradlew --no-daemon :backend:stage

FROM eclipse-temurin:17-jre AS runtime

WORKDIR /app

COPY --from=build /workspace/backend/build/install/backend /app

EXPOSE 8080

ENTRYPOINT ["/app/bin/backend"]