#!/bin/bash
mol2pgc=1.2e-14

for lat in 40 45;do
 for basin in arc atl pac ind ;do
cdo -O divc,${mol2pgc} flat10_cdr_001_dissicnat_nonSO${lat}_${basin}_invent_eff_1850-2299.nc flat10_cdr_001_dissicnat_nonSO${lat}_${basin}_inventMol_eff_1850-2299.nc

 done
 cdo -O divc,${mol2pgc} flat10_cdr_001_dissicnat_SO${lat}_invent_eff_1850-2299.nc flat10_cdr_001_dissicnat_SO${lat}_inventMol_eff_1850-2299.nc

done
