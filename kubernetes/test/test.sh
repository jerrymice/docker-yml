#!/bin/bash
#启动tomcat pod ,如果本地没有tomcat镜像,那么将去下载tomcat镜像.等待时间会很长
#kubectl apply -f tomcat.yaml
#这是一个测试脚本用于测试kubectl是否可用
#列出测试的tomcat
kubectl get pods -o wide | grep tomcat
IP=`kubectl get pods -o wide | awk -F ' ' 'NR!=1{print $6}'`
elinks -dump http://$IP:8080 

