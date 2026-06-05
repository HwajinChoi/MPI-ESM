#!/bin/bash

for s in "flat10" "flat10_zec" "flat10_cdr" ;do
 if [ $s = "flat10" ]; then
  S=002
 else
  S=001
 fi

 dir0=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${s}_${S}/outdata

## HAMOCC ; 3d_mm
 # dissic talknat talk phosy dissicnat
  hamocc_vars=( )

## HAMOCC ; 2d_mm
 # intpp
  hamocc_vars2=( )

 ## MPIOM
 # thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat
  mpiom_vars=( wo )


  # HAMOCC, 3d_mm
 for V in "${hamocc_vars[@]}" ;do
  for year in $(seq 1850 2023); do
   A=${s}_${S}_hamocc_data_3d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/hamocc/${A} ${dir0}/${V}_${s}_${year}.nc
   echo "Processed ${V}_${s}_${year}.nc"
  done

  cdo -s -mergetime ${dir0}/${V}_${s}_????.nc ${dir0}/${V}_${s}_1850-2299.nc
  rm -f ${dir0}/${V}_${s}_????.nc

  done

  # HAMOCC, 2d_mm
 for V in "${hamocc_vars2[@]}" ;do
  for year in $(seq 1850 2299); do
   A=${s}_${S}_hamocc_data_2d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/hamocc/${A} ${dir0}/${V}_${s}_${year}.nc
   echo "Processed ${V}_${s}_${year}.nc"
  done

  cdo -s -mergetime ${dir0}/${V}_${s}_????.nc ${dir0}/${V}_${s}_1850-2299.nc
  rm -f ${dir0}/${V}_${s}_????.nc

  done

  # MPIOM, 3d_mm

 for V in "${mpiom_vars[@]}" ;do
  for year in $(seq 1850 2299); do
   A=${s}_${S}_mpiom_data_3d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/mpiom/${A} ${dir0}/${V}_${s}_${year}.nc
   echo "Processed ${V}_${s}_${year}.nc"
  done

  cdo -s -mergetime ${dir0}/${V}_${s}_????.nc ${dir0}/${V}_${s}_1850-2299.nc
  rm -f ${dir0}/${V}_${s}_????.nc

 done
 done
