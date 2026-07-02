#!/bin/bash

RESULT=$(/bin/upsc ${1} 2>&1 | grep "input.frequency" | awk '{ print $2 }' )
echo $RESULT


exit 0
