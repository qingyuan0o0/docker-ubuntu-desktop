#!/bin/bash
echo "Loading /etc/rinetd.conf"
ps -fe|grep rinetd |grep -v grep
if [ $? -ne 0 ]
then
echo "start rinetd ..."
/usr/sbin/rinetd -c /etc/rinetd.conf
else
echo "Restart rinetd"
SID=`pgrep rinetd`
kill -9 $SID
unset SID
/usr/sbin/rinetd -c /etc/rinetd.conf
fi
#####
