FROM ubuntu:14.04
MAINTAINER Alexandr Opryshko <sclif13@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \ 
&& apt-get --yes build-dep wireshark \
&& apt-get --yes install qt5-default wget libwiretap3 dbus

RUN cd /tmp && wget https://2.na.dl.wireshark.org/src/wireshark-1.12.4.tar.bz2 \
&& tar -xjf wireshark-1.12.4.tar.bz2 \
&& cd wireshark-1.12.4 \
&& ./configure && make -j 5 && make install 

RUN dbus-uuidgen > /etc/machine-id && mkdir /pcap \
&& sed 's/dofile = function() error("dofile " .. hint) end//' /usr/local/share/wireshark/init.lua > /tmp/ddd \
&& mv /tmp/ddd /usr/local/share/wireshark/init.lua

RUN ldconfig


#docker run  -i -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/pcap:/pcap -t sclif/wireshark:ubuntu /usr/local/bin/wireshark
# Разрешить Xsecurity запуск любых подключений от имени root http://habrahabr.ru/post/240509/
# xhost +si:localuser:root   
