#!/bin/bash

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
cdo fldsum -selindexbox,$IB,$IE,$JB,$JE -mul ${input} globalweight.nc globalmean_${input}
