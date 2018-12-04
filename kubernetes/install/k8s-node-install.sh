#!/bin/bash

#本机IP地址
MASTER_HOST_IP=192.168.4.40
TOKEN=""
DISCOVERY_TOKEN_CA_CERT_HASH=""
STEP=0
if [ -f 'node-install-cache' ];then
  STEP=`cat node-install-cache | awk -F ':' '{print $2}'`
fi
while (("$STEP < 4" ))
do
case $STEP in
0 )
	#安装docker-ce
	echo "step:0">node-install-cache
	yum -y remove docker-ce*
	yum -y install docker-ce-17.09.0.ce-1.el7.centos.x86_64
	echo "step:1">node-install-cache
;;
1 )
	#添加aliyuncs.com镜像仓库和docker-cn镜像仓库
cat <<EOF > /etc/docker/daemon.json
{
   "registry-mirrors": ["https://s4z40bwn.mirror.aliyuncs.com","https://registry.docker-cn.com"]
}
EOF
	systemctl start docker
	#添加kubernetes aliyu yum 仓库
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
	#安装
	yum -y remove kubelet kubeadm kubectl
	yum -y install kubelet kubeadm kubectl
	echo "step:2">node-install-cache
;;
2 )
	#启用 kubelet服务
	systemctl enable kubelet.service
	#关闭swap区域
	swapoff -a
	#设置 SELinux
	setenforce 0
	sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
	#开放端口ectd:2379-2380;api server:6443;kubelet api:10250;kube-scheduler:10251;kube-controller-manager:10252
	firewall-cmd --zone=public --add-port=10250-10252/tcp --permanent
	systemctl reload firewalld
	echo "step:3">node-install-cache
;;
3 )
       # kubeadm join 192.168.4.208:6443 --token $TOKEN --discovery-token-ca-cert-hash $DISCOVERY_TOKEN_CA_CERT_HASH
	echo "add node success"
        echo "step:4">node-install-cache
;;
esac
STEP=$[STEP+1]
done
echo "kubernetes node already installed"
	#添加其他节点命令(请在相应的节点机器上运行)
	#kubeadm join 192.168.4.208:6443 --token r6sck4.dhx93qh4acxr6d0l --discovery-token-ca-cert-hash sha256:966db4635cb701bca173382e7c072dd779eae2b0658689c8c34b6c39f31dded5
