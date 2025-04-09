#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/code/flat10_MIP
dir1=/work/bg1446/g260241/from_bm1124/mpiesm-1.2.01p7/experiments/cmor/CMIP6/C4MIP/MPI-M/MPI-ESM1-2-LR/esm-flat10/r1i1p1f1/Omon/dissic/gn/v20190710
dir2=/work/uo1451/m301158/MPI-ESM/data/esm-flat10/raw

cd ${dir1}
ls ${dir1} > ${dir0}/Dissic_flat10_name_list

while IFS= read -r file_name; do
  echo "Processing file: $file_name"
  input="${dir1}/${file_name}"
  output1="${dir2}/${file_name%.nc}_182.5.nc"
  output2="${dir2}/${file_name%.nc}_6.nc"

  cdo sellevel,182.5 $input $output1
  cdo sellevel,6 $input $output2
  echo "Processed ${output1}"
  echo "Processed ${output2}"
done < ${dir0}/Dissic_flat10_name_list


