#!/bin/bash

if [ -z ${1} ]
then
	echo "Check input parameters"
	exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "input.voltage" | awk '{ print $2 }' )

if [ $(echo "${RESULT} < 225" | bc) -ne 0 ]
then
        echo "Critical - Voltage $RESULT | Voltage=$RESULT;;;"
        exit 2
fi

echo "Ok - Voltage $RESULT | Voltage=$RESULT;;;"
exit 0

