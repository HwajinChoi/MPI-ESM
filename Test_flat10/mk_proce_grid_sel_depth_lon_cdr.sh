#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/data/test_flat10

#for s in "flat10" "flat10_zec"  "flat10_cdr" ; do
for s in "flat10_cdr" ; do

 in_tot=${dir0}/test_${s}_001_cfcs_ideal_dissic_18500101_21491231.nc
 in_nat=${dir0}/test_${s}_001_cfcs_ideal_dissicnat_18500101_21491231.nc
 in_ant=${dir0}/test_${s}_001_cfcs_ideal_dissicant_18500101_21491231.nc
 
 cdo -s -sub ${in_tot} ${in_nat} ${in_ant}
 echo "Processed ${in_ant}"

 ### 192 x 96 grid
 R_tot=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissic_18500101_21491231.nc
 R_nat=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231.nc
 R_ant=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissicant_18500101_21491231.nc

 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${in_tot} ${R_tot} 
 echo "Processed ${R_tot}"
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${in_nat} ${R_nat} 
 echo "Processed ${R_nat}"
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${in_ant} ${R_ant} 
 echo "Processed ${R_ant}"

 ### Selection depth
 for d in "6" "182.5" ; do

 D_tot=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissic_dep${d}_18500101_21491231.nc
 D_nat=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissicnat_dep${d}_18500101_21491231.nc
 D_ant=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissicant_dep${d}_18500101_21491231.nc
 
 cdo -s -sellevel,${d} ${R_tot}  ${D_tot}
 echo "Processed ${D_tot}"
 cdo -s -sellevel,${d} ${R_nat}  ${D_nat}
 echo "Processed ${D_nat}"
 cdo -s -sellevel,${d} ${R_ant}  ${D_ant}
 echo "Processed ${D_ant}"
 done

 # Selection longitudes
 for lon in 340 190 70 ; do
  L_tot=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_${lon}.nc
  L_nat=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_${lon}.nc
  L_ant=${dir0}/test_${s}_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_${lon}.nc
   west=$(($lon - 1))
   east=$(($lon + 1))
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R_tot} ${L_tot}
  echo "Processed ${L_tot}"
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R_nat} ${L_nat}
  echo "Processed ${L_nat}"
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R_ant} ${L_ant}
  echo "Processed ${L_ant}"
 done

done
