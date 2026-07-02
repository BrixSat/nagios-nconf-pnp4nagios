#!/bin/bash

if [ -z $1 ]
then
        echo "no argument supplied"
        exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "battery.voltage:" | awk '{ print $2 }' )

echo $RESULT

exit 0
