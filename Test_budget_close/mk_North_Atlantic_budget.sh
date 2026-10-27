#!/bin/bash

set -euo pipefail

dir1=/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi
dir2=/work/uo1451/m301158/MPI-ESM/data/Test_budget_close

A=${dir1}/GEO_gt_40N_North_Atl_mask.nc
C=${dir2}/flat10_cdr_budget_002_mpiom_fx_18500101_18501231.nc

levels=6,17,27,37,47,57,68.5,82.5,100,122.5,150,182.5,220,262.5,310,362.5,420,485,560,645,740,845,960

# 1. Calculate cell volume (m3)
cdo -O mul -selvar,areacello ${C} -selvar,ddpo ${C} ${dir2}/cell_volume.nc

# 2. Select 0–1000 m
cdo -O sellevel,${levels} ${dir2}/cell_volume.nc ${dir2}/cell_volume_0-1000m.nc

# 3. Apply North Atlantic mask to cell volume
cdo -O mul -selvar,mask ${A} ${dir2}/cell_volume_0-1000m.nc ${dir2}/cell_volume_NA_0-1000m.nc

# 4. Calculate total volume of the region
cdo -O fldsum -vertsum ${dir2}/cell_volume_NA_0-1000m.nc ${dir2}/total_volume_NA.nc

# 5. Calculate volume-weighted mean advection for each year
for year in $(seq 1850 2299); do

    echo "Processing ${year}..."

    B=${dir2}/DIC_advection_terms_${year}01-${year}12.nc
    ncatted -O -a coordinates,adv_UC,o,c,"lon lat" -a coordinates,adv_VC,o,c,"lon lat" -a coordinates,adv_WC,o,c,"lon lat" "${B}"

    # Select 0–1000 m
    cdo -O sellevel,${levels} ${B} ${dir2}/adv_off_0-1000m_${year}.nc

    # Apply North Atlantic mask
    cdo -O setctomiss,-9e33 -mul -selvar,mask ${A} ${dir2}/adv_off_0-1000m_${year}.nc ${dir2}/adv_off_NA_0-1000m_${year}.nc

    # Multiply advection by cell volume
    cdo -O mul ${dir2}/adv_off_NA_0-1000m_${year}.nc ${dir2}/cell_volume_NA_0-1000m.nc ${dir2}/adv_off_weighted_${year}.nc

    # Sum over depth and horizontal area
    cdo -O fldsum -vertsum ${dir2}/adv_off_weighted_${year}.nc ${dir2}/adv_off_integrated_${year}.nc

    # Divide by total volume
    cdo -O div ${dir2}/adv_off_integrated_${year}.nc ${dir2}/total_volume_NA.nc ${dir2}/adv_off_mean_${year}.nc

done

# 6. Merge yearly files into a single time series
cdo -O mergetime ${dir2}/adv_off_mean_????.nc ${dir2}/adv_off_mean_NA_0-1000m_1850-2299.nc

 rm -f ${dir2}/adv_off_0-1000m_????.nc
 rm -f ${dir2}/adv_off_NA_0-1000m_????.nc
 rm -f ${dir2}/adv_off_weighted_????.nc
 rm -f ${dir2}/adv_off_integrated_????.nc
 rm -f ${dir2}/adv_off_mean_????.nc

 rm -f ${dir2}/cell_volume.nc
 rm -f ${dir2}/cell_volume_0-1000m.nc
 rm -f ${dir2}/cell_volume_NA_0-1000m.nc
 rm -f ${dir2}/total_volume_NA.nc

