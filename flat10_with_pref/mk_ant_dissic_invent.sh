#!/bin/bash
dir1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref

for S in "flat10_002" "flat10_zec_001" "flat10_cdr_001";do
 for basin in global atl pac ind arc ;do
 A=${dir1}/${S}_dissic_invent_${basin}_1850-2299.nc
 B=${dir1}/${S}_dissicnat_invent_${basin}_1850-2299.nc
 C=${dir1}/${S}_dissicant_invent_${basin}_1850-2299.nc
 cdo sub ${A} ${B} ${C} 
 done 
done
