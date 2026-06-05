#!/bin/bash

for i in "0-100" "100-300" "300-800"; do
    if [ $i = "0-100" ];then
        I="0_100"
    elif [ $i = "100-300" ];then
        I="100_300"
    else
        I="300_800"
    fi

cat <<EOF > ./imsi5.ncl
begin

dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"temp_${i}mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")

temp_${I}=f1->temp ;time*yt_ocean*xt_ocean
time=f1->time

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

T=temp_${I};time*lat*lon
dim=dimsizes(T);time*lat*lon

;-----------------------------------------------------------------------------------------
T_clim_12=clmMonTLL(T)
T_clim=new((/dim(0),dim(1),dim(2)/),"float")
T_ano=new((/dim(0),dim(1),dim(2)/),"float")

    do m =0,dim(0)/12-1
        T_clim(12*m:12*m+11,:,:)=T_clim_12(:,:,:)
    end do

T_ano=T-T_clim
copy_VarCoords(T,T_ano)
;-----------------------------------------------------------------------------------------
Tt_prime=new((/dim(0),dim(1),dim(2)/),"float")
   Tt_prime(0,:,:)=(T_ano(1,:,:)-T_ano(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Tt_prime(i,:,:)=(T_ano(i+1,:,:)-T_ano(i-1,:,:))/(2*t)   ;time 335
    end do
   Tt_prime(dim(0)-1,:,:)=(T_ano(dim(0)-1,:,:)-T_ano(dim(0)-2,:,:))/(t)   ;time 335
Tt_prime!0="time"
Tt_prime!1="yt_ocean"
Tt_prime!2="xt_ocean"
Tt_prime&yt_ocean=yt_ocean
Tt_prime&xt_ocean=xt_ocean
   print("Accomplished round T' / round t")
;-----------------------------------------------------------------------------------------
Tt_bar=new((/dim(0),dim(1),dim(2)/),"float")
   Tt_bar(0,:,:)=(T_clim(1,:,:)-T_clim(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Tt_bar(i,:,:)=(T_clim(i+1,:,:)-T_clim(i-1,:,:))/(2*t)   ;time 335
    end do
   Tt_bar(dim(0)-1,:,:)=(T_clim(dim(0)-1,:,:)-T_clim(dim(0)-2,:,:))/(t)   ;time 335
Tt_bar!0="time"
Tt_bar!1="yt_ocean"
Tt_bar!2="xt_ocean"
Tt_bar&yt_ocean=yt_ocean
Tt_bar&xt_ocean=xt_ocean
   print("Accomplished round T bar / round t")
;-----------------------------------------------------------------------------------------

system("rm -f "+dir2+"ECDA-COBALT_dT_dt_${i}_advection_199001-201712.nc")
out=addfile(    dir2+"ECDA-COBALT_dT_dt_${i}_advection_199001-201712.nc","c")
out->Tt_prime=Tt_prime
out->Tt_bar=Tt_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end
EOF

 ncl ./imsi5.ncl
 rm -f ./imsi5.ncl

done
