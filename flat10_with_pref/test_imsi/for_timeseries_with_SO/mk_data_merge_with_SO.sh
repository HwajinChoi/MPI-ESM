#!/bin/bash
pth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO/raw

for var in "dissicnat" "dissic";do
for lat in 40 45 ; do
 for region in "pac" "atl" "ind";do
 A=flat10_cdr_001_${var}_invent_nonSO${lat}_${region}_????.nc
 B=flat10_cdr_001_${var}_invent_nonSO${lat}_${region}_1850-2299.nc

 cdo mergetime ${pth}/${A} ${pth}/${B}  
 echo "${B}"

 done

 C=flat10_cdr_001_${var}_invent_SO${lat}_????.nc
 D=flat10_cdr_001_${var}_invent_SO${lat}_1850-2299.nc

 cdo mergetime ${pth}/${C} ${pth}/${D}
 echo "${D}"

 done
done
