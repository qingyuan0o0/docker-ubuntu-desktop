#!/bin/bash
while [ 1 ]
do
  ps -fe|grep Xtightvnc |grep -v grep
  if [ $? -ne 0 ]
  then
  echo "start vnc ..."
  date
  /usr/bin/vncserver :1 -geometry 1280x800 -depth 24
  else
  echo "vnc is running"
  fi
  sleep 30
 done
