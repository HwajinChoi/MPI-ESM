#!/bin/bash

GEO=GEO_GR15.nc
OCE=GR15_ocean.mask.nc

# lat <= -40 : 1, or 0 (alat )
cdo -s lec,-40 -selvar,alat ${GEO} so40_lat.nc

#Only Ocean (ocean mask)
cdo -s mul so40_lat.nc ${OCE} so40_ocean.nc

# 0 ->  missing  + variable -> mask
cdo -s setname,mask -setctomiss,0 so40_ocean.nc GR15_so40.mask.nc

rm -f so40_lat.nc so40_ocean.nc

# lat <= -45 : 1, or 0 (alat )
cdo -s lec,-45 -selvar,alat ${GEO} so45_lat.nc
cdo -s mul so45_lat.nc ${OCE} so45_ocean.nc
cdo -s setname,mask -setctomiss,0 so45_ocean.nc GR15_so45.mask.nc
rm -f so45_lat.nc so45_ocean.nc

