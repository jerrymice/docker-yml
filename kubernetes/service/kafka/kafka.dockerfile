FROM openjdk:8u151-jre-alpine
ADD kafka /kafka
EXPOSE 9092
CMD ["sh","/kafka/bin/kafka-server-start.sh", "/kafka/config/server.properties"]
