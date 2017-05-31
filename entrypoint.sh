#!/bin/bash
/usr/bin/vncserver :1 -geometry 1280x800 -depth 24
/usr/bin/supervisord -c /etc/supervisord.conf
exec "$@"
