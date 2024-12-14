#!/bin/bash

# tao thu muc chinh data neu chua ton tai
mkdir -p /home/hv/buoi03/bt1/data

# tao thu muc con trong data/a tu 1 den 100
for i in {1..100}
do 
  mkdir -p "/home/hv/buoi03/bt1/data/a/$i"
done

# tao thu muc con trong /data/b tu b1000 den b1009
for i in {1000..1009}
do 
  mkdir -p "/home/hv/buoi03/bt1/data/b/b$i"
done

echo "Da tao xong cac thu muc roi nha"
