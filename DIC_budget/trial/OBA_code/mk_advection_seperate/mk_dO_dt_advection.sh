#!/bin/bash

for i in "0-100" "100-300" "300-800"; do
    if [ $i = "0-100" ];then
        I="0_100"
    elif [ $i = "100-300" ];then
        I="100_300"
    else
        I="300_800"
    fi

cat <<EOF > ./imsi.ncl
begin

dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"o2_${i}mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")

o2_${I}=f1->o2 ;time*yt_ocean*xt_ocean
time=f1->time
o2_${I}=o2_${I}*1000000 ; For change unit micro mol/kg
o2_${I}@units="micro mol/kg"

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

O=o2_${I};time*lat*lon
dim=dimsizes(O);time*lat*lon

;-----------------------------------------------------------------------------------------
O_clim_12=clmMonTLL(O)
O_clim=new((/dim(0),dim(1),dim(2)/),"float")
O_ano=new((/dim(0),dim(1),dim(2)/),"float")

    do m =0,dim(0)/12-1
        O_clim(12*m:12*m+11,:,:)=O_clim_12(:,:,:)
    end do

O_ano=O-O_clim
copy_VarCoords(O,O_ano)
;-----------------------------------------------------------------------------------------
Ot_prime=new((/dim(0),dim(1),dim(2)/),"float")
   Ot_prime(0,:,:)=(O_ano(1,:,:)-O_ano(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Ot_prime(i,:,:)=(O_ano(i+1,:,:)-O_ano(i-1,:,:))/(2*t)   ;time 335
    end do
   Ot_prime(dim(0)-1,:,:)=(O_ano(dim(0)-1,:,:)-O_ano(dim(0)-2,:,:))/(t)   ;time 335
Ot_prime!0="time"
Ot_prime!1="yt_ocean"
Ot_prime!2="xt_ocean"
Ot_prime&yt_ocean=yt_ocean
Ot_prime&xt_ocean=xt_ocean
   print("Accomplished round O' / round t")
;-----------------------------------------------------------------------------------------
Ot_bar=new((/dim(0),dim(1),dim(2)/),"float")
   Ot_bar(0,:,:)=(O_clim(1,:,:)-O_clim(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Ot_bar(i,:,:)=(O_clim(i+1,:,:)-O_clim(i-1,:,:))/(2*t)   ;time 335
    end do
   Ot_bar(dim(0)-1,:,:)=(O_clim(dim(0)-1,:,:)-O_clim(dim(0)-2,:,:))/(t)   ;time 335
Ot_bar!0="time"
Ot_bar!1="yt_ocean"
Ot_bar!2="xt_ocean"
Ot_bar&yt_ocean=yt_ocean
Ot_bar&xt_ocean=xt_ocean
   print("Accomplished round O bar / round t")
;-----------------------------------------------------------------------------------------

system("rm -f "+dir2+"ECDA-COBALT_dO_dt_${i}_advection_199001-201712.nc")
out=addfile(    dir2+"ECDA-COBALT_dO_dt_${i}_advection_199001-201712.nc","c")
out->Ot_prime=Ot_prime
out->Ot_bar=Ot_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl

done
