#!/bin/bash

dir0=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_002/outdata/hamocc
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_002/outdata/mpiom
dir2=/work/uo1451/m301158/MPI-ESM/data/Test_budget_close

for year in $(seq 1850 2298); do

cdo -s -selname,uo,vo,wo ${dir1}/flat10_cdr_budget_002_mpiom_data_3d_mm_${year}0101_${year}1231.nc ${dir2}/velocity_${year}01_${year}12.nc
echo "velocity_${year}01_${year}12.nc"
cdo -s -selname,dissicnat ${dir0}/flat10_cdr_budget_002_hamocc_data_3d_mm_${year}0101_${year}1231.nc ${dir2}/dissicnat_${year}01_${year}12.nc
echo "dissicnat_${year}01_${year}12.nc"

done
