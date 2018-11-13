#!/bin/sh

# first error manager

if [ $# -le 0 ]; then
	echo "
Usage : ./snmp_check [C_KEY][OPTION][HOST]
OPTION:
--local :	test localhost snmp
-h 	:	Test one host, who's the next argument
--list 	:	test a list of hosts contained in a file, who's the next argument."
	echo "Error : no arguments." 1>&2
	exit
fi

#start

if [ $2 == "--local" ]; then
	output=`snmpwalk -v 2c -c $1 -O e 127.0.0.1 | head`
                                if [[ $output =~ "SNMPv2-MIB::sysDescr.0" ]]; then
                                        echo "OK"
                                else
                                        echo "ERROR"
				fi
else
	if [ $2 == "-h" ]; then
		output=`snmpwalk -v 2c -c $1 -O e $3 | head`
                                if [[ $output =~ "SNMPv2-MIB::sysDescr.0" ]]; then
                                        echo "OK"
                                else
                                        echo "ERROR"
				fi
	else
		if [ $2 == "--list" ]; then
			while read host; do
				echo $host
				output=`snmpwalk -v 2c -c $1 -O e $host | head`
				if [[ $output =~ "SNMPv2-MIB::sysDescr.0" ]]; then
					echo "OK"
				else
					echo "ERROR"
				fi
			done < $3
		else
			echo "error" 1>&2
			exit
		fi
	fi
fi

