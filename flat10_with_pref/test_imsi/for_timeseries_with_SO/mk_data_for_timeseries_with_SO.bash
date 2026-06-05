#!/bin/bash
#-----------------------------------------------------------------
#cdo mul dissicnat_gridmass.nc /home/m/m300595/iScript/mask/GR15/GR15_atl.mask.nc dissicnat_gridmass_atl.nc

#-----------------------------------------------------------------

path1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/DICs_invent
path2=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
paht3=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO

for lat in "40" "45" ;do
 for basin in "pac" "ind" "arc";do

 A=GR15_nonSO${lat}_${basin}.mask.nc

 cdo mul ${path1}/dissicnat_gridmass.nc ${path2}/${A} ${path3}/dissicnat_gridmass_${basin}_nonSO${lat}.nc

 done
done
