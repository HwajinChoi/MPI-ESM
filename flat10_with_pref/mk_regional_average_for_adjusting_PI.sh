#!/bin/bash

path1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
#vars=( dissic talknat talk phosy dissicnat thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat )
vars=( dissic dissicnat talknat talk thetao preformed_O2 preformed_DIC preformed_DICnat )
region=( North_Atl South_Atl South_Oce East_Pac )
JB=3
JE=220
IB=1
IE=256

 for V in "${vars[@]}" ;do
  input=${V}_test_pictrl_preform_001_spinup_8920-8949.nc
  output=${V}_test_pictrl_preform_001_spinup_8920-8949_mean.nc
  echo "${input}"
  for R in "${region[@]}" ;do
  cdo -O -f nc fldsum -selindexbox,${IB},${IE},${JB},${JE} -mul ${path1}/PI/${input} -enlarge,${path1}/PI/${input} ${path1}/${R}_wnorm.nc ${path1}/PI/${R}_${output}

  echo "${R}_${output}"
  done
 done

