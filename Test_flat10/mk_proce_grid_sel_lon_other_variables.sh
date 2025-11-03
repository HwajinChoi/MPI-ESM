#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw

for s in "flat10" "flat10_zec"  "flat10_cdr" ; do
 for lon in 340 190 70 ; do
  L1=${dir0}/test_${s}_001_cfcs_ideal_r192x96_thetao_1850-2149.nc
  L2=${dir0}/test_${s}_001_cfcs_ideal_r192x96_so_1850-2149.nc

  R1=${dir0}/test_${s}_001_cfcs_ideal_r192x96_thetao_1850-2149_lon_${lon}.nc
  R2=${dir0}/test_${s}_001_cfcs_ideal_r192x96_so_1850-2149_lon_${lon}.nc

   west=$(($lon - 1))
   east=$(($lon + 1))
  cdo -s -sellonlatbox,${west},${east},-90,90 ${L1} ${R1}
  echo "Processed ${R1}"
  cdo -s -sellonlatbox,${west},${east},-90,90 ${L2} ${R2}
  echo "Processed ${R2}"
 done
done

