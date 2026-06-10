#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/code/Test_flat10
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom
dir2=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw

for year in $(seq 1850 2299); do
  A=flat10_cdr_001_mpiom_data_3d_mm_${year}0101_${year}1231.nc

  echo "Processing file: $A"
  input="${dir1}/${A}"
  output="${dir2}/flat10_cdr_001_vel_${year}.nc"

  cdo -s -yearmean -selname,vo,uo $input $output
  echo "Processed ${output}"
done 

 cdo -s -mergetime ${dir2}/flat10_cdr_001_vel_????.nc ${dir2}/flat10_cdr_001_vel_1850-2299.nc
 rm -rf ${dir2}/flat10_cdr_001_vel_????.nc
