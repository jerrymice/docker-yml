1.所有节点先用k8s-node-install.sh
2.MASTER节点用k8s-master-install.sh
2.1 安装完成后要清除MASTER的污点,因为虚拟机资源不够用
2.2 kubelet服务不安装cni也不影响集群
2.3 kubelet服务无法启动多半是cgroup-driver与docker的有冲突,需要替换配置文件10-kubeadm.conf
3.MASTER节点安装完成之后.需要安装kubernetes的网络插件 cailco
4.其他节点用node-join-cmd-print.sh 列出加入集群命令,通过命令加入集群
5.ipvs为安装可选项.但强烈推荐安装
6.node-install-cache文件和cache目录,为缓存数据.可以清空.4.node-install-cache文件和cache目录,为缓存数据.可以清空.4.node-install-cache文件和cache目录,为缓存数据.可以清空.4.node-install-cache文件和cache目录,为缓存数据.可以清空.

