#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2/experiments/test_pictrl003/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_pictrl003
dir3=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_pictrl_ver2_001/outdata/hamocc
dir4=/work/uo1451/m301158/MPI-ESM/data/test_pictrl_ver2_001

for year in $(seq 1850 1 1900);do
 N1=test_pictrl003_hamocc_data_3d_mm_${year}0101_${year}1231.nc
 N2=test_pictrl_ver2_001_hamocc_data_3d_mm_${year}0101_${year}1231.nc 

 cdo -s -selname,dissic,dissicnat ${dir1}/${N1} ${dir2}/dissic_nat_${year}0101_${year}1231.nc
 echo ${dir2}/dissic_nat_${year}0101_${year}1231.nc

 cdo -s -selname,dissic,dissicnat ${dir3}/${N2} ${dir4}/dissic_nat_${year}0101_${year}1231.nc
 echo ${dir4}/dissic_nat_${year}0101_${year}1231.nc
done
