#!/bin/bash
## Bo Liu (Modified by Hwa-Jin)
## To compute basin-integrated inventories
## based on the script from https://code.mpimet.mpg.de/projects/mpiom/wiki/How_to_calculate_the_global_mean_on_the_MPIOM_curvilinear_grid_
#set -x -e

var=dissicnat
FXfile=/home/m/m300595/iScript/mask/GR15/GEO_GR15.nc
mol2pgc=1.2E-14
pth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
pth1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO/

#infile should contain HALO points, for tripolar grids like TP04 or TP6M JB=3 (j=1,2 are the northern halo points)
JB=1
JE=220
IB=2
IE=255
S=test_pictrl_preform_001_spinup

 cdo mul -selvar,areacello ${FXfile} -div -selvar,ddpo ${FXfile} -selvar,ddpo ${FXfile} gridarea.nc
 cdo mul gridarea.nc -selvar,ddpo ${FXfile} gridvolume.nc

 cdo fldsum -selindexbox,$IB,$IE,$JB,$JE gridvolume.nc gridvol_fldsum.nc
 cdo vertsum gridvol_fldsum.nc ${S}_vol_global.nc
 rm gridvol_fldsum.nc

### for Arctic ###
  mask=${pth}/GR15_arc.mask.nc
  cdo mul gridvolume.nc ${mask} gridvolume_arc.nc
  cdo fldsum -selindexbox,$IB,$IE,$JB,$JE gridvolume_arc.nc gridvol_fldsum_arc.nc
  cdo vertsum gridvol_fldsum_arc.nc ${S}_vol_arc.nc
  rm gridvolume_arc.nc gridvol_fldsum_arc.nc

for lat in 40 45 ;do
for basin in atl pac ind ;do
  mask=${pth}/GR15_nonSO${lat}_${basin}.mask.nc
  cdo mul gridvolume.nc ${mask} gridvolume_nonSO${lat}_${basin}.nc
  cdo fldsum -selindexbox,$IB,$IE,$JB,$JE gridvolume_nonSO${lat}_${basin}.nc gridvol_fldsum_nonSO${lat}_${basin}.nc
  cdo vertsum gridvol_fldsum_nonSO${lat}_${basin}.nc ${S}_vol_nonSO${lat}_${basin}.nc
  rm gridvolume_nonSO${lat}_${basin}.nc gridvol_fldsum_nonSO${lat}_${basin}.nc
done
  mask=${pth}/GR15_so${lat}.mask.nc
  cdo mul gridvolume.nc ${mask} gridvolume_SO${lat}.nc
  cdo fldsum -selindexbox,$IB,$IE,$JB,$JE gridvolume_SO${lat}.nc gridvol_fldsum_SO${lat}.nc
  cdo vertsum gridvol_fldsum_SO${lat}.nc ${S}_vol_SO${lat}.nc
  rm gridvolume_SO${lat}.nc gridvol_fldsum_SO${lat}.nc
done

for lat in 40 45 ;do
 for basin in atl pac ind ;do
  cdo div ${pth1}/${S}_${var}_invent_nonSO${lat}_${basin}_8920-8949.nc ${S}_vol_nonSO${lat}_${basin}.nc ${pth1}/${S}_${var}_nonSO${lat}_${basin}_invent_eff_8920-8949.nc 
 done

 cdo div ${pth1}/${S}_${var}_invent_SO${lat}_8920-8949.nc ${S}_vol_SO${lat}.nc ${pth1}/${S}_${var}_invent_SO${lat}_eff_8920-8949.nc
 cdo div ${pth1}/${S}_${var}_invent_nonSO${lat}_arc_8920-8949.nc ${S}_vol_arc.nc ${pth1}/${S}_${var}_nonSO${lat}_arc_invent_eff_8920-8949.nc 
done



