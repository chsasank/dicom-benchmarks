# DICOM Server Benchmarks

Comparing pynetdicom and dcmtk's dicom servers.

```
docker-compose up --build
```

In another terminal

```
docker-compose exec benchmark bash /srv/test/benchmark.sh
```

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