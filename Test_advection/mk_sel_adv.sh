#!/bin/bash
dir1=/work/uo1451/m301158/mpiesm-1.2.01p7_budget_test_2/experiments/flat10_cdr_budget_004/outdata/hamocc
dir2=/work/uo1451/m301158/MPI-ESM/data/Test_advection
dir3=/work/uo1451/m301158/MPI-ESM/data/test_budget

 D=${dir2}/tsco212nat_h_v_advs_r192x96_185001-229812.nc
for year in $(seq 1850 2298); do

 A=${dir1}/flat10_cdr_budget_004_hamocc_data_3d_mm_${year}0101_${year}1231.nc
 B=${dir2}/tsco212nat_h_v_advs_${year}01-${year}12.nc
 E0=${dir2}/tsco212nat_h_v_advs_mul_dz_3000-6000m_${year}.nc
 E1=${dir2}/tsco212nat_h_v_advs_mul_dz_1000-3000m_${year}.nc
 E2=${dir2}/tsco212nat_h_v_advs_mul_dz_0-1000m_${year}.nc
 C0=${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_3000-6000m_${year}.nc
 C1=${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_1000-3000m_${year}.nc
 C2=${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_0-1000m_${year}.nc

 cdo -s -selname,tsco212nat_hadv,tsco212nat_vadv ${A} ${B}
 echo "${B}"
 cdo -s -yearmean -mul ${dir3}/ddpo_org.nc ${B} ${dir2}/imsi.nc
 cdo -vertsum -sellevel,3070,3395,3770,4195,4670,5170,5720 ${dir2}/imsi.nc ${E0} 
 echo "${E0}"
 cdo -vertsum -sellevel,1085,1220,1365,1525,1700,1885,2080,2290,2525,2785 ${dir2}/imsi.nc ${E1} 
 echo "${E1}"
 cdo -vertsum -sellevel,6,17,27,37,47,57,68.5,82.5,100,122.5,150,182.5,220,262.5,310,362.5,420,485,560,645,740,845,960 ${dir2}/imsi.nc ${E2} 
 rm -f ${dir2}/imsi.nc  
 echo "${E2}"
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 ${E0} ${C0}
 echo "${C0}"
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 ${E1} ${C1}
 echo "${C1}"
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 ${E2} ${C2}
 echo "${C2}"

done

 cdo mergetime ${dir2}/tsco212nat_h_v_advs_????01-????12.nc ${dir2}/tsco212nat_h_v_advs_185001-229812.nc
 rm -f ${dir2}/tsco212nat_h_v_advs_1???01-1???12.nc
 rm -f ${dir2}/tsco212nat_h_v_advs_2???01-2???12.nc
 echo "tsco212nat_h_v_advs_185001-229812.nc"
 cdo mergetime ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_3000-6000m_????.nc ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_3000-6000m_1850-2298.nc
 echo "tsco212nat_h_v_advs_r192x96_mul_dz_3000-6000m_1850-2298.nc"
 cdo mergetime ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_1000-3000m_????.nc ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_1000-3000m_1850-2298.nc
 echo "tsco212nat_h_v_advs_r192x96_mul_dz_1000-3000m_1850-2298.nc"
 cdo mergetime ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_0-1000m_????.nc ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_0-1000m_1850-2298.nc
 echo "tsco212nat_h_v_advs_r192x96_mul_dz_0-1000m_1850-2298.nc"
 rm -f ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_3000-6000m_????.nc 
 rm -f ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_1000-3000m_????.nc
 rm -f ${dir2}/tsco212nat_h_v_advs_r192x96_mul_dz_0-1000m_????.nc
 rm -f ${dir2}/tsco212nat_h_v_advs_mul_dz_3000-6000m_????.nc
 rm -f ${dir2}/tsco212nat_h_v_advs_mul_dz_1000-3000m_????.nc
 rm -f ${dir2}/tsco212nat_h_v_advs_mul_dz_0-1000m_????.nc
