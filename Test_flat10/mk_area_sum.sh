#!/bin/bash

dir1=/work/uo1451/m301158/MPI-ESM/data/test_flat10
var=carbon_emission
input=T63_carbon_emissions_esm-flat10_zec.nc

cdo -chunit,"g(C)m^-2s^-1","PgC year-1" -mulc,3.1536e-8 -fldsum -mul ${dir1}/${input}  -gridarea ${dir1}/${input} ${dir1}/fld_sum_${input}

