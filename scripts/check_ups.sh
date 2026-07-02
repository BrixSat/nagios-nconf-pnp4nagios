#!/bin/bash
#set -x
if [ -z ${1} ]
then
	echo "Missing args"
	exit 2
fi

NAGIOS=$(upsc  ${1} 2>/dev/null | grep -v "device.serial" | grep -v "ups.status" | grep -v "vendorid" | grep -v "ups.mfr" | grep -v "vendor.id" | grep -v "device.type" | grep -v "ups.firmware" | grep -v "ups.model" | grep -v "ups.serial" | grep -v "device.model" | grep -v "device" | grep -v "driver"  | sed 's/: /=/g' | sed -e ':1' -e 'N' -e '$!b1' -e 's/\n/;;;; /g' | sed 's/ //g')
STATUS=$(upsc  ${1} 2>/dev/null | grep "ups.status"  | sed 's/: /=/g' |tr '\n' ' ' | tr -d 'ups.status=' | sed 's/ //g')
NAGIOS=$(echo "$NAGIOS;;;;")
#set -x

if [[ "${STATUS}" == "OL" || "${STATUS}" == "OLCHRG" ]]
then
	echo -e "UPS OK - State: ${STATUS} | ${NAGIOS}\n"
	exit 0
fi
echo -e "UPS CRITICAL - State: ${STATUS} | ${NAGIOS}\n"
exit 2
