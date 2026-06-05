#!/bin/bash
for s in "flat10" "flat10_zec" "flat10_cdr";do
 if [ $s = "flat10" ]; then
  S=002
 else
  S=001
 fi

for year in $(seq 1850 2299); do
 dir0=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${s}_${S}/outdata/jsbach
 dir2=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${s}_${S}/log

 A=${dir2}/${s}_${S}_jsbach_veg.codes 
 B=${s}_${S}_jsbach_vegmon_${year}
 C=${s}_${S}_box_Cpools_total_${year}01-${year}12.nc 

 cdo -s -f nc -t ${A} -copy ${dir1}/${B}.grb ${dir0}/${B}.nc
 cdo -s -selname,box_Cpools_total ${dir0}/${B}.nc ${dir0}/${C}
 rm -f ${dir0}/${B}.nc
 done

  cdo -s -mergetime ${dir0}/${s}_${S}_box_Cpools_total_????01-????12.nc ${dir0}/${s}_box_Cpools_total_1850-2299.nc
  rm -f ${dir0}/${s}_${S}_box_Cpools_total_????01-????12.nc
done

