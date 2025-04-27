# OpenJDK 21
FROM openjdk:21-jdk-slim

# Node.js и LocalTunnel
RUN apt-get update && \
    apt-get install -y curl npm && \
    npm install -g localtunnel && \
    rm -rf /var/lib/apt/lists/*

# Создаем директорию для приложения
WORKDIR /app

# Копируем JAR-файл в контейнер 
# (файл должен находиться в той же папке, что и Dockerfile)
COPY CurrencyConverterBot-1.0-SNAPSHOT-jar-with-dependencies.jar /app/app.jar

# Открываем порт бота
EXPOSE 8081

# Запускаем бот и LocalTunnel
CMD ["sh", "-c", "lt --port 8081 --subdomain mybot & sleep 30 && java -jar app.jar"]
