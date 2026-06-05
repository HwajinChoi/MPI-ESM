#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_001/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_budget

for var in "tsco212" "tsco212nat" ;do 
 for year in $(seq 1860 1869); do
  A=flat10_cdr_budget_001_hamocc_data_3d_mm_${year}0101_${year}1231.nc
  B=flat10_cdr_budget_${var}_sosi_terms_${year}0101_${year}1231.nc
  C=flat10_cdr_budget_${var}_sosi_terms_186001_186912.nc
  cdo -s selname,${var}_sosi,${var}_gasex,${var}_dissol,${var}_biol,${var}_aeremin,${var}_anremin,${var}_sulfred ${dir1}/${A} ${dir2}/${B}
  echo "${B}"
 done
  cdo -s mergetime ${dir2}/flat10_cdr_budget_${var}_sosi_terms_????0101_????1231.nc ${dir2}/${C}
  echo "${C}"
  rm -rf ${dir2}/flat10_cdr_budget_${var}_sosi_terms_????0101_????1231.nc
done
