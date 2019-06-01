#!/bin/bash
docker run --name zabbix-server -e DB_SERVER_HOST="10.254.0.3" -e MYSQL_USER="sa" -e MYSQL_PASSWORD="123456" -d zabbix/zabbix-server-mysql:alpine-4.2.1

