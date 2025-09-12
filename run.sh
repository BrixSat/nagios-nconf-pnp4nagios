#!/bin/bash
docker run -d -e "stack=geo" -e "colo=hkg1" -p 8082:80 -i -t nagiosnconf:latest \
--volume "/opt/nagios/etc:/usr/local/nagios/etc"  --volume "/opt/nagios/libexec:/usr/local/nagios/libexec" \
--volume "/opt/nagios/perfdata:/usr/local/pnp4nagios/var/perfdata" --volume "/opt/nagios/mysql:/var/lib/mysql/"
