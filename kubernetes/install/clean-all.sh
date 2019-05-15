#!/bin/bash

kubeadm reset -f 
rm -rf ~/.kube/
yum remove -y kubeadm kubectl kubelet
rm -rf node-cache-install
rm -rf cache
ipvsadm --clear
