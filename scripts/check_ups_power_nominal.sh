#!/bin/bash
if [ -z $1 ]
then
        echo "no argument supplied"
        exit 2
fi


RESULT=$(/bin/upsc ${1} 2>&1 | grep "ups.power.nominal" | awk '{ print $2 }' )

if [ $(echo "${RESULT} != 2000" | bc) -ne 0 ]
then
        echo "Critical - Power nominal  $RESULT | Power=$RESULT;;;"
        exit 2
fi

echo "Ok - Power nominal $RESULT | Power=$RESULT;;;"
exit 0

