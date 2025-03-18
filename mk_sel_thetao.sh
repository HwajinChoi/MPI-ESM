#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2/experiments/test_pictrl003/outdata/mpiom
dir2=/work/uo1451/m301158/MPI-ESM/data/test_pictrl003

for year in $(seq 1850 1 1900);do
 N1=test_pictrl003_mpiom_data_3d_mm_${year}0101_${year}1231.nc
 cdo -s -selname,thetao ${dir1}/${N1} ${dir2}/thetao_${year}0101_${year}1231.nc
 echo thetao_${year}0101_${year}1231.nc
done
