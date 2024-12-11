#!/bin/bash

dir0=/work/uo1451/m301158/MPI-ESM/code/flat10_MIP
dir1=/work/ik1017/CMIP6/data/CMIP6/CMIP/MPI-M/MPI-ESM1-2-LR/esm-piControl/r1i1p1f1/Omon/dissic/gn/v20190815
dir2=/work/uo1451/m301158/MPI-ESM/data/esm-flat10/raw/regrid

cd ${dir1}
ls ${dir1} > ${dir0}/Dissic_piC_name_list

while IFS= read -r file_name; do
 echo "Processing file: $file_name"
 cdo -s -f nc -remapbil,r192x96 -selindexbox,2,257,2,221 ${dir1}/${file_name} ${dir2}/${file_name}

 for i in "340" "190" "70" ;do
  output="${file_name%.nc}_lon_${i}.nc"
  a=`expr $i - 1`
  b=`expr $i + 1`
  echo "Regrided ${file_name}"
  cdo -s -sellonlatbox,$a,$b,-90,90 ${dir2}/${file_name} ${dir2}/${output}
  echo "Processed ${output}"
 done
done < ${dir0}/Dissic_piC_name_list

