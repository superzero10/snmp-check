#!/bin/sh

# first error manager

if [ $# -le 0 ]; then
	echo "
Usage : ./snmp_check [OPTION][HOST]
OPTION:
--local :	test localhost snmp
-h 	:	Test one host, who's the next argument
--list 	:	test a list of hosts contained in a file, who's the next argument."
	echo "Error : no arguments." 1>&2
	exit
fi

#start

if [ $1 = "--local" ]
then
	snmpwalk -v 2c -c EyesOfNetwork -O e 127.0.0.1 | head
else
	if [ $1 = "-h" ]
	then
		snmpwalk -v 2c -c EyesOfNetwork -O e $2 | head
	else
		if [ $1 = "--list" ]
		then
			while read host; do
				echo $host
				snmpwalk -v 2c -c EyesOfNetwork -O e $host | head
			done < $2
		else
			echo "error" 1>&2
			exit
		fi
	fi
fi

