#!/bin/bash

if [ -z $1 ]
then
        echo "no argument supplied"
        exit 2
fi

RESULT=$(/bin/upsc ${1} 2>&1 | grep "outlet.1.status:" | awk '{ print $2 }' )

if echo "$RESULT" | grep -qi "^on$"; then
	echo "Ok $RESULT | Status=1;"
	exit 0
fi

echo "Critical $RESULT | Status=0;"
exit 2

