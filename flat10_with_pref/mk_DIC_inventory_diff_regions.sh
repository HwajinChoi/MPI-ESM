#!/bin/bash
## Bo Liu (Modified by Hwa-Jin)
## To compute basin-integrated inventories
## based on the script from https://code.mpimet.mpg.de/projects/mpiom/wiki/How_to_calculate_the_global_mean_on_the_MPIOM_curvilinear_grid_
#set -x -e

var=dissicnat
FXfile=/home/m/m300595/iScript/mask/GR15/GEO_GR15.nc
mol2pgc=1.2E-14

#infile should contain HALO points, for tripolar grids like TP04 or TP6M JB=3 (j=1,2 are the northern halo points)
JB=1
JE=220
IB=2
IE=255

 cdo mul -selvar,areacello ${FXfile} -div -selvar,ddpo ${FXfile} -selvar,ddpo ${FXfile} gridarea.nc
 cdo mul gridarea.nc -selvar,ddpo ${FXfile} gridvolume.nc

#for S in "flat10_002" "flat10_zec_001" "flat10_cdr_001";do
for S in "flat10_002" ;do
 for year in $(seq 1850 2299); do

 hamocc=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${S}/outdata/hamocc/${S}_hamocc_data_3d_ym_${year}0101_${year}1231.nc

 cdo mul -selvar,${var} ${hamocc} gridvolume.nc ${var}_gridmass.nc
 cdo fldsum -selindexbox,$IB,$IE,$JB,$JE ${var}_gridmass.nc ${var}_gridmass_fldsum.nc

 ## global inventory
 cdo mulc,${mol2pgc} -vertsum ${var}_gridmass_fldsum.nc ${S}_${var}_invent_global_${year}.nc
 rm  ${var}_gridmass_fldsum.nc

## basins' inventory
  for basin in atl pac ind arc ;do
        mask=/home/m/m300595/iScript/mask/GR15/GR15_${basin}.mask.nc
        cdo mul ${var}_gridmass.nc ${mask} ${var}_gridmass_${basin}.nc
        cdo fldsum -selindexbox,$IB,$IE,$JB,$JE ${var}_gridmass_${basin}.nc ${var}_gridmass_fldsum_${basin}.nc
        cdo mulc,${mol2pgc} -vertsum ${var}_gridmass_fldsum_${basin}.nc ${S}_${var}_invent_${basin}_${year}.nc
        rm ${var}_gridmass_fldsum_${basin}.nc
  done
  rm dissic_gridmass*.nc

  cdo infov ${S}_${var}_invent_global_${year}.nc
  cdo infov -add -add -add ${S}_${var}_invent_atl_${year}.nc ${S}_${var}_invent_pac_${year}.nc ${S}_${var}_invent_ind_${year}.nc ${S}_${var}_invent_arc_${year}.nc

  for basin in atl pac ind arc ;do
         cdo infov ${S}_${var}_invent_${basin}_${year}.nc
  done
 done
done
 rm gridvolume.nc gridarea.nc
