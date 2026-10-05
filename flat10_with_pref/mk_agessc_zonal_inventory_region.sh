#!/bin/bash

var=agessc # agessc 
pth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
outpth=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/for_latdepth

for S in "flat10_cdr_001"; do

# ONLY OPEN WHEN THE DENOMINATOR IS NEEDED
# for basin in atl pac ind; do
#  echo "${basin}, nonSO40"
#  mask=${pth}/GR15_${basin}.mask.nc
#  # denominator
#  # area × basin mask
#  cdo mul gridarea.nc ${mask} ${outpth}/${var}_area_denominator_${basin}.nc
# done

 for year in $(seq 1850 2299); do
  echo "Processing ${S}, ${year}"
  hamocc=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${S}/outdata/mpiom/${S}_mpiom_data_3d_mm_${year}0101_${year}1231.nc

   cdo mul -selvar,${var} ${hamocc} gridarea.nc ${var}_gridweighted.nc
 
     for basin in atl pac ind; do
      echo "${basin}, nonSO40"
        mask=${pth}/GR15_${basin}.mask.nc
        cdo mul ${var}_gridweighted.nc ${mask} ${outpth}/${var}_numerator_${basin}_${year}.nc
     done
  rm -f ${var}_gridweighted.nc
 done

 cdo mergetime ${outpth}/${var}_numerator_atl_????.nc ${outpth}/${var}_numerator_atl_1850-2299.nc
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${outpth}/${var}_numerator_atl_1850-2299.nc ${outpth}/${var}_numerator_atl_r192x96_1850-2299.nc 
 rm -f ${outpth}/${var}_numerator_atl_????.nc
 cdo mergetime ${outpth}/${var}_numerator_pac_????.nc ${outpth}/${var}_numerator_pac_1850-2299.nc
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${outpth}/${var}_numerator_pac_1850-2299.nc ${outpth}/${var}_numerator_pac_r192x96_1850-2299.nc 
 rm -f ${outpth}/${var}_numerator_pac_????.nc
 cdo mergetime ${outpth}/${var}_numerator_ind_????.nc ${outpth}/${var}_numerator_ind_1850-2299.nc
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${outpth}/${var}_numerator_ind_1850-2299.nc ${outpth}/${var}_numerator_ind_r192x96_1850-2299.nc 
 rm -f ${outpth}/${var}_numerator_ind_????.nc

done




