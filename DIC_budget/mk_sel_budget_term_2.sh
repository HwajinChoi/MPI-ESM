#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test/experiments/flat10_cdr_budget_002/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_budget

#for var in "tsco212" "tsco212nat" ;do 
for var in "tsco212nat" ;do 
 for year in $(seq 1850 2299); do
  A=flat10_cdr_budget_002_hamocc_data_3d_mm_${year}0101_${year}1231.nc
  B=flat10_cdr_sosi_budget_terms_${var}_${year}0101_${year}1231.nc
  B1=flat10_cdr_sosi_budget_terms_${var}_${year}.nc

  C=flat10_cdr_sosi_budget_terms_${var}_mul_dz_1850_2299.nc
  D=flat10_cdr_sosi_budget_terms_${var}_mul_dz_0-1000m_1850_2299.nc
  E=flat10_cdr_sosi_budget_terms_${var}_mul_dz_0-1000m_r192x96_1850_2299.nc

  D1=flat10_cdr_sosi_budget_terms_${var}_mul_dz_1000-3000m_1850_2299.nc
  E1=flat10_cdr_sosi_budget_terms_${var}_mul_dz_1000-3000m_r192x96_1850_2299.nc

  D2=flat10_cdr_sosi_budget_terms_${var}_mul_dz_3000-6000m_1850_2299.nc
  E2=flat10_cdr_sosi_budget_terms_${var}_mul_dz_3000-6000m_r192x96_1850_2299.nc

  cdo -s selname,${var}_aeremin,${var}_anremin,${var}_sulfred,${var}_biol,${var}_dissol,${var}_gasex,${var}_sosi ${dir1}/${A} ${dir2}/${B}
  echo "${B}"
  cdo -s -yearmean -mul ${dir2}/ddpo_org.nc ${dir2}/${B} ${dir2}/${B1}
  echo "${B1}"
 done

  cdo -s mergetime ${dir2}/flat10_cdr_sosi_budget_terms_${var}_????.nc ${dir2}/${C}
  echo "${C}"
  rm -rf ${dir2}/flat10_cdr_sosi_budget_terms_${var}_????.nc ${dir2}/flat10_cdr_sosi_budget_terms_${var}_${year}0101_${year}1231.nc
  cdo vertsum -sellevel,6,17,27,37,47,57,68.5,82.5,100,122.5,150,182.5,220,262.5,310,362.5,420,485,560,645,740,845,960 ${dir2}/${C} ${dir2}/${D}
  cdo vertsum -sellevel,1085,1220,1365,1525,1700,1885,2080,2290,2525,2785 ${dir2}/${C} ${dir2}/${D1}
  cdo vertsum -sellevel,3070,3395,3770,4195,4670,5170,5720 ${dir2}/${C} ${dir2}/${D2}
  echo "${D}"
  echo "${D1}"
  echo "${D2}"
  cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir2}/${D} ${dir2}/${E}
  cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir2}/${D1} ${dir2}/${E1}
  cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir2}/${D2} ${dir2}/${E2}
  echo "${E}"
  echo "${E1}"
  echo "${E2}"

done
