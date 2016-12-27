#!/bin/bash
docker run -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN --name=cluster.dns.server --network=docker --ip=172.18.0.250 tumingjian/dnsmasq
