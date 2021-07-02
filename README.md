# DICOM Server Benchmarks

Comparing pynetdicom and dcmtk's dicom servers.

```
docker-compose up --build
```

In another terminal

```
docker-compose exec benchmark bash /srv/test/benchmark.sh pynetdicom:5252 dcmtk:5252
```

# On my windows machine

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

# On my linux server


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