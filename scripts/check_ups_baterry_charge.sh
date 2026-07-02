#!/bin/bash

if [ -z $1 ]
then
	echo "no argument supplied"
	exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "battery.charge" | awk '{ print $2 }' )

if [[ $RESULT -lt 90 || -z ${RESULT} ]]
then
	echo "Critical - Battery $RESULT % | Charge=$RESULT;;;"
	exit 2
fi

echo "Ok - Battery $RESULT % | Charge=$RESULT;;;"
exit 0
