#!/bin/bash

path1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
dir2=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi

#vars=( dissic talknat talk phosy dissicnat thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat )
vars=( dissic dissicnat preformed_PO4 preformed_DIC preformed_DICnat )

region=( atl pac ind arc ) 
JB=3
JE=220
IB=1
IE=256

 for V in "${vars[@]}" ;do
  input=${V}_test_pictrl_preform_001_spinup_8920-8949.nc
  echo "${input}"
  for R in "${region[@]}" ;do
  cdo -O -f nc fldsum -selindexbox,${IB},${IE},${JB},${JE} -mul ${path1}/PI/${input} -enlarge,${path1}/PI/${input} ${dir2}/GR15_${R}.mask_wnorm.nc ${path1}/PI/${R}_mean_${input}
  echo "${R}_mean_${input}"
  done
 done

