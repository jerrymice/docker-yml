#!/bin/bash
IP=`ifconfig eth0 | grep inet | awk -F ' ' 'NR==1{print $2}'`
k8s_master_host=$IP:6443
token=`kubeadm token list | awk -F ' ' 'END{print \$1}'`
token_ca_cert_hash=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
echo "在节点机器上执行以下命令,让机器加入kubernetes集群"
echo "kubeadm join $k8s_master_host --token $token --discovery-token-ca-cert-hash sha256:$token_ca_cert_hash --node-name=机器名"
