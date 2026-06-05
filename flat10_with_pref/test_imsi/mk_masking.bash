#!/bin/bash

GEO=GEO_GR15.nc
dir=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref

cdo -s gec,40 -selvar,alat ${GEO} GEO_gt_40N.nc

cdo -s mul GEO_gt_40N.nc ${dir}/North_Atl_mask.nc GEO_gt_40N_North_Atl.nc


cdo -s setname,mask -setctomiss,0 GEO_gt_40N_North_Atl.nc GEO_gt_40N_North_Atl_mask.nc
