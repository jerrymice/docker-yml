#!/bin/bash
#拉取镜像列表

#打印命令帮助信息
help() {
    echo "-h          --help print command help info"
    echo "-l          --list print kubernetes images list"
    echo "-p          --pull pull kubernetes images"
    echo "-e path     --export export kubernetes images to target path, default target path: ~/kubernetes/kubernetes-image.tar.gz"
    echo "-i path     --import import kubernetes images for source path,default source path: ~/kubernetes/kubernetes-image.tar.gz"
}
#当前脚本目录
base_dir=$(cd `dirname $0`; pwd)
cache_file_name=k8s-images-cache
#没有参数时打印帮助信息
if [ $# = 0 ];then
    help
    exit 1
else
    #格式化参数
    ARGS=`getopt -l pull,reset,list,help -- "$@" 2>/dev/null`
fi
#参数不正确时打印帮助信息
if [ $? -ne 0 ];then
    help
fi
until [ -z "$1" ]; do
    case "$1" in
        #重新生成镜像列表
        -r|--reset)
            if [ ! -d $base_dir/cache/ ]; then
                mkdir -p $base_dir/cache/
            fi
            kubeadm config images list>$base_dir/cache/$cache_file_name
            break;;
        #打印帮助信息
        -h|--help)
            help
            break;;  
        #打印镜像列表信息 
        -l|--list)
            if [ ! -d $base_dir/cache/ ]; then
                mkdir -p $base_dir/cache/
            fi
            if [[ ! -f $base_dir/cache/$cache_file_name || ! -s $base_dir/cache/$cache_file_name ]]; then
                kubeadm config images list>$base_dir/cache/$cache_file_name
            fi
            cat $base_dir/cache/$cache_file_name
            break;;
        -p|--pull)
            mirror=mirrorgooglecontainers
            google=k8s.gcr.io
            K8S_IMAGES=$($0 -l)
            for source_image in $K8S_IMAGES; do
                image_part=`echo $source_image | awk -F '/' '{print \$2}'`
                if [[ $image_part =~ "coredns" ]]; then
                    mirror_image="coredns/$image_part"
                else
                    mirror_image=$mirror/$image_part
                    echo "正在拉取$mirror_image"
                fi
                docker pull $mirror_image
                docker tag  $mirror_image $google/$image_part
            done
            mirror=mirrorgooglecontainers
            docker rmi `docker images | grep $mirror | awk -F ' ' '{print $1,$2}' OFS=':'`
            mirror=coredns/
            docker rmi `docker images | grep $mirror | awk -F ' ' '{print $1,$2}' OFS=':'`
            break;;
        -e|--export)
            out_file_name=~/kubernetes/kubernetes-image.tar.gz
            if [ -n "$2" ]; then
                out_file_name=$2
            fi
            mkdir -p `dirname $out_file_name`
            K8S_IMAGES=$($0 -l)
			image_list=""
			for image in ${K8S_IMAGES[@]}; do
			    image_list+=$image" "
			done
			echo "正在导出像........"
			echo "docker save $image_list -o $out_file_name"
			docker save $image_list -o $out_file_name
            if [ $? -eq 0 ]; then
                echo "镜像导出成功,file:$out_file_name" 
            fi
            break;;
        -i|--import)
            image_tar_path=~/kubernetes/kubernetes-image.tar.gz
            if [ -n "$2" ]; then
                image_tar_path=$2
            fi
            if [[ $image_tar_path == *@* ]]; then
                file_name=$(basename $image_tar_path)
			    echo "正在传输文件...."
                mkdir -p /tmp
			    scp $image_tar_path /tmp/kubernetes-image.tar.gz
			    echo "正在导入kubernetes images"
			    docker load -i /tmp/kubernetes-image.tar.gz
            else
                echo "正在导入kubernetes images"
                docker load -i $image_tar_path
            fi
            if [ $? -eq 0 ]; then
                echo "镜像导入成功"
            fi
            break;;
        --)
            break;;
        *)
            help
            break;;
        esac
done
