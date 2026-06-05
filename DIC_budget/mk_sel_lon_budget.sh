#!/bin/bash

dir1=/work/uo1451/m301158/MPI-ESM/data/test_budget


for var in "tsco212" "tsco212nat" "tsco212ant" ; do
 A=flat10_cdr_budget_terms_${var}_1850_2299.nc
 B=flat10_cdr_budget_terms_${var}_r192x96_1850_2299.nc
 C1=flat10_cdr_budget_terms_${var}_r192x96_1850_2299_lon_340.nc
 C2=flat10_cdr_budget_terms_${var}_r192x96_1850_2299_lon_190.nc

 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir1}/${A} ${dir1}/${B}
 cdo -s -sellonlatbox,339,341,-90,90 ${dir1}/${B} ${dir1}/${C1}
 cdo -s -sellonlatbox,189,191,-90,90 ${dir1}/${B} ${dir1}/${C2}

 echo ${C1}
 echo ${C2}
 
done
