#!/bin/bash
var=dissicnat
dir1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref

#for S in "flat10_002" "flat10_zec_001" "flat10_cdr_001";do
for S in "flat10_002";do
#for S in "test_pictrl_preform_001_spinup";do
 for basin in global atl pac ind arc ;do
# for basin in global ;do
 cdo mergetime ${dir1}/${S}_${var}_invent_${basin}_????.nc ${dir1}/${S}_${var}_invent_${basin}_1850-2299.nc
# cdo mergetime ${dir1}/${S}_${var}_invent_${basin}_????.nc ${dir1}/${S}_${var}_invent_${basin}_8920-8949.nc
 rm -f ${dir1}/${S}_${var}_invent_${basin}_????.nc
 done 
done
