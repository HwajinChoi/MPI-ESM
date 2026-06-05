#!/bin/bash
# This code is just for reference.

set -x -e

#INFILE=$1

FX=/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/flat10_cdr_001_mpiom_fx_18500101_18501231.nc
p1=/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref

#INFILE should contain HALO points, for tripolar grids like TP04 or TP6M JB=3 (j=1,2 are the northern halo points)
JB=3
JE=220
IB=1
IE=256
#local grid area [unit = m2] (on every level) and missing values over land
cdo mul -selvar,areacello $FX -div -selvar,ddpo $FX -selvar,ddpo $FX gridarea.nc
#global ocean area on each level
cdo fldsum -selindexbox,$IB,$IE,$JB,$JE gridarea.nc globalarea.nc
#create a weightfile
cdo -f nc div gridarea.nc -enlarge,gridarea.nc globalarea.nc globalweight.nc
#test if gloabl sum of all weights is 1
cdo output -fldsum -selindexbox,$IB,$IE,$JB,$JE globalweight.nc
#how to use
# 3d field
#cdo fldsum -selindexbox,$IB,$IE,$JB,$JE -mul $INFILE globalweight.nc globalmean_${INFILE}


# Making how to make mask files 
cdo -O -eqc,4 -selvar,rbek ${p1}/flat10_cdr_001_mpiom_map_18500101_18501231.nc ${p1}/North_Atl_mask.nc   # North Atlantic
cdo -O mul globalweight.nc ${p1}/North_Atl_mask.nc ${p1}/North_Atl_raw.nc

# 수심별(그리고 time 차원) 지역 가중치 합
cdo -O fldsum -selindexbox,${IB},${IE},${JB},${JE} -enlarge,dissic_flat10_cdr_1850-2299.nc North_Atl_raw.nc North_Atl_wsum.nc
# 2-1) wsum에서 0인 곳을 결측으로
cdo -O setctomiss,0 North_Atl_wsum.nc North_Atl_wsum_miss.nc
# 2-2) 정규화 가중치: raw / wsum
#      축 맞춤을 위해 enlarge(raw)에 맞춰 확장
cdo -O div North_Atl_raw.nc -enlarge,North_Atl_raw.nc North_Atl_wsum_miss.nc North_Atl_wnorm.nc
#
cdo -O -f nc fldsum -selindexbox,${IB},${IE},${JB},${JE} -mul dissic_flat10_1850-2299.nc -enlarge,dissic_flat10_1850-2299.nc North_Atl_wnorm.nc North_Atl_dissic_flat10_1850-2299_mean.nc


vars=( dissic talknat talk phosy dissicnat thetao preformed_O2 preformed_PO4 preformed_DIC preformed_DICnat )
region=( North_Atl South_Atl South_Oce East_Pac )

#for s in "flat10" "flat10_cdr" "flat10_zec";do
for s in "flat10" "flat10_cdr" ;do
 for V in "${vars[@]}" ;do
  input=${V}_${s}_1850-2299.nc
  echo "${input}"
  for R in "${region[@]}" ;do
  cdo -O -f nc fldsum -selindexbox,${IB},${IE},${JB},${JE} -mul ${p1}/${input} -enlarge,"${p1}/${input}" ${p1}/${R}_raw.nc ${p1}/${R}_${input}
  echo "${R}_${input}"
  done
 done

done

# for NPP
cdo -O -f nc fldsum -selindexbox,1,256,3,220 -mul intpp_flat10_1850-2299.nc -enlarge,intpp_flat10_1850-2299.nc globalweight_surf.nc intpp_flat10_1850-2299_mean.nc

