#!/bin/bash

if [ -z $1 ]
then
	echo "Missing parameter"
	exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "output.frequency:" | awk '{ print $2 }' )

if [ $(echo "${RESULT} < 49" | bc) -ne 0 ]
then
        echo "Critical - Frequency $RESULT | Frequency=$RESULT;;;"
        exit 2
fi

echo "Ok - Frequency $RESULT | Frequency=$RESULT;;;"
exit 0

