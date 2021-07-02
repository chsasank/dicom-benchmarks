#!/bin/bash
set -e
cd "$(dirname "$0")"
tar -xzf large_dicom_dir.tar.gz

servers=( "$@" )
for server in "${servers[@]}"
do
    arr=(${server//:/ })
    host=${arr[0]}
    port=${arr[1]}
    echo "dcmsend on $host:$port"
    echoscu $host $port
    time dcmsend $host $port large_dicom_dir/*
    echo '--'
done
