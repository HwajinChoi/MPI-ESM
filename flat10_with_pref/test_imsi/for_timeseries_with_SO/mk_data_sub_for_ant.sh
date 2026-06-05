#!/bin/bash

pth1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO

for lat in 40 45;do
 for region in pac atl ind;do
 A=flat10_cdr_001_dissic_invent_nonSO${lat}_${region}_1850-2299.nc
 B=flat10_cdr_001_dissicnat_invent_nonSO${lat}_${region}_1850-2299.nc
 C=flat10_cdr_001_dissicant_invent_nonSO${lat}_${region}_1850-2299.nc

 cdo sub ${pth1}/${A} ${pth1}/${B} ${pth1}/${C} 
 echo ${C}

 done

 D=flat10_cdr_001_dissic_invent_SO${lat}_1850-2299.nc
 E=flat10_cdr_001_dissicnat_invent_SO${lat}_1850-2299.nc
 F=flat10_cdr_001_dissicant_invent_SO${lat}_1850-2299.nc

 cdo sub ${pth1}/${D} ${pth1}/${E} ${pth1}/${F}  
 echo ${F}

done
