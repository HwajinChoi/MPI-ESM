#!/bin/bash
dir0=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_002/outdata/mpiom
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_002/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/Test_advection
dir3=/work/uo1451/m301158/MPI-ESM/data/test_budget

for year in $(seq 2299 2299); do

 A=${dir1}/flat10_cdr_budget_002_hamocc_data_3d_mm_${year}0101_${year}1231.nc
 B=${dir2}/dissicnat_${year}01-${year}12.nc
 cdo -s -selname,dissicnat ${A} ${B}
 echo "${B}"

 A1=${dir0}/flat10_cdr_budget_002_mpiom_data_3d_mm_${year}0101_${year}1231.nc
 B1=${dir2}/velocity_${year}01-${year}12.nc
 cdo -s -selname,uo,vo,wo ${A1} ${B1}
 echo "${B1}"

done
