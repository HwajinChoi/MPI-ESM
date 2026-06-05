#!/bin/bash
#------------------------------------------------------------
#cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul /work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/dissic_flat10_1850-2299.nc -enlarge,/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/dissic_flat10_1850-2299.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_wnorm.nc /work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/ocean_mean_dissic_flat10_1850-2299.nc
#------------------------------------------------------------

path1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
path2=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
path3=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_Hovemuller_with_SO


for lat in "40" "45" ;do
 for Basin in "pac" "ind" "atl";do
#  for Var in "dissic" "dissicnat";do
  for Var in "preformed_DIC" ;do

  A=GR15_nonSO${lat}_${Basin}.mask_wnorm.nc
  B=${Basin}_mean_${Var}_nonSO${lat}_flat10_cdr_1850-2299.nc
  cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul ${path1}/${Var}_flat10_cdr_1850-2299.nc -enlarge,${path1}/${Var}_flat10_cdr_1850-2299.nc ${path2}/${A} ${path3}/${B}

  done

# cdo sub ${path3}/${Basin}_mean_dissic_nonSO${lat}_flat10_cdr_1850-2299.nc ${path3}/${Basin}_mean_dissicnat_nonSO${lat}_flat10_cdr_1850-2299.nc ${path3}/${Basin}_mean_dissicant_nonSO${lat}_flat10_cdr_1850-2299.nc
 cdo sub ${path3}/${Basin}_mean_dissic_nonSO${lat}_flat10_cdr_1850-2299.nc ${path3}/${Basin}_mean_preformed_DIC_nonSO${lat}_flat10_cdr_1850-2299.nc ${path3}/${Basin}_mean_regenerated_DIC_nonSO${lat}_flat10_cdr_1850-2299.nc

 done
done


for lat in "40" "45" ;do
# for Var in "dissic" "dissicnat";do
 for Var in "preformed_DIC" ;do
 C=GR15_so${lat}.mask_wnorm.nc
 D=SO${lat}_mean_${Var}_flat10_cdr_1850-2299.nc
 cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul ${path1}/${Var}_flat10_cdr_1850-2299.nc -enlarge,${path1}/${Var}_flat10_cdr_1850-2299.nc ${path2}/${C} ${path3}/${D}
 done
 cdo sub ${path3}/SO${lat}_mean_dissic_flat10_cdr_1850-2299.nc ${path3}/SO${lat}_mean_preformed_DIC_flat10_cdr_1850-2299.nc ${path3}/SO${lat}_mean_regenerated_DIC_flat10_cdr_1850-2299.nc 
done
