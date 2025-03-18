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
h=addfile(dir1+"v_${I}m_lead_${A}_monthly_199${A}-2017.nc","r")
v=h->v
;-----------------------------------------------------------------------------------------
; Make T bar(T_clim) and T prime(T_ano)
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
; Make v bar * T prime /dy
;-----------------------------------------------------------------------------------------
v_bar_T_prime=new((/dim(0),dim(1),dim(2)/),"float")
   v_bar_T_prime(:,0,:)=-v_clim(:,0,:)*((T_ano(:,1,:)-T_ano(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_bar_T_prime(:,i,:)=-v_clim(:,i,:)*((T_ano(:,i+1,:)-T_ano(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_bar_T_prime(:,dim(1)-1,:)=-v_clim(:,dim(1)-1,:)*((T_ano(:,dim(1)-1,:)-T_ano(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 1. v bar * T prime / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])
;-----------------------------------------------------------------------------------------
; Make v bar * T bar /dy
;-----------------------------------------------------------------------------------------
v_bar_T_bar=new((/dim(0),dim(1),dim(2)/),"float")
   v_bar_T_bar(:,0,:)=-v_clim(:,0,:)*((T_clim(:,1,:)-T_clim(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_bar_T_bar(:,i,:)=-v_clim(:,i,:)*((T_clim(:,i+1,:)-T_clim(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_bar_T_bar(:,dim(1)-1,:)=-v_clim(:,dim(1)-1,:)*((T_clim(:,dim(1)-1,:)-T_clim(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 2. v bar * T bar / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])   
;-----------------------------------------------------------------------------------------
; Make v prime * T prime /dy
;-----------------------------------------------------------------------------------------
v_prime_T_prime=new((/dim(0),dim(1),dim(2)/),"float")
   v_prime_T_prime(:,0,:)=-v_ano(:,0,:)*((T_ano(:,1,:)-T_ano(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_prime_T_prime(:,i,:)=-v_ano(:,i,:)*((T_ano(:,i+1,:)-T_ano(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_prime_T_prime(:,dim(1)-1,:)=-v_ano(:,dim(1)-1,:)*((T_ano(:,dim(1)-1,:)-T_ano(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 3. v prime * T prime / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])
;-----------------------------------------------------------------------------------------
; Make v prime * T bar /dy
;-----------------------------------------------------------------------------------------
v_prime_T_bar=new((/dim(0),dim(1),dim(2)/),"float")
   v_prime_T_bar(:,0,:)=-v_ano(:,0,:)*((T_clim(:,1,:)-T_clim(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    v_prime_T_bar(:,i,:)=-v_ano(:,i,:)*((T_clim(:,i+1,:)-T_clim(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   v_prime_T_bar(:,dim(1)-1,:)=-v_ano(:,dim(1)-1,:)*((T_clim(:,dim(1)-1,:)-T_clim(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished 4. v prime * T bar / dy")
   print("Total CPU time: " + get_cpu_time())
   delete([/i/])

    copy_VarCoords(T,v_bar_T_prime)
    copy_VarCoords(T,v_bar_T_bar)
    copy_VarCoords(T,v_prime_T_prime)
    copy_VarCoords(T,v_prime_T_bar)


system("rm -f "+dir2+"LT_${A}_dT_dy_${i}_advection_199${A}01-201712.nc")
out=addfile(    dir2+"LT_${A}_dT_dy_${i}_advection_199${A}01-201712.nc","c")
out->v_bar_T_prime=v_bar_T_prime
out->v_bar_T_bar=v_bar_T_bar
out->v_prime_T_prime=v_prime_T_prime
out->v_prime_T_bar=v_prime_T_bar
;out->lat=lat
;out->lon=lon
;out->time=time

end
EOF

 ncl ./imsi2.ncl
 rm -f ./imsi2.ncl

 done
done
