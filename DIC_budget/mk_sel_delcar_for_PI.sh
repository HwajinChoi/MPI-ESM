#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_pictrl_preform_001_spinup/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_budget

#for var in "remin_of_det_by_O2_" ;do 
for var in "delcar" "bacterial_activity" ;do 
 for year in $(seq 8800 8919); do
  A=test_pictrl_preform_001_spinup_hamocc_data_3d_mm_${year}0101_${year}1231.nc
  B=test_pictrl_preform_001_spinup_${var}_${year}0101_${year}1231.nc
  C=test_pictrl_preform_001_spinup_${var}_880001_891912.nc
  cdo -s selname,${var} ${dir1}/${A} ${dir2}/${B}
  echo "${B}"
 done
  cdo -s mergetime ${dir2}/test_pictrl_preform_001_spinup_${var}_????0101_????1231.nc ${dir2}/${C}
  echo "${C}"
  rm -rf ${dir2}/test_pictrl_preform_001_spinup_${var}_????0101_????1231.nc
done
