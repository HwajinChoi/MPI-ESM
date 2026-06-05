#!/bin/bash
## Bo Liu
## To create masks for four 4 ocean basins


GEO=GEO_GR15.nc ##cdo merge *_fx_*.nc -selname,rbek *_map_*.nc GEO_GR15.nc
expid=GR15

cdo -s gec,20 -selvar,alon ${GEO} lon1.nc
cdo -s lec,125 -selvar,alon ${GEO} lon2.nc
cdo -s mul lon1.nc lon2.nc temp_${expid}_lon_20-125.mask.nc
rm lon1.nc lon2.nc

cdo -s eqc,6 -selvar,rbek ${GEO} temp_${expid}_rbek_6.mask.nc

cdo mul temp_${expid}_rbek_6.mask.nc temp_${expid}_lon_20-125.mask.nc temp_${expid}_rbek_6_ind.mask.nc


cdo -s eqc,7 -selvar,rbek ${GEO} temp_${expid}_rbek_7.mask.nc

cdo -s gec,0 -selvar,alat ${GEO} lat1.nc
cdo -s lec,90 -selvar,alat ${GEO} lat2.nc
cdo -s mul lat1.nc lat2.nc temp_${expid}_lat_0-90.mask.nc
rm lat1.nc lat2.nc

cdo mul temp_${expid}_rbek_7.mask.nc temp_${expid}_lat_0-90.mask.nc temp_${expid}_rbek_7_north.mask.nc


cdo -s gec,0 -selvar,alon ${GEO} lon1.nc
cdo -s lec,110 -selvar,alon ${GEO} lon2.nc
cdo -s mul lon1.nc lon2.nc temp_${expid}_lon_0-110.mask.nc
rm lon1.nc lon2.nc

cdo mul temp_${expid}_rbek_7_north.mask.nc temp_${expid}_lon_0-110.mask.nc temp_${expid}_rbek_7_north_ind.mask.nc

cdo -s gec,0 -selvar,alon ${GEO} lon1.nc
cdo -s lec,125 -selvar,alon ${GEO} lon2.nc
cdo -s mul lon1.nc lon2.nc temp_${expid}_lon_0-125.mask.nc
rm lon1.nc lon2.nc

cdo sub temp_${expid}_rbek_7.mask.nc temp_${expid}_rbek_7_north.mask.nc temp_${expid}_rbek_7_south.mask.nc
cdo mul temp_${expid}_rbek_7_south.mask.nc temp_${expid}_lon_0-125.mask.nc temp_${expid}_rbek_7_south_ind.mask.nc

cdo add temp_${expid}_rbek_7_north_ind.mask.nc temp_${expid}_rbek_7_south_ind.mask.nc temp_${expid}_rbek_7_ind.mask.nc


cdo -s gec,-70 -selvar,alon ${GEO} lon1.nc
cdo -s lec,20 -selvar,alon ${GEO} lon2.nc
cdo -s mul lon1.nc lon2.nc temp_${expid}_lon_-70-20.mask.nc
rm lon1.nc lon2.nc


cdo mul temp_${expid}_lon_-70-20.mask.nc temp_${expid}_rbek_6.mask.nc temp_${expid}_rbek_6_-72-20.mask.nc
cdo sub -sub temp_${expid}_rbek_6.mask.nc temp_${expid}_rbek_6_ind.mask.nc temp_${expid}_rbek_6_-72-20.mask.nc temp_${expid}_rbek_6_pac.mask.nc

cdo sub temp_${expid}_rbek_7.mask.nc temp_${expid}_rbek_7_ind.mask.nc temp_${expid}_rbek_7_pac.mask.nc

cdo -s eqc,8 -selvar,rbek ${GEO} temp_${expid}_rbek_8.mask.nc

cdo setname,mask -setctomiss,0 -add -add temp_${expid}_rbek_7_pac.mask.nc temp_${expid}_rbek_6_pac.mask.nc temp_${expid}_rbek_8.mask.nc ${expid}_pac.mask.nc
cdo setname,mask -setctomiss,0 -add temp_${expid}_rbek_6_ind.mask.nc temp_${expid}_rbek_7_ind.mask.nc ${expid}_ind.mask.nc


cdo -s eqc,1 -selvar,rbek ${GEO} temp_${expid}_rbek_1.mask.nc
cdo -s eqc,3 -selvar,rbek ${GEO} temp_${expid}_rbek_3.mask.nc
cdo -s eqc,4 -selvar,rbek ${GEO} temp_${expid}_rbek_4.mask.nc
cdo -s eqc,5 -selvar,rbek ${GEO} temp_${expid}_rbek_5.mask.nc

cdo -s gec,-70 -selvar,alon ${GEO} lon1.nc
cdo -s lec,20 -selvar,alon ${GEO} lon2.nc
cdo -s mul lon1.nc lon2.nc temp_${expid}_lon_-70-20.mask.nc
rm lon1.nc lon2.nc

cdo mul temp_${expid}_lon_-70-20.mask.nc temp_${expid}_rbek_6.mask.nc temp_${expid}_rbek_6_-72-20.mask.nc

cdo setname,mask -setctomiss,0 -add -add -add -add temp_${expid}_rbek_6_-72-20.mask.nc temp_${expid}_rbek_1.mask.nc temp_${expid}_rbek_3.mask.nc temp_${expid}_rbek_4.mask.nc temp_${expid}_rbek_5.mask.nc ${expid}_atl.mask.nc

## a mask for ocean
cdo setname,mask -div -addc,10 -selname,rbek ${GEO} -addc,10 -selname,rbek ${GEO} ${expid}_ocean.mask.nc


cdo setmisstoc,0 -addc,0 ${expid}_atl.mask.nc temp_${expid}_atl.mask.nc
cdo setmisstoc,0 -addc,1 ${expid}_pac.mask.nc temp_${expid}_pac.mask.nc
cdo setmisstoc,0 -addc,2 ${expid}_ind.mask.nc temp_${expid}_ind.mask.nc

cdo add -add temp_${expid}_atl.mask.nc temp_${expid}_pac.mask.nc temp_${expid}_ind.mask.nc temp_${expid}_3basins.mask.nc #no missing values
cdo add ${expid}_ocean.mask.nc temp_${expid}_3basins.mask.nc ${expid}_4basins.mask.nc #missing values

cdo -s eqc,1 -selvar,mask ${expid}_4basins.mask.nc temp_${expid}_arc.mask.nc
cdo setctomiss,0 temp_${expid}_arc.mask.nc ${expid}_arc.mask.nc

rm temp*.nc
