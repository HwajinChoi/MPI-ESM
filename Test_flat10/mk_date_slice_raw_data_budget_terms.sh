#!/bin/bash

dir1=/work/uo1451/m301158/MPI-ESM/data/budget_slice/raw
dir2=/work/uo1451/m301158/MPI-ESM/data/budget_slice
V=tsco212nat

A=flat10_cdr_budget_terms_${V}_1850_2299_ano_timcumsum.nc

for i in $(seq 0 44);do

 S1=$((1850+10*i))
 S2=$((1859+10*i))
 B=flat10_cdr_budget_terms_${V}_${S1}_${S2}_ano_timcumsum.nc
 C=flat10_cdr_budget_terms_${V}_${S1}_${S2}_ano_timcumsum_avg.nc

 cdo -L -s -selyear,${S1}/${S2} ${dir1}/${A} ${dir1}/${B}
 cdo -L -s timmean ${dir1}/${B} ${dir2}/${C}
 echo "${C}"
 rm -f ${dir1}/${B}

done
