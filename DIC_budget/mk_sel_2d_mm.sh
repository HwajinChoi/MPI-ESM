#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_budget

#for var in "intpp" ;do 
#for var in "fgco2" "fgco2nat" ;do 
for var in "dpco2" ;do 
 for year in $(seq 1850 2299); do
  A=flat10_cdr_001_hamocc_data_2d_mm_${year}0101_${year}1231.nc
  B=flat10_cdr_${var}_${year}0101_${year}1231.nc
  C=flat10_cdr_${var}_185001_229912.nc
  cdo -s selname,${var} ${dir1}/${A} ${dir2}/${B}
  echo "${B}"
 done
  cdo -s mergetime ${dir2}/flat10_cdr_${var}_????0101_????1231.nc ${dir2}/${C}
  echo "${C}"
  rm -rf ${dir2}/flat10_cdr_${var}_????0101_????1231.nc
done
