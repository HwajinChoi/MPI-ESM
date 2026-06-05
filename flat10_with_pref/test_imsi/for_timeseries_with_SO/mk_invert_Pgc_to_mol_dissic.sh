#!/bin/bash
mol2pgc=1.2e-14

for lat in 40 45;do
 for basin in arc atl pac ind ;do
cdo -O divc,${mol2pgc} flat10_cdr_001_dissic_nonSO${lat}_${basin}_invent_eff_1850-2299.nc flat10_cdr_001_dissic_nonSO${lat}_${basin}_inventMol_eff_1850-2299.nc
cdo -O divc,${mol2pgc} test_pictrl_preform_001_spinup_dissic_nonSO${lat}_${basin}_invent_eff_8920-8949.nc test_pictrl_preform_001_spinup_dissic_nonSO${lat}_${basin}_inventMol_eff_8920-8949.nc

 done
 cdo -O divc,${mol2pgc} flat10_cdr_001_dissic_SO${lat}_invent_eff_1850-2299.nc flat10_cdr_001_dissic_SO${lat}_inventMol_eff_1850-2299.nc
 cdo -O divc,${mol2pgc} test_pictrl_preform_001_spinup_dissic_SO${lat}_invent_eff_8920-8949.nc test_pictrl_preform_001_spinup_dissic_SO${lat}_inventMol_eff_8920-8949.nc

done
