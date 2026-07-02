#!/bin/bash

#RESULT=$(/bin/upsc ${1} 2>&1 | grep "output.frequency.nominal" | awk '{ print $2 }' )

if [ -z $1 ]
then
        echo "Missing parameter"
        exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "output.frequency.nominal" | awk '{ print $2 }' )

if [ $(echo "${RESULT} < 49" | bc) -ne 0 ]
then
        echo "Critical - Frequency nominal $RESULT | Frequency=$RESULT;;;"
        exit 2
fi

echo "Ok - Frequency nominal $RESULT | Frequency=$RESULT;;;"


exit 0
