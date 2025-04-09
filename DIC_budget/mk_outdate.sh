#!/bin/bash
#--------------------------------------------------------
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2/experiments/${exp}/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_DIC_budget/${exp}/raw

exp="test_pictrl_ver2_002_cfcs"
#--------------------------------------------------------------
#----------HAMOCC----------------------------------------------

for var in "dissic";do 
for y in $(seq 1850 1 1900);do
 file=${exp}_hamocc_data_3d_mm_${y}0101_${y}1231.nc
 cdo -s -selname,${var} ${dir1}/${file} ${dir2}/${var}_${exp}_${y}0101_${y}1231.nc
 echo "${var}_${exp}_${y}"
done
done
#--------------------------------------------------------------
#---------MPIOM-----------------------------------------------

for var in "uo" "vo";do 
for y in $(seq 1850 1 1900);do
 file=${exp}_mpiom_data_3d_mm_${y}0101_${y}1231.nc
 cdo -s -selname,${var} ${dir1}/${file} ${dir2}/${var}_${exp}_${y}0101_${y}1231.nc
 echo "${var}_${exp}_${y}"
done
done
