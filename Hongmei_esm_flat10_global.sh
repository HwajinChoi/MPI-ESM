#!/bin/bash
#SBATCH --job-name=esm_flat10_global  # Specify job name
#SBATCH --partition=compute     # Specify partition name
#SBATCH --time=1:00:00         # Set a limit on the total run time
#SBATCH --mail-type=FAIL       # Notify user by email in case of job failure
#SBATCH --account=bg1446       # Charge resources on this project account
#SBATCH --output=esm_flat10_global.o%j    # File name for standard output
#SBATCH --error=esm_flat10_global.e%j     # File name for standard error output

## send to batch with:
# sbatch esm_flat10_global.sh

idir=/work/bg1446/g260241/from_bm1124/mpiesm-1.2.01p7/experiments/cmor/CMIP6/C4MIP/MPI-M/MPI-ESM1-2-LR
odir=./esm_flat10_global
#expname=esm-flat10
#exp=flat10
#expname=esm-flat10_zec
#exp=flat10_zec
#expname=esm-flat10_cdr
#exp=flat10_cdr
sexp="flat10 flat10_zec flat10_cdr"
for exp in ${sexp}; do
var=co2
cdo -mergetime ${idir}/esm-${exp}/r1i1p1f1/Amon/${var}/gn/v20190710/${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1_gn*.nc ${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc
cdo -shifttime,-1849years -chunit,"mol mol-1","ppm" -mulc,1.e+6 -fldmean -yearmean -sellevel,100000 -selvar,${var} ${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc ${odir}/${exp}_${var}_MPI-ESM1-2-LR.nc
rm -f ${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc

var=tas
cdo -mergetime ${idir}/esm-${exp}/r1i1p1f1/Amon/${var}/gn/v20190710/${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1_gn*.nc ${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc
cdo -shifttime,-1849years -fldmean -yearmean ${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc ${odir}/${exp}_${var}_MPI-ESM1-2-LR.nc
rm -f ${var}_Amon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc

var=nbp
cdo -mergetime ${idir}/esm-${exp}/r1i1p1f1/Lmon/${var}/gn/v20190710/${var}_Lmon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1_gn*.nc ${var}_Lmon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc
# 3.1536e-5 is for the unit transfer
cdo -chunit,"kg m-2 s-1","Pg year-1" -mulc,3.1536e-5 -shifttime,-1849years -fldsum -yearmean -mul ${var}_Lmon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc -gridarea ${var}_Lmon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc ${odir}/${exp}_${var}_MPI-ESM1-2-LR.nc
rm -f ${var}_Lmon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc

var=fgco2
oarea=/work/ik1017/CMIP6/data/CMIP6/CMIP/MPI-M/MPI-ESM1-2-LR/esm-piControl/r1i1p1f1/Ofx/areacello/gn/v20190815/areacello_Ofx_MPI-ESM1-2-LR_esm-piControl_r1i1p1f1_gn.nc
cdo -mergetime ${idir}/esm-${exp}/r1i1p1f1/Omon/${var}/gn/v20190710/${var}_Omon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1_gn*.nc ${var}_Omon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc
# 3.1536e-5 is for the unit transfer
#cdo -chunit,"kg m-2 s-1","Pg year-1" -mulc,3.1536e-5 -shifttime,-1849years -fldsum -yearmean -mul -selvar,${var} ${var}_Omon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc -selvar,area /pool/data/MPIOM/GR15/GR15L40_fx.nc ${odir}/${exp}_${var}_MPI-ESM1-2-LR.nc
#note that the area data in /pool/data/MPIOM/GR15/GR15L40_fx.nc doesn't match the cmorized grids exactly, therefore would lead to a small difference in the global integrated value of 0.006 PgC/year.
cdo -chunit,"kg m-2 s-1","Pg year-1" -mulc,3.1536e-5 -shifttime,-1849years -fldsum -yearmean -mul -selvar,${var} ${var}_Omon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc -selvar,areacello ${oarea} ${odir}/${exp}_${var}_MPI-ESM1-2-LR.nc
rm -f ${var}_Omon_MPI-ESM1-2-LR_esm-${exp}_r1i1p1f1.nc
done

exit
