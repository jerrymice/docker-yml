#!/bin/bash
docker run -d -p 53:53/tcp -p 53:53/udp -v /opt/soft/docker/env/dns-etc:/mnt/dns-etc --env-file=/opt/soft/docker/env/dns.env --cap-add=NET_ADMIN --name=cluster.dns.server --network=docker-net --ip=172.18.0.250  tumingjian/dnsmasq
