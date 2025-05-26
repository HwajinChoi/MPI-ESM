#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/code/Test_flat10
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_flat10_cdr_001_cfcs_ideal/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw

for year in $(seq 2136 2149); do
  A=test_flat10_cdr_001_cfcs_ideal_hamocc_data_3d_mm_${year}0101_${year}1231.nc

  echo "Processing file: $A"
  input="${dir1}/${A}"
  output1="${dir2}/test_flat10_cdr_001_cfcs_ideal_dissic_${year}0101_${year}1231.nc"
  output2="${dir2}/test_flat10_cdr_001_cfcs_ideal_dissicnat_${year}0101_${year}1231.nc"

  cdo -s -selname,dissic $input $output1
  cdo -s -selname,dissicnat $input $output2
  echo "Processed ${output1}"
  echo "Processed ${output2}"
done 


