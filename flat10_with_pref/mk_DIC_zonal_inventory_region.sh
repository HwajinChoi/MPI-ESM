#!/bin/bash

var=dissicnat
FXfile=/home/m/m300595/iScript/mask/GR15/GEO_GR15.nc
mol2pgc=1.2E-14
pth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
pth1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO/
outpth=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_latdepth

JB=1
JE=220
IB=2
IE=255

for S in "flat10_cdr_001"; do
 for year in $(seq 1850 2299); do
  echo "Processing ${S}, ${year}"
  hamocc=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/${S}/outdata/hamocc/${S}_hamocc_data_3d_ym_${year}0101_${year}1231.nc

   cdo mul -selvar,${var} ${hamocc} gridvolume.nc ${var}_gridmass.nc
 
    for lat in 40 45; do
     for basin in atl pac ind; do
      echo "${basin}, nonSO${lat}"
        mask=${pth}/GR15_nonSO${lat}_${basin}.mask.nc
        cdo mul ${var}_gridmass.nc ${mask} ${var}_gridmass_nonSO${lat}_${basin}.nc
        cdo mulc,${mol2pgc} -zonsum -selindexbox,$IB,$IE,$JB,$JE ${var}_gridmass_nonSO${lat}_${basin}.nc ${outpth}/${S}_${var}_zoninvent_nonSO${lat}_${basin}_${year}.nc
        cdo mul gridvolume.nc ${mask} gridvolume_nonSO${lat}_${basin}.nc



