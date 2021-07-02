FROM ubuntu
RUN apt-get update && apt-get install -y python3-pip
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y dcmtk
RUN apt-get update && apt-get install -y unzip
RUN pip install pynetdicom
