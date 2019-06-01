#!/bin/bash
#安装ipvs 相关包

yum install -y ipvsadm ipset
#加载相关模块
DIR=$(cd `dirname $0`;pwd)
chmod +x $DIR/ipvs.modules
$DIR/ipvs.modules
#开机自动加载
cp -Rf $DIR/ipvs.modules /etc/sysconfig/modules/
lsmod | grep -e ipvs -e nf_conntrack_ipv4
echo "最后一步执行命令 kubectl edit configmap kube-proxy -n kube-system ,并修改mode的属性值为ipvs"
