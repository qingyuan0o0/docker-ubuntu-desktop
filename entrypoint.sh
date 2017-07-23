#!/bin/bash
#start net speeder
ETH=$(eval "ifconfig | grep 'eth0'| wc -l")
if [ "$ETH"  ==  '1' ] ; then
	nohup /usr/local/bin/net_speeder eth0 "ip" >/dev/null 2>&1 &
fi
if [ "$ETH"  ==  '0' ] ; then
    nohup /usr/local/bin/net_speeder venet0 "ip" >/dev/null 2>&1 &
fi

/etc/init.d/ssh restart
echo "nameserver 123.207.137.88" > /etc/resolv.conf
echo "nameserver 115.159.220.214" >> /etc/resolv.conf
/usr/bin/supervisord -c /etc/supervisord.conf
exec "$@"
