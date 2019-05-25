#!/bin/bash
#ERROR:   Get https://10.96.0.1:443/api/v1/endpoints?limit=500&resourceVersion=0: dial tcp 10.96.0.1:443: connect: no route to host
systemctl stop kubelet
systemctl stop docker
iptables --flush
iptables -tnat --flush
ipvsadm --clear
systemctl start kubelet
systemctl start docker
