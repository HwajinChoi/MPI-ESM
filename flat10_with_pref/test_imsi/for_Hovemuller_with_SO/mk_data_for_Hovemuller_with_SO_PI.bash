#!/bin/bash
#------------------------------------------------------------
#cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul /work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/dissic_test_pictrl_preform_001_spinup_8920-8949.nc -enlarge,/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/dissic_test_pictrl_preform_001_spinup_8920-8949.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_wnorm.nc /work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/ocean_mean_dissic_test_pictrl_preform_001_spinup_8920-8949.nc
#------------------------------------------------------------

path1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI
path2=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
path3=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_Hovemuller_with_SO


for lat in "40" "45" ;do
 for Basin in "pac" "ind" "atl";do
#  for Var in "dissic" "dissicnat";do
  for Var in "preformed_DIC" ;do

  A=GR15_nonSO${lat}_${Basin}.mask_wnorm.nc
  B=${Basin}_mean_${Var}_nonSO${lat}_test_pictrl_preform_001_spinup_8920-8949.nc
  cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul ${path1}/${Var}_test_pictrl_preform_001_spinup_8920-8949.nc -enlarge,${path1}/${Var}_test_pictrl_preform_001_spinup_8920-8949.nc ${path2}/${A} ${path3}/${B}

  done

 done
done


for lat in "40" "45" ;do
# for Var in "dissic" "dissicnat";do
  for Var in "preformed_DIC" ;do
 C=GR15_so${lat}.mask_wnorm.nc
 D=SO${lat}_mean_${Var}_test_pictrl_preform_001_spinup_8920-8949.nc
 cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul ${path1}/${Var}_test_pictrl_preform_001_spinup_8920-8949.nc -enlarge,${path1}/${Var}_test_pictrl_preform_001_spinup_8920-8949.nc ${path2}/${C} ${path3}/${D}
 done
done
