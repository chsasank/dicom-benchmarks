# DICOM Server Benchmarks

Comparing pynetdicom and dcmtk's dicom servers.

```
docker-compose up --build
```

## Docker benchmarks

In another terminal

```
docker-compose exec benchmark bash /srv/test/benchmark.sh pynetdicom:5252 dcmtk:5252
```

### On my windows machine

On my system this returns

```
dcmsend on pynetdicom:5252

real    0m6.724s
user    0m0.697s
sys     0m0.080s
--
dcmsend on dcmtk:5252

real    0m51.090s
user    0m0.743s
sys     0m0.186s
--
```

And let's do some crazy experiments

```bash
my_ip=172.20.70.245  #put your ip here, prob from ifconfig
docker-compose exec benchmark bash /srv/test/benchmark.sh pynetdicom:5252 $my_ip:5254 dcmtk:5252 $my_ip:5255
```

This runs pynetdicom/dcmtk but from different networks (docker internal and system loopback)

```bash
dcmsend on pynetdicom:5252

real    0m6.927s
user    0m0.708s
sys     0m0.137s
--
dcmsend on 172.20.70.245:5254

real    0m9.468s
user    0m0.708s
sys     0m0.246s
--
dcmsend on dcmtk:5252

real    0m50.660s
user    0m0.552s
sys     0m0.367s
--
dcmsend on 172.20.70.245:5255

real    0m51.420s
user    0m0.584s
sys     0m0.437s
--
```

### On my linux server


```
my_ip=192.168.1.13
docker-compose exec benchmark bash /srv/test/benchmark.sh pynetdicom:5252 $my_ip:5254 dcmtk:5252 $my_ip:5255
```

Output:

```
dcmsend on pynetdicom:5252

real    0m6.460s
user    0m0.665s
sys     0m0.093s
--
dcmsend on 192.168.1.13:5254

real    0m6.420s
user    0m0.612s
sys     0m0.100s
--
dcmsend on dcmtk:5252

real    0m44.545s
user    0m0.602s
sys     0m0.259s
--
dcmsend on 192.168.1.13:5255

real    0m44.473s
user    0m0.692s
sys     0m0.127s
--
```

### On my M1 Mac

```
my_ip=192.168.0.117
docker-compose exec benchmark bash /srv/test/benchmark.sh pynetdicom:5252 $my_ip:5254 dcmtk:5252 $my_ip:5255
```

Output:

```
dcmsend on pynetdicom:5252

real	0m6.160s
user	0m0.346s
sys	0m0.141s
--
dcmsend on 192.168.0.117:5254

real	0m7.524s
user	0m0.406s
sys	0m0.212s
--
dcmsend on dcmtk:5252

real	0m12.288s
user	0m0.665s
sys	0m0.241s
--
dcmsend on 192.168.0.117:5255

real	0m8.179s
user	0m0.395s
sys	0m0.174s
--
```

## Pynetdicom built-in benchmark

```
$ python benchmark_script.py
Use yappi (y/n:)
n
Which benchmark do you wish to run?
  1. Storage SCU, 1000 datasets over 1 association
  2. Storage SCU, 1 dataset per association over 1000 associations
  3. Storage SCP, 1000 datasets over 1 association
  4. Storage SCP, 1000 datasets over 1 association (write)
  5. Storage SCP, 1000 datasets over 1 association (write fast)
  6. Storage SCP, 1000 datasets over 1 association (write fastest)
  7. Storage SCP, 1 dataset per association over 1000 associations
  8. Storage SCP, 1000 datasets per association over 10 simultaneous associations
  9. Storage SCU/SCP, 1000 datasets over 1 association
  10. Storage DCMTK SCU/SCP, 1000 datasets over 1 association
```

To run inside docker

```
docker-compose exec benchmark python3 /srv/test/benchmark_script.py
```

| Machine | Benchmark 3 (pynetdicom server) | Benchmark 10 (dcmtk server) |
| ---- | --- | -- |
| Mac (M1) | 9.32 s | 2.07 s|
| Mac (M1, inside docker) |  8.04 s | 11.33 s|
| Mac (Intel) | 9.50 s | 2.87 s|
| Mac (Intel, inside docker) |  8.48 s | 11.38 s|
| Ubuntu 18 (machine 1) | 6.51 s  | 51.09 s |
| Ubuntu 18 (machine 2) | 11.52 s | 15.56 s |
| Ubuntu 20 (machine 3) | 10.83 s | 10.20 s |
| Ubuntu 18 (machine 4, inside docker) | 10.15 s | 45.68 s  |


## Over Network

My machine = MBA M1
Their machine = Windows machine

```bash
my_ip=192.168.0.117
their_ip=192.168.0.119
docker-compose exec benchmark bash /srv/test/benchmark.sh $my_ip:5254 $my_ip:5255  $their_ip:5252   $their_ip:5253   $their_ip:5254   $their_ip:5255
```

```
dcmsend on 192.168.0.117:5254

real    0m7.552s
user    0m0.427s
sys     0m0.185s
--
dcmsend on 192.168.0.117:5255

real    0m7.617s
user    0m0.364s
sys     0m0.178s
--
dcmsend on 192.168.0.119:5252

real    0m14.388s
user    0m0.405s
sys     0m0.220s
--
dcmsend on 192.168.0.119:5253
  
real    0m20.440s
user    0m0.436s
sys     0m0.236s
--
dcmsend on 192.168.0.119:5254

real    0m17.937s
user    0m0.414s
sys     0m0.252s
--
dcmsend on 192.168.0.119:5255
  
real    1m3.758s
user    0m1.809s
sys     0m0.942s
--
```

What these ports are 

| host | port | explanation | time | 
| -- | -- | -- | -- |
| $my_ip | 5254 | pynetdicom storescp on docker | 7.552s |
| $my_ip | 5255 | dcmtk storescp on docker | 7.617s |
| $their_ip | 5252 | pynetdicom storescp on native | 14.388s |
| $their_ip | 5253 | dcmtk storescp on native | 20.440s |
| $their_ip | 5254 | pynetdicom storescp on docker | 17.937s | 
| $their_ip | 5255 | dcmtk storescp on docker | 1m3.758s |


