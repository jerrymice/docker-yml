#!/bin/bash

#本机IP地址

MASTER_HOST_IP=`ifconfig eth0 | grep inet | awk -F ' ' 'NR==1{print $2}'`
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
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum-config-manager --add-repo http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
	yum makecache fast
	echo "step:1">node-install-cache
;;
1 )
        #yum -y remove docker-ce*
        #yum -y install docker-ce-17.09.0.ce-1.el7.centos.x86_64 --nogpgcheck
	#添加aliyuncs.com镜像仓库和docker-cn镜像仓库
if [ ! -f '/etc/docker/daemon.json' ];then
	mkdir -p /etc/docker
	touch /etc/docker/daemon.json
fi
cat <<EOF > /etc/docker/daemon.json
{
   "registry-mirrors": ["https://s4z40bwn.mirror.aliyuncs.com","https://registry.docker-cn.com"],
   "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
	systemctl enable docker
    systemctl daemon-reload
	systemctl start docker
	#安装
	yum -y remove kubelet kubeadm kubectl
    version=1.18.4-0.x86_64
	yum install -y kubeadm-$version kubectl-$version kubelet-$version --nogpgcheck
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
	#firewall-cmd --zone=public --add-port=10250-10252/tcp --permanent
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
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
#开启IPV4内核转发
ip_forward=$(cat /etc/sysconfig/network | grep FORWARD_IPV4=\"YES\")
if [ ! -n "$ip_forward" ]; then
    echo "FORWARD_IPV4=\"YES\"">>/etc/sysconfig/network
fi
echo "1" > /proc/sys/net/ipv4/ip_forward
sysctl --system
#防止DNS被覆盖
dns_none=$(cat /etc/NetworkManager/NetworkManager.conf | grep dns=none | grep -v \#dns=none)
if [ ! -n "$dns_none" ]; then
    echo "dns=none" >>/etc/NetworkManager/NetworkManager.conf
    systemctl restart NetworkManager
fi
#安装IPVS内核转发
../ipvs/install.sh
echo "kubernetes node already installed"
	#添加其他节点命令(请在相应的节点机器上运行)
	#kubeadm join 192.168.4.208:6443 --token r6sck4.dhx93qh4acxr6d0l --discovery-token-ca-cert-hash sha256:966db4635cb701bca173382e7c072dd779eae2b0658689c8c34b6c39f31dded5
