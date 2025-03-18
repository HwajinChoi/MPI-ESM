#!/bin/bash

dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2/experiments/test_pictrl003/outdata/hamocc

for y in $(seq 1850 1 1900);do
 file=test_pictrl003_hamocc_data_3d_mm_${y}0101_${y}1231.nc
 cdo -s -selname, ${dir1}/${file}
done
