#!/bin/bash

 dir2=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw

for s in "flat10" "flat10_zec"  "flat10_cdr" ; do
 for year in $(seq 1850 2149); do
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_${s}_001_cfcs_ideal/outdata/jsbach

 A=${dir1}/test_${s}_001_cfcs_ideal_jsbach_vegmon_${year}.grb
 B=${dir2}/co2_flx_land_ocean_${s}_${year}.nc

 cdo -s -f nc copy ${A} ${dir2}/imsi.nc # Changing grd to nc
 echo "Processed test_${s}_001_cfcs_ideal_jsbach_vegmon_${year}.grb"
 cdo -s -selname,var56  ${dir2}/imsi.nc ${dir2}/imsi_${year}.nc
 echo "Processed imsi_${year}.nc"
 rm -f ${dir2}/imsi.nc
 done
 cdo -s -mergetime ${dir2}/imsi_????.nc ${dir2}/Land_${s}_flux_18500101_21491231.nc
 rm -f  ${dir2}/imsi_????.nc

done
