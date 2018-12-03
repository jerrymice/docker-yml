#!/bin/bash
#安装docker-ce
yum remove docker-ce*
yum install docker-ce-17.09.0.ce-1.el7.centos.x86_64

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
yum install -y kubelet kubeadm kubectl
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

#添加其他节点命令(请在相应的节点机器上运行)
#kubeadm join 192.168.4.208:6443 --token r6sck4.dhx93qh4acxr6d0l --discovery-token-ca-cert-hash sha256:966db4635cb701bca173382e7c072dd779eae2b0658689c8c34b6c39f31dded5
