#!/bin/bash

#本机IP地址
MASTER_HOST_IP=`ifconfig eth0 | grep inet | awk -F ' ' 'NR==1{print $2}'`
POD_NETWORK_CIDR=172.20.0.0/16
if [ -n "$1" ]; then
 POD_NETWORK_CIDR=$1
fi
echo "kubernetes网段:$POD_NETWORK_CIDR"
#在master上初始化集群
kubeadm init --apiserver-advertise-address=$MASTER_HOST_IP --pod-network-cidr=172.20.0.0/16 --node-name=kube-master  
echo "step:8">node-install-cache
#复制admin.conf文件.让kubectl命令可用.
mkdir -p ~/.kube
#cp -Rf /etc/kubernetes/admin.conf ~/.kube/config
ln -s /etc/kubernetes/admin.conf ~/.kube/config
chown $(id -u):$(id -g) ~/.kube/config
#允许调度MASTER节点
kubectl taint node kube-master node-role.kubernetes.io/master-
kubectl get pods -n kube-system
#执行测试
kubectl get nodes
echo "step:9">node-install-cache
echo "kubernetes master node install success"
echo "kubernetes master already installed"
