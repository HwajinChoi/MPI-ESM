#!/bin/bash

# nonSO = ocean - SO 
for S in "40" "45" ; do
  cdo -s setmisstoc,0 GR15_so${S}.mask.nc so${S}_01.nc
 for B in "pac" "ind" "atl" ;do
  cdo -s setmisstoc,0 GR15_${B}.mask.nc ${B}_01.nc
  cdo -s sub ${B}_01.nc so${S}_01.nc tmp.nc 
  cdo -s setrtoc,-1e20,-1e-12,0 tmp.nc nonSO${S}_${B}_01.nc
  cdo -s setname,mask -setctomiss,0 nonSO${S}_${B}_01.nc GR15_nonSO${S}_${B}.mask.nc
  rm -f tmp.nc ${B}_01.nc nonSO${S}_${B}_01.nc
 done
  rm -f so${S}_01.nc 
done

