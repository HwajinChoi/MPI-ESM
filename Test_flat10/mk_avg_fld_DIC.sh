#!/bin/bash

dir1=



cdo -fldsum -mul test_flat10_001_cfcs_ideal_dissic_1850_2149.nc -gridarea test_flat10_001_cfcs_ideal_dissic_1850_2149.nc ${output}
cdo -chunit,mol m-3,micro mol kg-1 -mulc,975.6097 -fldmean -mul ${input} -gridarea ${input} ${output}
cdo -chunit,mol m-3,micro mol kg-1 -mulc,975.6097 -fldsum -mul ${input} -gridarea ${input} ${output}


