#!/bin/bash
## by Bo Liu
## To extract obgc tracer inventories at the start of the run

startyear=1850
length=450

var=isco212 

exp=flat10_zec
logdir=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${exp}_001/log/
outdata=dictot_invent_${exp}

if [ -f $outdata ]; 
then
	echo $outdata 'exit, remove it'
	rm $outdata; 
fi
touch $outdata
T=$((0))
while [ "$T" -lt "$length" ]
do
	Tnext=$((startyear+T))
#	echo ${T} ${Tnext}"*"
	bgcout=${logdir}'*hamocc_bgcout_'${Tnext}'0101*'
## read the 1st none-zero number
	grep "$var " ${bgcout} | head -1  > line1
	read temp invent meancon < line1
#	echo $invent
	if [ -z $invent ];
	then
		echo 'invent empty, cause' 
		echo $bgcout 'not exist, stop here'
		T=$((length+1))
	else
		printf '%s\n' $invent >> $outdata
		((T++))
	fi
	rm line1
done #files

#done #var

