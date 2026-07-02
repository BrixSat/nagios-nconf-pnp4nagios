#!/bin/bash

if [ -z $1 ]
then
        echo "no argument supplied"
        exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "ups.load" | awk '{ print $2 }' )

if [  -z ${RESULT} ]
then
	echo "Ups not found!"
	exit 2
fi


if [  $(echo "${RESULT} > 50" | bc) -ne 0 ]
then
        echo "Critical - Load  $RESULT | Load=$RESULT;;;"
        exit 2
fi

echo "Ok - Load $RESULT | Load=$RESULT;;;"
exit 0
