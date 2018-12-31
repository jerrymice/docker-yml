#!/bin/bash
#拉取镜像列表

#打印命令帮助信息
help() {
    echo "-h     --help print command help info"
    echo "-r     --reset reset pull kubernetes images list"
    echo "-p     --pull only pull kubernetes images list,but not download images"
    echo "-l     --list print kubernetes images list"
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
if [ $? != 0 ];then
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
            shift;;
        #打印帮助信息
        -h|--help)
            help
            break;;  
        #打印镜像列表信息 
        -l|--list)
            cat $base_dir/cache/$cache_file_name
            shift;;
        -p|--pull)
            if [ ! -d $base_dir/cache/ ]; then
                mkdir -p $base_dir/cache/
            fi
            if [[ ! -f $base_dir/cache/$cache_file_name || ! -s $base_dir/cache/$cache_file_name ]]; then
                kubeadm config images list>$base_dir/cache/$cache_file_name
            fi
            shift;;
        --)
            break;;
        *)
            help
            break;;
        esac
done
export K8S_IMAGES=$(cat $base_dir/cache/$cache_file_name)
