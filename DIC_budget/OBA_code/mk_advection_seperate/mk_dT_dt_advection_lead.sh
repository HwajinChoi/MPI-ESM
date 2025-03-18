#!/bin/bash
for A in "1" "2";do
 for i in "0-100" "100-300" "300-800"; do
    if [ $i = "0-100" ];then
        I="0_100"
    elif [ $i = "100-300" ];then
        I="100_300"
    else
        I="300_800"
    fi

cat <<EOF > ./imsi4.ncl
begin

dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"temp_${I}m_lead_${A}_monthly_199${A}-2017.nc","r")

temp_${I}=dble2flt(f1->temp) ;time*lat*lon
time=f1->time

lat=f1->lat;-89.5 - 89.5
lon=f1->lon;0-359
lat=f1->lat;-89.5 - 89.5

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
Tt_prime!1="lat"
Tt_prime!2="lon"
Tt_prime&lat=lat
Tt_prime&lon=lon
   print("Accomplished round T' / round t")
;-----------------------------------------------------------------------------------------
Tt_bar=new((/dim(0),dim(1),dim(2)/),"float")
   Tt_bar(0,:,:)=(T_clim(1,:,:)-T_clim(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Tt_bar(i,:,:)=(T_clim(i+1,:,:)-T_clim(i-1,:,:))/(2*t)   ;time 335
    end do
   Tt_bar(dim(0)-1,:,:)=(T_clim(dim(0)-1,:,:)-T_clim(dim(0)-2,:,:))/(t)   ;time 335
Tt_bar!0="time"
Tt_bar!1="lat"
Tt_bar!2="lon"
Tt_bar&lat=lat
Tt_bar&lon=lon
   print("Accomplished round T bar / round t")
;-----------------------------------------------------------------------------------------

system("rm -f "+dir2+"LT_${A}_dT_dt_${i}_advection_199${A}01-201712.nc")
out=addfile(    dir2+"LT_${A}_dT_dt_${i}_advection_199${A}01-201712.nc","c")
out->Tt_prime=Tt_prime
out->Tt_bar=Tt_bar
out->lat=lat
out->lon=lon
out->time=time

end
EOF

 ncl ./imsi4.ncl
 rm -f ./imsi4.ncl

 done
done
