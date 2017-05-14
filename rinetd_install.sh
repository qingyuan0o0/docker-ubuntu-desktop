#!/bin/bash   
wget http://www.boutell.com/rinetd/http/rinetd.tar.gz  
tar zxvf rinetd.tar.gz
touch /etc/rinetd.conf
cd rinetd  
mkdir -p /usr/man/man8  
make && make install
echo "rinetd was installed successfully! Now please edit /etc/rinetd.conf"
echo "example 0.0.0.0 8080 192.168.1.1 8080"
