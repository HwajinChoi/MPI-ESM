#!/bin/bash

 dir0=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_pictrl_preform_001_spinup/outdata

## HAMOCC
 # dissic talknat talk phosy dissicnat
  hamocc_vars=( )
 ## MPIOM
 # thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat
  mpiom_vars=( preformed_PO4 )

  # HAMOCC, 3d_mm
 for V in "${hamocc_vars[@]}" ;do
  for year in $(seq 8920 8949); do
   A=test_pictrl_preform_001_spinup_hamocc_data_3d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/hamocc/${A} ${dir0}/${V}_test_pictrl_preform_001_spinup_${year}.nc
   echo "Processed ${V}_test_pictrl_preform_001_spinup_${year}.nc"
  done

  cdo -s -mergetime ${dir0}/${V}_test_pictrl_preform_001_spinup_????.nc ${dir0}/${V}_test_pictrl_preform_001_spinup_8920-8949.nc
  rm -f ${dir0}/${V}_test_pictrl_preform_001_spinup_????.nc

 done

  # MPIOM, 3d_mm

 for V in "${mpiom_vars[@]}" ;do
  for year in $(seq 8920 8949); do
   A=test_pictrl_preform_001_spinup_mpiom_data_3d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/mpiom/${A} ${dir0}/${V}_test_pictrl_preform_001_spinup_${year}.nc
   echo "Processed ${V}_test_pictrl_preform_001_spinup_${year}.nc"
  done

  cdo -s -mergetime ${dir0}/${V}_test_pictrl_preform_001_spinup_????.nc ${dir0}/${V}_test_pictrl_preform_001_spinup_8920-8949.nc
  rm -f ${dir0}/${V}_test_pictrl_preform_001_spinup_????.nc
 done

