#!/bin/bash
#镜像站用户名
mirror_google=mirrorgooglecontainers
google=k8s.gcr.io
base_dir=$(cd `dirname $0`; pwd)
source $base_dir/k8s-image-list.sh --pull
for source_image in $K8S_IMAGES; do
    image_part=`echo $source_image | awk -F '/' '{print \$2}'`
    mirror_image=$mirror_google/$image_part
    echo "正在拉取$mirror_image"
    docker pull $mirror_image
    docker tag  $mirror_image $google/$image_part
done
docker rmi `docker images | grep $mirror_image | awk -F ' ' '{print $1,$2}' OFS=':'`
