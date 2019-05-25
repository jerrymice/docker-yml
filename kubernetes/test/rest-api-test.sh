#!/bin/bash
export server=10.96.0.1:443
export apiPath=api/v1/namespaces/kube-system/services/kube-dns
curl https://$server/$apiPath --cacert /etc/kubernetes/pki/ca.crt --key /root/docker-yml/kubernetes/user-account/jerrymice.key --cert /root/docker-yml/kubernetes/user-account/jerrymice.crt

