#!/bin/bash

#本机IP地址
MASTER_HOST_IP=192.168.1.113
STEP=0
if [ -f 'node-install-cache' ];then
  STEP=`cat node-install-cache | awk -F ':' '{print $2}'`
fi
while (("$STEP < 9" ))
do
case $STEP in
0 )
sh k8s-node-install.sh
;;
1 )
sh k8s-node-install.sh
;;
2 )
sh k8s-node-install.sh
;;
3 )
	echo "step:4">node-install-cache
;;
4 )
        echo "step:5">node-install-cache
;;
5 )
	#开放端口ectd:2379-2380;api server:6443;
        #firewall-cmd --zone=public --add-port=6443/tcp --permanent
        #firewall-cmd --zone=public --add-port=2379-2380/tcp --permanent
	#systemctl reload firewalld
	echo "step:6">node-install-cache
;;
6 )
    ./download-image.sh    
    echo "step:7">node-install-cache;
;;
7 )
        #在master上初始化集群
        kubeadm init --apiserver-advertise-address=$MASTER_HOST_IP --pod-network-cidr=172.18.0.0/16 --node-name=kube-master 
        echo "step:8">node-install-cache
;;
8 )
        #复制admin.conf文件.让kubectl命令可用.
        mkdir -p ~/.kube
        cp -Rf /etc/kubernetes/admin.conf ~/.kube/config
        chown $(id -u):$(id -g) ~/.kube/config

        #执行测试
        kubectl get nodes
        echo "step:9">node-install-cache
        echo "kubernetes master node install success"
;;
esac
STEP=$[STEP+1]
done
echo "kubernetes master already installed"
