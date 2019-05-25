#!/bin/bash
#1.创建私钥
openssl genrsa -out jerrymice.key 2048
#根据私钥生成证书
openssl req -new -key jerrymice.key -out jerrymice.csr -subj "/CN=jerrymice/O=com.github"
#用服务器证书签名用户证书
openssl x509 -req -in jerrymice.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out jerrymice.crt -days 500
#在kubernetes中新增配置
kubectl config set-credentials jerrymice --client-certificate=jerrymice.crt  --client-key=jerrymice.key
#创建用户上下文
kubectl config set-context jerrymice-context --cluster=kubernetes --namespace=kube-system --user=jerrymice
#添加角色
kubectl apply -f admin-all.yaml
#添加用户jerrymice
kubectl apply -f user.yaml
#添加ServiceAccount jerrymice
kubectl apply -f user-sa.yaml

