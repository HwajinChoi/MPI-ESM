dir1=/work/uo1451/m301158/MPI-ESM/data/Test_advection
dir3=/work/uo1451/m301158/MPI-ESM/data/test_budget

cdo -s -yearmean -mul \
    ${dir3}/ddpo_org.nc \
    ${dir1}/DIC_horizontal_advection_229601-229612.nc \
    ${dir1}/check_imsi1_2296.nc

cdo -s info -sellevel,3070 \
    ${dir1}/check_imsi1_2296.nc
