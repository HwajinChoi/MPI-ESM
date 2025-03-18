#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data/raw
dir2=/data/hjchoi/CMI/OBA/data/raw/spilt_levels

#for v in "o2" "u" "v" "temp" "wt" ;do
for v in "temp" ;do
 A=${dir1}/${v}_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc

 if [ ${v} = "wt" ] ;then
   w="sw_ocean"
 else
   w="st_ocean"
 fi
 B=${dir1}/${w}
 
    while IFS= read -r line
    do
        cdo -s -sellevel,${line} ${A} ${dir2}/${v}_${line}m_COBALT.199001-201712.nc 
    done < $B

done
