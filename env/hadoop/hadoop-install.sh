#!/bin/bash
sed -i 's/<configuration><\/configuration>/<configuration><property><name>dfs.replication<\/name><value>3<\/value><\/property><\/configuration>/g' core-site.xml
