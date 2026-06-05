#!/bin/bash

for s in "flat10" "flat10_cdr" "flat10_zec";do
 if [ $s = "flat10" ]; then 
  S=002
 else
  S=001
 fi

 dir0=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${s}_${S}/outdata

 ## HAMOCC
 # dissic talknat talk phosy dissicnat
  hamocc_vars=( )
 ## MPIOM
 # thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat
  mpiom_vars=( siconc )

  # HAMOCC, 3d_mm
 for V in "${hamocc_vars[@]}" ;do
  for year in $(seq 1850 2299); do
   A=${s}_${S}_hamocc_data_3d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/hamocc/${A} ${dir0}/${V}_${s}_${year}.nc
   cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir0}/${V}_${s}_${year}.nc ${dir0}/${V}_${s}_r192x96_${year}.nc
   echo "Processed ${V}_${s}_r192x96_${year}.nc"
   rm -f ${dir0}/${V}_${s}_${year}.nc
  done

#  cdo -s -mergetime ${dir0}/${V}_${s}_r192x96_????.nc ${dir0}/${V}_${s}_r192x96_1850-2299.nc
#  rm -f ${dir0}/${V}_${s}_r192x96_????.nc
#
#  for lon in 340 190 70 ; do
#    R=${dir0}/${V}_${s}_r192x96_1850-2299.nc
#    L=${dir0}/${V}_${s}_r192x96_1850-2299_lon_${lon}.nc
#    west=$(($lon - 1))
#    east=$(($lon + 1))
#   cdo -s -sellonlatbox,${west},${east},-90,90 ${R} ${L}
#   echo "Processed ${V}_${s}_r192x96_1850-2299_lon_${lon}.nc"
#  done
 done

  # MPIOM, 2d_mm

 for V in "${mpiom_vars[@]}" ;do
#  for year in $(seq 1850 2299); do
#   A=${s}_${S}_mpiom_data_2d_mm_${year}0101_${year}1231.nc
#   cdo -s -selname,${V} ${dir1}/mpiom/${A} ${dir0}/${V}_${s}_${year}.nc
#   cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir0}/${V}_${s}_${year}.nc ${dir0}/${V}_${s}_r192x96_${year}.nc
#   echo "Processed ${V}_${s}_r192x96_${year}.nc"
#   rm -f ${dir0}/${V}_${s}_${year}.nc
#  done
#
#  cdo -s -mergetime ${dir0}/${V}_${s}_r192x96_????.nc ${dir0}/${V}_${s}_r192x96_1850-2299.nc
#  rm -f ${dir0}/${V}_${s}_r192x96_????.nc
#

  for year in $(seq 1850 2299); do
   A=${s}_${S}_mpiom_data_2d_mm_${year}0101_${year}1231.nc
   cdo -s -selname,${V} ${dir1}/mpiom/${A} ${dir0}/${V}_${s}_${year}.nc
   echo "Processed ${V}_${s}_${year}.nc"
  done
  cdo -s -mergetime ${dir0}/${V}_${s}_????.nc ${dir0}/${V}_${s}_1850-2299.nc
  rm -f ${dir0}/${V}_${s}_????.nc
#  for lon in 340 190 70 ; do
#    R=${dir0}/${V}_${s}_r192x96_1850-2299.nc
#    L=${dir0}/${V}_${s}_r192x96_1850-2299_lon_${lon}.nc
#    west=$(($lon - 1))
#    east=$(($lon + 1))
#    cdo -s -sellonlatbox,${west},${east},-90,90 ${R} ${L}
#   echo "Processed ${V}_${s}_r192x96_1850-2299_lon_${lon}.nc"
#  done
 done
done
