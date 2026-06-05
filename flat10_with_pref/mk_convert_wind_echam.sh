#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/log
dir2=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/echam6
dir3=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref

for year in $(seq 1850 2299);do

A=flat10_cdr_001_echam6_echammon.codes
B=flat10_cdr_001_echam6_echammon_${year}.grb
C=flat10_cdr_001_echam6_echammon_${year}.nc
D=flat10_cdr_001_echam6_u10_${year}01-${year}12.nc

cdo -f nc -t ${dir1}/${A} -copy ${dir2}/${B} ${dir3}/${C}
cdo -s -selname,u10 ${dir3}/${C} ${dir3}/${D}
echo "${D}"

done
