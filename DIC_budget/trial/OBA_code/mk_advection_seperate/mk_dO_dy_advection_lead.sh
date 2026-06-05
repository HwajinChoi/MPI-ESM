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

cat <<EOF > ./imsi2.ncl
begin

dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"o2_${I}m_lead_${A}_monthly_199${A}-2017.nc","r")

o2_${I}=dble2flt(f1->o2) ;time*lat*lon
time=f1->time
o2_${I}=o2_${I}*1000000 ; For change unit micro mol/kg
o2_${I}@units="micro mol/kg"

lat=f1->lat;-89.5 - 89.5
lon=f1->lon;0-359
lat=f1->lat;-89.5 - 89.5

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

O=o2_${I};time*lat*lon
dim=dimsizes(O);time*lat*lon
;-----------------------------------------------------------------------------------------
h=addfile(dir1+"v_${I}m_lead_${A}_monthly_199${A}-2017.nc","r")
v=h->v
;-----------------------------------------------------------------------------------------
; Make O2 bar(O_clim) and O2 prime(O_ano)
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
; Make v bar(v_clim) and v prime(v_ano)
;-----------------------------------------------------------------------------------------
v_clim_12=clmMonTLL(v)
v_clim=new((/dim(0),dim(1),dim(2)/),"float")
v_ano=new((/dim(0),dim(1),dim(2)/),"float")
    do m =0,dim(0)/12-1
        v_clim(12*m:12*m+11,:,:)=v_clim_12(:,:,:)
    end do
v_ano=v-v_clim
copy_VarCoords(v,v_ano)
;-----------------------------------------------------------------------------------------
; Make v bar * O2 prime /dy
;-----------------------------------------------------------------------------------------
v_bar_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
   v_bar_O_prime(:,0,:)=-v_clim(:,0,:)*((O_ano(:,1,:)-O_ano(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_bar_O_prime(:,i,:)=-v_clim(:,i,:)*((O_ano(:,i+1,:)-O_ano(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_bar_O_prime(:,dim(1)-1,:)=-v_clim(:,dim(1)-1,:)*((O_ano(:,dim(1)-1,:)-O_ano(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 1. v bar * O2 prime / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])
;-----------------------------------------------------------------------------------------
; Make v bar * O2 bar /dy
;-----------------------------------------------------------------------------------------
v_bar_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
   v_bar_O_bar(:,0,:)=-v_clim(:,0,:)*((O_clim(:,1,:)-O_clim(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_bar_O_bar(:,i,:)=-v_clim(:,i,:)*((O_clim(:,i+1,:)-O_clim(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_bar_O_bar(:,dim(1)-1,:)=-v_clim(:,dim(1)-1,:)*((O_clim(:,dim(1)-1,:)-O_clim(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 2. v bar * O2 bar / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])   
;-----------------------------------------------------------------------------------------
; Make v prime * O2 prime /dy
;-----------------------------------------------------------------------------------------
v_prime_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
   v_prime_O_prime(:,0,:)=-v_ano(:,0,:)*((O_ano(:,1,:)-O_ano(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_prime_O_prime(:,i,:)=-v_ano(:,i,:)*((O_ano(:,i+1,:)-O_ano(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_prime_O_prime(:,dim(1)-1,:)=-v_ano(:,dim(1)-1,:)*((O_ano(:,dim(1)-1,:)-O_ano(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 3. v prime * O2 prime / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])
;-----------------------------------------------------------------------------------------
; Make v prime * O2 bar /dy
;-----------------------------------------------------------------------------------------
v_prime_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
   v_prime_O_bar(:,0,:)=-v_ano(:,0,:)*((O_clim(:,1,:)-O_clim(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_prime_O_bar(:,i,:)=-v_ano(:,i,:)*((O_clim(:,i+1,:)-O_clim(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_prime_O_bar(:,dim(1)-1,:)=-v_ano(:,dim(1)-1,:)*((O_clim(:,dim(1)-1,:)-O_clim(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 4. v prime * O2 bar / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])

    copy_VarCoords(O,v_bar_O_prime)
    copy_VarCoords(O,v_bar_O_bar)
    copy_VarCoords(O,v_prime_O_prime)
    copy_VarCoords(O,v_prime_O_bar)


system("rm -f "+dir2+"LT_${A}_dO_dy_${i}_advection_199${A}01-201712.nc")
out=addfile(    dir2+"LT_${A}_dO_dy_${i}_advection_199${A}01-201712.nc","c")
out->v_bar_O_prime=v_bar_O_prime
out->v_bar_O_bar=v_bar_O_bar
out->v_prime_O_prime=v_prime_O_prime
out->v_prime_O_bar=v_prime_O_bar
;out->lat=lat
;out->lon=lon
;out->time=time

end
EOF

 ncl ./imsi2.ncl
 rm -f ./imsi2.ncl

 done
done
