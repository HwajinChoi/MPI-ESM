#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_pictrl_preform_001_spinup/outdata/mpiom
dir2=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw/preform_spinup

for year in $(seq 2802 2841); do
#for year in $(seq 1850 1851); do
  A=test_pictrl_preform_001_spinup_mpiom_data_3d_mm_${year}0101_${year}1231.nc

  echo "Processing file: $A"
  input="${dir1}/${A}"
  output1="${dir2}/preform_spinup_${year}.nc"

  cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 -yearmean -selname,preformed_O2,preformed_PO4,preformed_DIC,preformed_DICnat $input $output1
  echo "Processed ${output1}"
done
