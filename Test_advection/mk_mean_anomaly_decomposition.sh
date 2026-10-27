#!/bin/bash

set -euo pipefail

dir1=/work/uo1451/m301158/MPI-ESM/data/Test_advection


#------------------- Mean fields ----------------------
A_c=${dir1}/dissicnat_flat10_cdr_mean_1850-2299.nc
B_c=${dir1}/velocity_mean_1850-2299.nc 

# --------------------------------------
#           Annual calculation
# --------------------------------------
for year in $(seq 1851 2299); do
 A=${dir1}/dissicnat_${year}01-${year}12.nc
 B=${dir1}/velocity_${year}01-${year}12.nc

 tmp=${dir1}/tmp_${year}
    mkdir -p "${tmp}"

    # --------------------------------------
    # 1. Concentration deviation
    #    C' = C - Cmean
    # --------------------------------------
    cdo -O sub -selname,dissicnat ${A} -selname,dissicnat ${A_c} ${tmp}/C_prime.nc

    # --------------------------------------
    # 2. Velocity decomposition
    # --------------------------------------
    for comp in uo vo ; do

        echo "  Processing ${comp}..."

        # Velocity deviation: U' = U - Umean
        cdo -O sub -selname,${comp} ${B} -selname,${comp} ${B_c} ${tmp}/${comp}_prime.nc

        # Mean velocity × mean concentration
        cdo -O mul -selname,${comp} ${B_c} -selname,dissicnat ${A_c} ${tmp}/${comp}_meanCmean.nc

        # Mean velocity × concentration deviation
        cdo -O mul -selname,${comp} ${B_c} ${tmp}/C_prime.nc ${tmp}/${comp}_meanCprime.nc

        # Velocity deviation × mean concentration
        cdo -O mul ${tmp}/${comp}_prime.nc -selname,dissicnat ${A_c} ${tmp}/${comp}_primeCmean.nc

        # Velocity deviation × concentration deviation
        cdo -O mul ${tmp}/${comp}_prime.nc ${tmp}/C_prime.nc ${tmp}/${comp}_primeCprime.nc

        # --------------------------------------
        # 3. Rename variables
        # --------------------------------------
        for term in meanCmean meanCprime primeCmean primeCprime; do

            cdo -O chname,${comp},${comp}_${term} ${tmp}/${comp}_${term}.nc ${tmp}/${comp}_${term}_renamed.nc

        done

    done

    # --------------------------------------
    # 4. Merge decomposition terms
    # --------------------------------------
    #    cdo -O merge ${tmp}/*_renamed.nc ${dir1}/DIC_flux_decomposition_${year}01-${year}12.nc
    #    # Merge only time-varying decomposition terms
    cdo -O merge ${tmp}/uo_meanCprime_renamed.nc ${tmp}/uo_primeCmean_renamed.nc ${tmp}/uo_primeCprime_renamed.nc ${tmp}/vo_meanCprime_renamed.nc \
    ${tmp}/vo_primeCmean_renamed.nc ${tmp}/vo_primeCprime_renamed.nc ${dir1}/DIC_flux_decomposition_${year}01-${year}12.nc

    # --------------------------------------
    # 5. Remove temporary files
    # --------------------------------------
    rm -rf "${tmp}"

    echo "Finished ${year}"

done

echo "All years completed."
