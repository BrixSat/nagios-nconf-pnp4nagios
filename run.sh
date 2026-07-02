#!/bin/bash
docker run -d \
  -e "stack=geo" \
  -e "colo=hkg1" \
  -p 8082:80 \
  -i -t \
  --volume "/opt/nagios/etc:/usr/local/nagios/etc" \
  --volume "/opt/nagios/plugins:/usr/local/nagios/libexec" \
  --volume "/opt/nagios/perfdata:/usr/local/pnp4nagios/var/perfdata" \
  --volume "/opt/nagios/mysql:/var/lib/mysql/" \
  --volume "/opt/nagios/home:/home/nagios/" \
  --name nagios-4.5.13 \
  nagiosnconf:4.5.13

