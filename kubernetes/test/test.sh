#!/bin/bash
#这是一个测试脚本用于测试kubectl是否可用
#列出测试的tomcat
kubectl get pods -o wide | grep tomcat
IP=`kubectl get pods -o wide | awk -F ' ' 'NR!=1{print $6}'`
elinks -dump http://$IP:8080 

