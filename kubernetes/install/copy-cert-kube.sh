#!/bin/bash
#复制admin.conf文件.让kubectl命令可用.
mkdir -p ~/.kube
cp -Rf /etc/kubernetes/admin.conf ~/.kube/config
chown $(id -u):$(id -g) ~/.kube/config


