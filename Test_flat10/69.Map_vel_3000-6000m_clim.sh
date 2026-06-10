#!/bin/bash

for i in $(seq 1850 2149); do

cat <<EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw/"

f=addfile(dir1+"","r")

u=f->uo
v=f->vo




end
EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
exit
done
