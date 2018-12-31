#!/bin/bash
out_file_name=~/kubernetes/kubernetes-image.tar.gz
if [ -n "$1" ]; then
    out_file_name=$1
fi
base_dir=$(cd `dirname $0`; pwd)
source $base_dir/k8s-image-list.sh --pull
image_list=""
for image in ${K8S_IMAGES[@]}; do 
    image_list+=$image" " 
done
echo "正在导出像........"
echo "docker save $image_list -o $out_file_name"
docker save $image_list -o $out_file_name
echo "导出镜像完成,你可以通过命令 docker load -i $out_file_name 在其他机器上导入镜像"


