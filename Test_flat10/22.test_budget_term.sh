#!/bin/bash
for V in "DIC" "DICnat" "tpreformed_DIC" ;do

 if [ $V = "tpreformed_DIC" ];then
  A="tpreformed_DIC"
  B=""
 elif [ $V = "DIC" ];then
  A="tsco212"
  B="sosi=f->${A}_sosi(:,{0:100},:,:)"
 else
  A="tsco212nat"
  B="sosi=f->${A}_sosi(:,{0:100},:,:)"
 fi

cat << EOF > ./imsi.ncl
begin

dir="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
f=addfile(dir+"test2_${V}_reg_0_100mavg_ym_1850-1855.nc","r")
tot=f->${A}_tot(:,0,:,:)
adv=f->${A}_adv(:,0,:,:)
dif=f->${A}_dif(:,0,:,:)
gm=f->${A}_gm(:,0,:,:)
${B}



end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done


