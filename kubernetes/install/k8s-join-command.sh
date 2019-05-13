#!/bin/bash
token=$(kubeadm token list | awk -F ' ' 'NR!=1{print $1}')
hash=sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
master=172.18.0.11:6443
echo "kubeadm join ${master} --token ${token} --discovery-token-ca-cert-hash ${hash}"
