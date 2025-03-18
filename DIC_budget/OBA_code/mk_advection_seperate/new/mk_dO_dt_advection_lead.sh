#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels # Raw data
dir3=/data/hjchoi/CMI/OBA/data/advection/new
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
f1=addfile("${dir2}/o2_"+N(${n})+"m_lead_${A}_199${A}-2017.nc","r")

o2=f1->o2(:,:,:) ;time*yt_ocean*xt_ocean
time=f1->time
o2=o2*1000000 ; For change unit micro mol/kg
o2@units="micro mol/kg"

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

O=o2
dim=dimsizes(O);time*lat*lon
;-----------------------------------------------------------------------------------------
O_clim_12=clmMonTLL(O)
O_clim=new((/dim(0),dim(1),dim(2)/),"float")
O_ano=calcMonAnomTLL(O,O_clim_12)
    
    do m =0,dim(0)/12-1
        O_clim(12*m:12*m+11,:,:)=O_clim_12(:,:,:)
    end do
;-----------------------------------------------------------------------------------------
Ot_prime=new((/dim(0),dim(1),dim(2)/),"float")
   Ot_prime(0,:,:)=(O_ano(1,:,:)-O_ano(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Ot_prime(i,:,:)=(O_ano(i+1,:,:)-O_ano(i-1,:,:))/(2*t)   ;time 335
    end do
   Ot_prime(dim(0)-1,:,:)=(O_ano(dim(0)-1,:,:)-O_ano(dim(0)-2,:,:))/(t)   ;time 335
   copy_VarCoords(O_clim,Ot_prime)
   print("Accomplished round O' / round t")
;-----------------------------------------------------------------------------------------
Ot_bar=new((/dim(0),dim(1),dim(2)/),"float")
   Ot_bar(0,:,:)=(O_clim(1,:,:)-O_clim(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Ot_bar(i,:,:)=(O_clim(i+1,:,:)-O_clim(i-1,:,:))/(2*t)   ;time 335
    end do
   Ot_bar(dim(0)-1,:,:)=(O_clim(dim(0)-1,:,:)-O_clim(dim(0)-2,:,:))/(t)   ;time 335
   copy_VarCoords(O_clim,Ot_bar)
   print("Accomplished round O bar / round t")
;-----------------------------------------------------------------------------------------
system("rm -f ${dir3}/LT_${A}_dO_dt_"+N(${n})+"m_advection_199${A}01-201712.nc")
out=addfile( "${dir3}/LT_${A}_dO_dt_"+N(${n})+"m_advection_199${A}01-201712.nc","c")
out->Ot_prime=Ot_prime
out->Ot_bar=Ot_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end
EOF

 ncl ./imsi4.ncl
 rm -f ./imsi4.ncl

 done
done
