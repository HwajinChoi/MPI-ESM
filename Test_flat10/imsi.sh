#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/data/test_flat10

 R_tot=${dir0}/test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231.nc
 R_nat=${dir0}/test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicnat_19710101_20001231.nc
 R_ant=${dir0}/test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicant_19710101_20001231.nc

for lon in 340 190 70 ; do
  L_tot=${dir0}/test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231_lon_${lon}.nc
  L_nat=${dir0}/test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicnat_19710101_20001231_lon_${lon}.nc
  L_ant=${dir0}/test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicant_19710101_20001231_lon_${lon}.nc
   west=$(($lon - 1))
   east=$(($lon + 1))
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R_tot} ${L_tot}
  echo "Processed ${L_tot}"
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R_nat} ${L_nat}
  echo "Processed ${L_nat}"
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R_ant} ${L_ant}
  echo "Processed ${L_ant}"
 done

