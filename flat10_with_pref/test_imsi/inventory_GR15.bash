#!/bin/bash
## Bo Liu
## To compute basin-integrated inventories
## based on the script from https://code.mpimet.mpg.de/projects/mpiom/wiki/How_to_calculate_the_global_mean_on_the_MPIOM_curvilinear_grid_
set -x -e

var=dissic
hamocc=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_zec_001/outdata/hamocc/flat10_zec_001_hamocc_data_3d_ym_18500101_18501231.nc
FXfile=GEO_GR15.nc

mol2pgc=1.2E-14

mask=./GR15_${basin}.mask.nc

#infile should contain HALO points, for tripolar grids like TP04 or TP6M JB=3 (j=1,2 are the northern halo points)
JB=1
JE=220
IB=2
IE=255

cdo mul -selvar,areacello ${FXfile} -div -selvar,ddpo ${FXfile} -selvar,ddpo ${FXfile} gridarea.nc
cdo mul gridarea.nc -selvar,ddpo ${FXfile} gridvolume.nc
cdo mul -selvar,${var} ${hamocc} gridvolume.nc ${var}_gridmass.nc
rm gridvolume.nc gridarea.nc

## global inventory
cdo fldsum -selindexbox,$IB,$IE,$JB,$JE ${var}_gridmass.nc ${var}_gridmass_fldsum.nc
cdo mulc,${mol2pgc} -vertsum ${var}_gridmass_fldsum.nc ${var}_invent_global.nc
rm ${var}_gridmass_fldsum.nc

## basins' inventory
for basin in atl pac ind arc
do
	mask=./GR15_${basin}.mask.nc
	cdo mul ${var}_gridmass.nc ${mask} ${var}_gridmass_${basin}.nc

	cdo fldsum -selindexbox,$IB,$IE,$JB,$JE ${var}_gridmass_${basin}.nc ${var}_gridmass_fldsum_${basin}.nc
	cdo mulc,${mol2pgc} -vertsum ${var}_gridmass_fldsum_${basin}.nc ${var}_invent_${basin}.nc
	rm ${var}_gridmass_fldsum_${basin}.nc
done
rm dissic_gridmass*.nc

cdo infov ${var}_invent_global.nc
cdo infov -add -add -add ${var}_invent_atl.nc ${var}_invent_pac.nc ${var}_invent_ind.nc ${var}_invent_arc.nc
for basin in atl pac ind arc
do
	cdo infov ${var}_invent_${basin}.nc
done

