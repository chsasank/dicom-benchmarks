#!/bin/bash
set -e
cd "$(dirname "$0")"

tar -xzf large_dicom_dir.tar.gz

port=5252
hosts=(pynetdicom dcmtk)
for host in "${hosts[@]}"
do
    echo "dcmsend on $host:$port"
    echoscu $host $port
    time dcmsend $host $port large_dicom_dir/*
    echo '--'
done
