#!/bin/bash
docker rm -f cluster.vpn.server
docker run --network=docker-net --name=cluster.vpn.server --env-file=./env/vpn.env -p 500:500/udp -p 4500:4500/udp -v /lib/modules:/lib/modules:ro -v /opt/soft/docker:/opt/soft/docker -d --privileged tumingjian/ipsec-vpn-server
