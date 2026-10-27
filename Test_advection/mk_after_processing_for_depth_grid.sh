#!/bin/bash
dir1=/work/uo1451/m301158/MPI-ESM/data/Test_advection
dir3=/work/uo1451/m301158/MPI-ESM/data/test_budget

for year in $(seq 1850 2299); do
 A=${dir1}/DIC_horizontal_advection_${year}01-${year}12.nc
 B=${dir1}/DIC_vertical_advection_${year}01-${year}12.nc

 A1=${dir1}/DIC_horizontal_advection_r192x96_mul_dz_0-1000m_${year}.nc
 A2=${dir1}/DIC_horizontal_advection_r192x96_mul_dz_1000-3000m_${year}.nc
 A3=${dir1}/DIC_horizontal_advection_r192x96_mul_dz_3000-6000m_${year}.nc

 B1=${dir1}/DIC_vertical_advection_r192x96_mul_dz_0-1000m_${year}.nc
 B2=${dir1}/DIC_vertical_advection_r192x96_mul_dz_1000-3000m_${year}.nc
 B3=${dir1}/DIC_vertical_advection_r192x96_mul_dz_3000-6000m_${year}.nc

 cdo -s -yearmean -mul ${dir3}/ddpo_org.nc ${A} ${dir1}/imsi1.nc
 cdo -s -yearmean -mul ${dir3}/ddpo_org.nc ${B} ${dir1}/imsi2.nc

 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 -vertsum -sellevel,3070,3395,3770,4195,4670,5170,5720 ${dir1}/imsi1.nc  ${A3} 
 echo ${A3}
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 -vertsum -sellevel,1085,1220,1365,1525,1700,1885,2080,2290,2525,2785 ${dir1}/imsi1.nc  ${A2}
 echo ${A2}
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 -vertsum -sellevel,6,17,27,37,47,57,68.5,82.5,100,122.5,150,182.5,220,262.5,310,362.5,420,485,560,645,740,845,960 ${dir1}/imsi1.nc  ${A1}
 echo ${A1}
 rm -f ${dir1}/imsi1.nc
 
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 -vertsum -sellevel,3070,3395,3770,4195,4670,5170,5720 ${dir1}/imsi2.nc ${B3} 
 echo ${B3}
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 -vertsum -sellevel,1085,1220,1365,1525,1700,1885,2080,2290,2525,2785 ${dir1}/imsi2.nc ${B2}
 echo ${B2}
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 -vertsum -sellevel,6,17,27,37,47,57,68.5,82.5,100,122.5,150,182.5,220,262.5,310,362.5,420,485,560,645,740,845,960 ${dir1}/imsi2.nc  ${B1}
 echo ${B1}
 rm -f ${dir1}/imsi2.nc

done

 cdo mergetime ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_0-1000m_????.nc  ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_0-1000m_1850-2299.nc
 echo "DIC_horizontal_advection_r192x96_mul_dz_0-1000m_1850-2299.nc"
 cdo mergetime ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_1000-3000m_????.nc  ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_1000-3000m_1850-2299.nc
 echo "DIC_horizontal_advection_r192x96_mul_dz_1000-3000m_1850-2299.nc"
 cdo mergetime ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_3000-6000m_????.nc  ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_3000-6000m_1850-2299.nc
 echo "DIC_horizontal_advection_r192x96_mul_dz_3000-6000m_1850-2299.nc"

 cdo mergetime ${dir1}/DIC_vertical_advection_r192x96_mul_dz_0-1000m_????.nc  ${dir1}/DIC_vertical_advection_r192x96_mul_dz_0-1000m_1850-2299.nc
 echo "DIC_vertical_advection_r192x96_mul_dz_0-1000m_1850-2299.nc"
 cdo mergetime ${dir1}/DIC_vertical_advection_r192x96_mul_dz_1000-3000m_????.nc  ${dir1}/DIC_vertical_advection_r192x96_mul_dz_1000-3000m_1850-2299.nc
 echo "DIC_vertical_advection_r192x96_mul_dz_1000-3000m_1850-2299.nc"
 cdo mergetime ${dir1}/DIC_vertical_advection_r192x96_mul_dz_3000-6000m_????.nc  ${dir1}/DIC_vertical_advection_r192x96_mul_dz_3000-6000m_1850-2299.nc
 echo "DIC_vertical_advection_r192x96_mul_dz_3000-6000m_1850-2299.nc"

 rm -f ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_0-1000m_????.nc
 rm -f ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_1000-3000m_????.nc
 rm -f ${dir1}/DIC_horizontal_advection_r192x96_mul_dz_3000-6000m_????.nc

 rm -f ${dir1}/DIC_vertical_advection_r192x96_mul_dz_0-1000m_????.nc
 rm -f ${dir1}/DIC_vertical_advection_r192x96_mul_dz_1000-3000m_????.nc
 rm -f ${dir1}/DIC_vertical_advection_r192x96_mul_dz_3000-6000m_????.nc
 
