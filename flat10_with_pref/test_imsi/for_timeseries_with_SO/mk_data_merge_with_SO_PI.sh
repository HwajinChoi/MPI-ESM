#!/bin/bash
pth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO/raw
pth1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO

for var in "dissicnat" "dissic";do
for lat in 40 45 ; do
 for region in "pac" "atl" "ind";do
 A=test_pictrl_preform_001_spinup_${var}_invent_nonSO${lat}_${region}_????.nc
 B=test_pictrl_preform_001_spinup_${var}_invent_nonSO${lat}_${region}_8920-8949.nc

 cdo mergetime ${pth}/${A} ${pth1}/${B}  
 echo "${B}"

 done

 C=test_pictrl_preform_001_spinup_${var}_invent_SO${lat}_????.nc
 D=test_pictrl_preform_001_spinup_${var}_invent_SO${lat}_8920-8949.nc

 cdo mergetime ${pth}/${C} ${pth1}/${D}
 echo "${D}"

 done
done
