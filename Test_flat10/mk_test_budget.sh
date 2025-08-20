#!/bin/bash

dir=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/test2/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/test_budget

for year in $(seq 1850 1855);do

 A=test2_hamocc_data_3d_ym_${year}0101_${year}1231.nc

 b1="tpreformed_DIC_tot,tpreformed_DIC_adv,tpreformed_DIC_dif,tpreformed_DIC_gm,tpreformed_DIC_surf"
 c1="test2_tpreformed_DIC_3d_ym_${year}.nc"
 cdo -s -selname,${b1} ${dir}/${A} ${dir2}/${c1} 
 echo "Processed ${c1}"

 b2="tsco212_tot,tsco212_adv,tsco212_dif,tsco212_gm,tsco212_sosi,tsco212_surf"
 c2="test2_DIC_3d_ym_${year}.nc"
 cdo -s -selname,${b2} ${dir}/${A} ${dir2}/${c2} 
 echo "Processed ${c2}"

 b3="tsco212nat_tot,tsco212nat_adv,tsco212nat_dif,tsco212nat_gm,tsco212nat_sosi,tsco212nat_surf"
 c3="test2_DICnat_3d_ym_${year}.nc"
 cdo -s -selname,${b3} ${dir}/${A} ${dir2}/${c3} 
 echo "Processed ${c3}"

done
