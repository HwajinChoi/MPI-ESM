#!/bin/bash
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_pictrl_preform_001_spinup/outdata/mpiom
dir2=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref

for year in $(seq 8800 8949); do
 A=test_pictrl_preform_001_spinup_mpiom_data_3d_mm_${year}0101_${year}1231.nc
 B=agessc_pictrl_r192x96_${year}0101_${year}1231.nc

 cdo -s -selname,agessc ${dir1}/${A} ${dir2}/imsi.nc
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir2}/imsi.nc ${dir2}/${B}
 echo "Processed ${B}"
 rm -f ${dir2}/imsi.nc 
done

 cdo mergetime ${dir2}/agessc_pictrl_r192x96_????0101_????1231.nc ${dir2}/agessc_pictrl_r192x96_88000101-89491231.nc
 echo "Merged all the agessc files"
 rm -f ${dir2}/agessc_r192x96_????0101_????1231.nc

