#!/bin/bash

#本机IP地址
MASTER_HOST_IP=192.168.4.40
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
        firewall-cmd --zone=public --add-port=6443/tcp --permanent
        firewall-cmd --zone=public --add-port=2379-2380/tcp --permanent
	systemctl reload firewalld
	echo "step:6">node-install-cache
;;
6 )
        #镜像站用户名
        MIRROR_IMAGE_TAG=mirrorgooglecontainers
        SOURCE_IMAGE_TAG=k8s.gcr.io
        #获取需要拉取的镜像文件列表
        images=`kubeadm config images list | awk -F '/' '{print $2}'`
        coredns="coredns"
                for image in $images;
        do
        if [[ $image == $coredns* ]];then
                echo "正在拉取$SOURCE_IMAGE_TAG/$image......镜像";
                docker pull $coredns/$image
                docker tag $coredns/$image $SOURCE_IMAGE_TAG/$image
                docker rmi $coredns/$image
        else
                echo "正在拉取$SOURCE_IMAGE_TAG/$image"
                docker pull $MIRROR_IMAGE_TAG/$image
                docker tag $MIRROR_IMAGE_TAG/$image $SOURCE_IMAGE_TAG/$image
                docker rmi $MIRROR_IMAGE_TAG/$image
        fi
        done
        echo "step:7">node-install-cache;
;;
7 )
        #在master上初始化集群
        kubeadm init —apiserver-advertise-address=$MASTER_HOST_IP —pod-network-cidr=172.18.0.0/16
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
