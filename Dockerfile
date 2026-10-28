# ---------- Этап 1: сборка ----------
# Берём образ с JDK (компилятор), собираем .class из исходников.
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY src/ ./src/
RUN javac -encoding UTF-8 -d out src/*.java

# ---------- Этап 2: запуск ----------
# Лёгкий образ только с JRE — компилятор в финальном образе не нужен.
FROM eclipse-temurin:21-jre-alpine
LABEL maintainer="x100kaioken"
LABEL description="SPN-шифр (Кузнечик S-Box, режимы ECB и CBC) в контейнере"

WORKDIR /app
# Копируем скомпилированные классы из этапа сборки
COPY --from=build /app/out ./out

# UTF-8, чтобы кириллица в выводе отображалась корректно
ENV LANG=C.UTF-8

# Запуск программы при старте контейнера
CMD ["java", "-Dstdout.encoding=UTF-8", "-Dstderr.encoding=UTF-8", "-cp", "out", "Main"]
