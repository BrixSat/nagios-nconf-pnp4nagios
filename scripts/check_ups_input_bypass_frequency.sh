#!/bin/bash
#set -x
RESULT=$(/bin/upsc ${1} 2>&1 | grep "input.bypass.frequency" | awk '{ print $2 }' )
echo $RESULT

exit 0
