#!/bin/bash

dir1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
dir2=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi

#INFILE should contain HALO points, for tripolar grids like TP04 or TP6M JB=3 (j=1,2 are the northern halo points)
JB=3
JE=220
IB=1
IE=256

for basin in atl pac ind arc ;do
 cdo -O mul ${dir1}/globalweight.nc ${dir2}/GR15_${basin}.mask.nc ${dir2}/GR15_${basin}.mask_raw.nc
 cdo -O fldsum -selindexbox,${IB},${IE},${JB},${JE} -enlarge,${dir1}/dissic_flat10_cdr_1850-2299.nc ${dir2}/GR15_${basin}.mask_raw.nc ${dir2}/GR15_${basin}.mask_wsum.nc 
 cdo -O setctomiss,0 ${dir2}/GR15_${basin}.mask_wsum.nc ${dir2}/GR15_${basin}.mask_wsum_miss.nc 
 cdo -O div ${dir2}/GR15_${basin}.mask_raw.nc -enlarge,${dir2}/GR15_${basin}.mask_raw.nc ${dir2}/GR15_${basin}.mask_wsum_miss.nc ${dir2}/GR15_${basin}.mask_wnorm.nc 
# cdo -O -f nc fldsum -selindexbox,${IB},${IE},${JB},${JE} -mul dissic_flat10_1850-2299.nc -enlarge,dissic_flat10_1850-2299.nc North_Atl_wnorm.nc North_Atl_dissic_flat10_1850-2299_mean.nc

# vars=( dissic talknat talk phosy dissicnat thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat )
 vars=( dissic dissicnat preformed_PO4 preformed_DIC preformed_DICnat )
 for s in "flat10" "flat10_cdr" "flat10_zec";do
  for V in "${vars[@]}" ;do
   input=${V}_${s}_1850-2299.nc
   cdo -O -f nc fldsum -selindexbox,${IB},${IE},${JB},${JE} -mul ${dir1}/${input} -enlarge,"${dir1}/${input}" ${dir2}/GR15_${basin}.mask_wnorm.nc ${dir1}/${basin}_mean_${input}
   echo "${basin}_${input}"
  done
 done
done
