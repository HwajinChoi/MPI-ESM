#!/bin/bash
#---------------------------------------------------------------------------
#cdo mul -selvar,areacello /work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc -div -selvar,ddpo /work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc -selvar,ddpo /work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc gridarea.nc

#cdo -f nc div gridarea.nc -enlarge,gridarea.nc globalarea.nc globalweight.nc

#cdo -O mul /work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/globalweight.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_raw.nc

#cdo -O div /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_raw.nc -enlarge,/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_raw.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_wsum_miss.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_ocean.mask_wnorm.nc
#---------------------------------------------------------------------------
# How to make GR15_*.mask_wsum_miss.nc
#---------------------------------------------------------------------------
#cdo mul -selvar,areacello /work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc -div -selvar,ddpo /work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc -selvar,ddpo /work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc gridarea.nc

#cdo -f nc div gridarea.nc -enlarge,gridarea.nc globalarea.nc globalweight.nc

#cdo -O mul /work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/globalweight.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_pac.mask.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_pac.mask_raw.nc

#cdo -O fldsum -selindexbox,1,256,3,220 -enlarge,/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/dissic_flat10_cdr_1850-2299.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_pac.mask_raw.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_pac.mask_wsum.nc

#cdo -O setctomiss,0 /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_pac.mask_wsum.nc /work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/GR15_pac.mask_wsum_miss.nc
#---------------------------------------------------------------------------
GW=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/globalweight.nc
path1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
file1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/dissic_flat10_cdr_1850-2299.nc

for lat in "40" "45" ;do
 for basin in "pac" "ind" "atl";do

  cdo -O mul ${GW} ${path1}/GR15_nonSO${lat}_${basin}.mask.nc ${path1}/GR15_nonSO${lat}_${basin}.mask_raw.nc
 
  cdo -O fldsum -selindexbox,1,256,3,220 -enlarge,${file1} ${path1}/GR15_nonSO${lat}_${basin}.mask_raw.nc ${path1}/GR15_nonSO${lat}_${basin}.mask_wsum.nc

  cdo -O setctomiss,0 ${path1}/GR15_nonSO${lat}_${basin}.mask_wsum.nc ${path1}/GR15_nonSO${lat}_${basin}.mask_wsum_miss.nc
  
  cdo -O div ${path1}/GR15_nonSO${lat}_${basin}.mask_raw.nc -enlarge,${path1}/GR15_nonSO${lat}_${basin}.mask_raw.nc ${path1}/GR15_nonSO${lat}_${basin}.mask_wsum_miss.nc ${path1}/GR15_nonSO${lat}_${basin}.mask_wnorm.nc

 done

 cdo -O mul ${GW} ${path1}/GR15_so${lat}.mask.nc ${path1}/GR15_so${lat}.mask_raw.nc
 cdo -O fldsum -selindexbox,1,256,3,220 -enlarge,${file1} ${path1}/GR15_so${lat}.mask_raw.nc ${path1}/GR15_so${lat}.mask_wsum.nc
 cdo -O setctomiss,0 ${path1}/GR15_so${lat}.mask_wsum.nc ${path1}/GR15_so${lat}.mask_wsum_miss.nc
 cdo -O div ${path1}/GR15_so${lat}.mask_raw.nc -enlarge,${path1}/GR15_so${lat}.mask_raw.nc ${path1}/GR15_so${lat}.mask_wsum_miss.nc ${path1}/GR15_so${lat}.mask_wnorm.nc
done


