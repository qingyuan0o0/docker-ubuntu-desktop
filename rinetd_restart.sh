#!/bin/bash
SID=`pgrep rinetd`
kill -9 $SID
unset SID
echo "rinetd stopped"
/usr/sbin/rinetd -c /etc/rinetd.conf
echo "rinetd started"
