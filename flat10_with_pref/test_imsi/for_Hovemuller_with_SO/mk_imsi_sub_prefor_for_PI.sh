#!/bin/bash

path3=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_Hovemuller_with_SO

for lat in "40" "45" ;do
 for basin in "atl" "ind" "pac" ;do
  A=${basin}_mean_dissic_nonSO${lat}_test_pictrl_preform_001_spinup_8920-8949.nc 
  B=${basin}_mean_preformed_DIC_nonSO${lat}_test_pictrl_preform_001_spinup_8920-8949.nc
  C=${basin}_mean_regenerated_DIC_nonSO${lat}_test_pictrl_preform_001_spinup_8920-8949.nc

  cdo sub ${path3}/${A} ${path3}/${B} ${path3}/${C} 

 done
done

for lat in "40" "45" ;do
 A=SO${lat}_mean_dissic_test_pictrl_preform_001_spinup_8920-8949.nc
 B=SO${lat}_mean_preformed_DIC_test_pictrl_preform_001_spinup_8920-8949.nc
 C=SO${lat}_mean_regenerated_DIC_test_pictrl_preform_001_spinup_8920-8949.nc
 
 cdo sub ${path3}/${A} ${path3}/${B} ${path3}/${C} 

done
