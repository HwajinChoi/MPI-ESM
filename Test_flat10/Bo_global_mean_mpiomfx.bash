#!/bin/bash

set -x -e

INFILE=$1

FX=../mpiom/*_mpiom_fx_*.nc

#INFILE should contain HALO points, for tripolar grids like TP04 or TP6M JB=3 (j=1,2 are the northern halo points)
JB=1
JE=101
IB=2
IE=121
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
cdo fldsum -selindexbox,$IB,$IE,$JB,$JE -mul $INFILE globalweight.nc globalmean_${INFILE}

