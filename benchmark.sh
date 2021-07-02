#!/bin/bash
set -e
cd "$(dirname "$0")"

unzip -o large_dicom_dir.zip

hosts=(pynetdicom dmckt)
for port in  "${array[@]}"
do
    echo "dcmsend on $ip:$port"
    echoscu $ip $port
    time dcmsend $ip $port TEN*/*
    echo '--'
done
