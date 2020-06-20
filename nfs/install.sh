#!/bin/bash
mkdir /nfs-data
echo "创建nfs-data目录成功"
yum install -y nfs-utils
echo "安装nfs成功"
#设置NFS目录权限
echo "/nfs-data/ *(rw,sync,anonuid=0,anongid=0)">/etc/exports
#写配置文件
cat > /etc/sysconfig/nfs << EOF
RQUOTAD_PORT=30001
LOCKD_TCPPORT=30002
LOCKD_UDPPORT=30002
MOUNTD_PORT=30003
STATD_PORT=30004
EOF
#写防火墙规则
cat > /tmp/nfs-config-cache << EOF
#nfs 配置开始
-A INPUT -p tcp --dport 111 -j ACCEPT
-A INPUT -p udp --dport 111 -j ACCEPT
-A INPUT -p tcp --dport 2049 -j ACCEPT
-A INPUT -p udp --dport 2049 -j ACCEPT
-A INPUT -p tcp --dport 30001:30004 -j ACCEPT
-A INPUT -p udp --dport 30001:30004 -j ACCEPT
#nfs 配置结束
EOF
cat /tmp/nfs-config-cache
IFS=$'\n\n'
#先删除旧的配置,再追加新的配置
nfs_iptables_rule=$(cat /tmp/nfs-config-cache)
for i in $nfs_iptables_rule
do
    sed -i "s/$i//" /etc/sysconfig/iptables
done
nfs_iptables_rule=$(sed ":tag;N;s/\n/\\\n/;b tag" /tmp/nfs-config-cache)
echo "$nfs_iptables_rule"
sed -i "s/--dport 22 -j ACCEPT/&\n$nfs_iptables_rule/" /etc/sysconfig/iptables
echo "写入配置文件成功"
systemctl enable rpcbind.service
systemctl enable nfs-server.service
systemctl start rpcbind.service
systemctl start nfs-server.service
echo "启动服务成功"
showmount -e 127.0.0.1

