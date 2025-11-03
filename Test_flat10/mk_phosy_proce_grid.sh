#/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw
for s in "flat10" "flat10_zec" "flat10_cdr" ; do
 dir1=/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_${s}_001_cfcs_ideal/outdata/hamocc/
 
 for year in $(seq 1850 2149); do
  A=test_${s}_001_cfcs_ideal_hamocc_data_3d_ym_${year}0101_${year}1231.nc
  cdo -s -selname,phosy ${dir1}/${A} ${dir0}/phosy_${s}_${year}.nc
  cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir0}/phosy_${s}_${year}.nc ${dir0}/phosy_${s}_r192x96_${year}.nc
  echo "Processed phosy_${s}_r192x96_${year}.nc"
  rm -f ${dir0}/phosy_${s}_${year}.nc
 done

 cdo -s -mergetime ${dir0}/phosy_${s}_r192x96_????.nc ${dir0}/phosy_${s}_r192x96_1850-2149.nc
 rm -f ${dir0}/phosy_${s}_r192x96_????.nc

 for lon in 340 190 70 ; do
   R=${dir0}/phosy_${s}_r192x96_1850-2149.nc
   L=${dir0}/phosy_${s}_r192x96_1850-2149_lon_${lon}.nc

   west=$(($lon - 1))
   east=$(($lon + 1))
  cdo -s -sellonlatbox,${west},${east},-90,90 ${R} ${L}
  echo "Processed phosy_${s}_r192x96_1850-2149_lon_${lon}.nc"
 done

done
