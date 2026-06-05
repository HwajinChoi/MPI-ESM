#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_002/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_budget

#for var in "tsco212" "tsco212nat" ;do 
for var in "tsco212nat" ;do 
 for year in $(seq 1850 2299); do
 A=flat10_cdr_budget_002_hamocc_data_3d_mm_${year}0101_${year}1231.nc
 B=flat10_cdr_sosi_budget_terms_${var}_${year}.nc
 C=flat10_cdr_sosi_budget_terms_${var}_r192x96_${year}.nc
 D=flat10_cdr_sosi_budget_terms_${var}_r192x96_1850-2299.nc
 E1=flat10_cdr_sosi_budget_terms_${var}_r192x96_1850_2299_lon_340.nc
 E2=flat10_cdr_sosi_budget_terms_${var}_r192x96_1850_2299_lon_190.nc

 cdo -s -yearmean -selname,${var}_aeremin,${var}_anremin,${var}_sulfred,${var}_biol,${var}_dissol,${var}_gasex,${var}_sosi ${dir1}/${A} ${dir2}/${B}
 echo "${B}"
 
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir2}/${B} ${dir2}/${C}
 rm -f ${dir2}/${B}
 echo "${C}"

 done
 
 cdo -s -mergetime ${dir2}/flat10_cdr_sosi_budget_terms_${var}_r192x96_????.nc ${dir2}/${D}
 rm -f ${dir2}/flat10_cdr_sosi_budget_terms_${var}_r192x96_????.nc

 cdo -s -sellonlatbox,339,341,-90,90 ${dir2}/${D} ${dir2}/${E1}
 cdo -s -sellonlatbox,189,191,-90,90 ${dir2}/${D} ${dir2}/${E2}

 echo ${E1}
 echo ${E2}

done 
