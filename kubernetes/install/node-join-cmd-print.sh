#!/bin/bash
IP=`ifconfig eth0 | grep inet | grep -v inet6 | awk -F ' ' '{print $2}'`
k8s_master_host=$IP:6443
token=`kubeadm token list | awk -F ' ' 'END{print \$1}'`
token_ca_cert_hash=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
echo "kubeadm join $k8s_master_host --token $token --discovery-token-ca-cert-hash sha256:$token_ca_cert_hash --node-name=机器加入集群的名称,如kube-node1,在集群内不要重复"
