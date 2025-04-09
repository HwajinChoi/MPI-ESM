#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/code/flat10_MIP
dir1=/work/ik1017/CMIP6/data/CMIP6/CMIP/MPI-M/MPI-ESM1-2-LR/esm-piControl/r1i1p1f1/Omon/dissic/gn/v20190815
dir2=/work/uo1451/m301158/MPI-ESM/data/esm-piControl/raw

cd ${dir1}
ls ${dir1} | tail -15 > ${dir0}/Dissic_piC_name_list

while IFS= read -r file_name; do
  echo "Processing file: $file_name"
  input="${dir1}/${file_name}"
  output1="${dir2}/${file_name%.nc}_182.5.nc"
  output2="${dir2}/${file_name%.nc}_6.nc"

  cdo sellevel,182.5 $input $output1
  cdo sellevel,6 $input $output2
  echo "Processed ${output1}"
  echo "Processed ${output2}"
done < ${dir0}/Dissic_piC_name_list


