FROM openjdk:8u151-jre-alpine
ADD /root/kafka_2.11-2.1.0 /kafka
EXPOSE 9092
CMD ["sh","/kafka/bin/kafka-server-start.sh", "/kafka/config/server.properties"]
