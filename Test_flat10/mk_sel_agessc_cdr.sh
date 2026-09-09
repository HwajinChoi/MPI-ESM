#!/bin/bash
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom
dir2=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref

for year in $(seq 1850 2299); do
 A=flat10_cdr_001_mpiom_data_3d_mm_${year}0101_${year}1231.nc
 B=agessc_r192x96_${year}0101_${year}1231.nc

 cdo -s -selname,agessc ${dir1}/${A} ${dir2}/imsi.nc
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir2}/imsi.nc ${dir2}/${B}
 echo "Processed ${B}"
 rm -f ${dir2}/imsi.nc 
done

 cdo mergetime ${dir2}/agessc_r192x96_????0101_????1231.nc ${dir2}/agessc_r192x96_18500101-22991231.nc
 echo "Merged all the agessc files"
 rm -f ${dir2}/agessc_r192x96_????0101_????1231.nc

