#!/bin/bash

dir2=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw
for s in "flat10" "flat10_zec"  "flat10_cdr" ; do
 for year in $(seq 1850 2149); do
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_${s}_001_cfcs_ideal/outdata

 A=${dir1}/mon_${year}0101-${year}1231/test_${s}_001_cfcs_ideal_echam6_co2_gym_${year}.nc
 B=${dir2}/co2_flx_land_ocean_${s}_${year}.nc

 cdo -s -selname,co2_flx_land,co2_flx_ocean ${A} ${B}
 echo "Processed co2_flx_land_ocean_${s}_${year}.nc"

 done
done
