#!/bin/bash

AGE=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/agessc_flat10_cdr_001_185012-229912.nc
FX=/home/m/m300595/iScript/mask/GR15/GEO_GR15.nc

# 3000–6000 m, ddpo
cdo -sellevel,3070,3395,3770,4195,4670,5170,5720 -selvar,ddpo ${FX} ddpo_deep.nc

# 3000–6000 m, age
cdo -sellevel,3070,3395,3770,4195,4670,5170,5720 ${AGE} age_deep.nc

# numerator = sum_z(age * thickness)
cdo vertsum -mul age_deep.nc ddpo_deep.nc age_ddpo_sum.nc

# denominator = sum_z(thickness)
cdo vertsum ddpo_deep.nc ddpo_sum.nc

# thickness-weighted vertical mean
cdo div age_ddpo_sum.nc ddpo_sum.nc age_185012-229912_3000_6000m.nc
