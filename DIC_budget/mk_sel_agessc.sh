#!/bin/bash

var=agessc # agessc 
pth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
outpth=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/for_latdepth

for S in "flat10_cdr_001"; do

 for year in $(seq 1850 2299); do
  echo "Processing ${S}, ${year}"
  hamocc=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${S}/outdata/mpiom/${S}_mpiom_data_3d_mm_${year}0101_${year}1231.nc
  cdo -selvar,${var} -selmon,12 ${hamocc} ${pth}/${var}_${S}_${year}12.nc
 done

 cdo -mergetime ${pth}/${var}_${S}_????12.nc ${pth}/${var}_${S}_185012-229912.nc
 rm -rf ${pth}/${var}_${S}_????12.nc

done

