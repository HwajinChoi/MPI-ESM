#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels

for v in "o2" "u" "v" "temp" "wt" ;do

 if [ ${v} = "wt" ] ;then
   w="sw_ocean"
 else
   w="st_ocean"
 fi
 B=${dir1}/${w}
 
    while IFS= read -r line
    do
        A0=${dir2}/${v}_${line}m_lead__????.nc
#        A0=${dir2}/${v}_${line}m_lead_1_????.nc
        B0=${dir2}/${v}_${line}m_lead_2_1991-2017.nc
        cdo -s -mergetime ${A0} ${B0} 
    done < $B

done
