#!/bin/bash

#RESULT=$(/bin/upsc ${1} 2>&1 | grep "ups.status" | awk '{ print $2 }' )
STATUS=$(upsc  ${1} 2>/dev/null | grep "ups.status"  | sed 's/: /=/g' |tr '\n' ' ' | tr -d 'ups.status=' | sed 's/ //g')

echo "Ups status: $STATUS | Status=${STATUS};;;;"

if [[ "${STATUS}" == "OL"  || "${STATUS}" == "OLCHRG" ]]
then
	exit 0
fi

exit 2
