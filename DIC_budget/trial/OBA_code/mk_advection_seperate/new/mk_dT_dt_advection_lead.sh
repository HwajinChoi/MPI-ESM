#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels # Raw data
dir3=/data/hjchoi/CMI/OBA/data/advection/new/raw
B=${dir1}/st_ocean

for A in "1" "2" ;do 
    for n in $(seq 0 1 49) ;do 
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
N=asciiread("${B}",-1,"string")
f1=addfile("${dir2}/temp_"+N(${n})+"m_lead_${A}_199${A}-2017.nc","r")

temp=f1->temp(:,:,:) ;time*yt_ocean*xt_ocean
time=f1->time

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

T=temp
dim=dimsizes(T);time*lat*lon
;-----------------------------------------------------------------------------------------
T_clim_12=clmMonTLL(T)
T_clim=new((/dim(0),dim(1),dim(2)/),"float")
T_ano=calcMonAnomTLL(T,T_clim_12)
    
    do m =0,dim(0)/12-1
        T_clim(12*m:12*m+11,:,:)=T_clim_12(:,:,:)
    end do
;-----------------------------------------------------------------------------------------
Tt_prime=new((/dim(0),dim(1),dim(2)/),"float")
   Tt_prime(0,:,:)=(T_ano(1,:,:)-T_ano(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Tt_prime(i,:,:)=(T_ano(i+1,:,:)-T_ano(i-1,:,:))/(2*t)   ;time 335
    end do
   Tt_prime(dim(0)-1,:,:)=(T_ano(dim(0)-1,:,:)-T_ano(dim(0)-2,:,:))/(t)   ;time 335
   copy_VarCoords(T_clim,Tt_prime)
   print("Accomplished round T' / round t")
;-----------------------------------------------------------------------------------------
Tt_bar=new((/dim(0),dim(1),dim(2)/),"float")
   Tt_bar(0,:,:)=(T_clim(1,:,:)-T_clim(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Tt_bar(i,:,:)=(T_clim(i+1,:,:)-T_clim(i-1,:,:))/(2*t)   ;time 335
    end do
   Tt_bar(dim(0)-1,:,:)=(T_clim(dim(0)-1,:,:)-T_clim(dim(0)-2,:,:))/(t)   ;time 335
   copy_VarCoords(T_clim,Tt_bar)
   print("Accomplished round T bar / round t")
;-----------------------------------------------------------------------------------------
system("rm -f ${dir3}/LT_${A}_dT_dt_"+N(${n})+"m_advection_199${A}01-201712.nc")
out=addfile( "${dir3}/LT_${A}_dT_dt_"+N(${n})+"m_advection_199${A}01-201712.nc","c")
out->Tt_prime=Tt_prime
out->Tt_bar=Tt_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end
EOF

 ncl ./imsi4.ncl
 rm -f ./imsi4.ncl

 done
done
