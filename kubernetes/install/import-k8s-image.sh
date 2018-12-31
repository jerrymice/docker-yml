#!/bin/bash
image_tar_path=root@172.18.0.6:~/kubernetes/kubernetes-image.tar.gz
file_name=$(basename $image_tar_path)
target_path=~/kubernetes
if [ -n $1 ]; then
    target_path=$1
    mkdir -p $1
fi
echo "正在传输文件...."
scp $image_tar_path $target_path
echo "正在导入kubernetes images"
docker load -i $target_path/$file_name
echo "导入完成"

