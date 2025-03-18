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
g=addfile(dir1+"u_${I}m_lead_${A}_monthly_199${A}-2017.nc","r")
u=g->u
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
; Make u bar(u_clim) and u prime(u_ano)
;-----------------------------------------------------------------------------------------
u_clim_12=clmMonTLL(u)
u_clim=new((/dim(0),dim(1),dim(2)/),"float")
u_ano=new((/dim(0),dim(1),dim(2)/),"float")

    do m =0,dim(0)/12-1
        u_clim(12*m:12*m+11,:,:)=u_clim_12(:,:,:)
    end do

u_ano=u-u_clim
copy_VarCoords(u,u_ano)
;-----------------------------------------------------------------------------------------
; Make u bar * O2 prime /dx
;-----------------------------------------------------------------------------------------
u_bar_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_bar_O_prime(:,j,0)=-u_clim(:,j,0)*((O_ano(:,j,1)-O_ano(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_bar_O_prime(:,j,i)=-u_clim(:,j,i)*((O_ano(:,j,i+1)-O_ano(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_bar_O_prime(:,j,dim(2)-1)=-u_clim(:,j,dim(2)-1)*((O_ano(:,j,dim(2)-1)-O_ano(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 1. u bar * O2 prime /dx")
   print("Total CPU time: " + get_cpu_time())
   delete([/j,i/])
;-----------------------------------------------------------------------------------------
; Make u bar * O2 bar /dx
;-----------------------------------------------------------------------------------------
u_bar_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_bar_O_bar(:,j,0)=-u_clim(:,j,0)*((O_clim(:,j,1)-O_clim(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_bar_O_bar(:,j,i)=-u_clim(:,j,i)*((O_clim(:,j,i+1)-O_clim(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_bar_O_bar(:,j,dim(2)-1)=-u_clim(:,j,dim(2)-1)*((O_clim(:,j,dim(2)-1)-O_clim(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 2. u bar * O2 bar /dx")
   print("Total CPU time: " + get_cpu_time())
   delete([/j,i/])
;-----------------------------------------------------------------------------------------
; Make u prime * O2 prime /dx
;-----------------------------------------------------------------------------------------
u_prime_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_prime_O_prime(:,j,0)=-u_ano(:,j,0)*((O_ano(:,j,1)-O_ano(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_prime_O_prime(:,j,i)=-u_ano(:,j,i)*((O_ano(:,j,i+1)-O_ano(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_prime_O_prime(:,j,dim(2)-1)=-u_ano(:,j,dim(2)-1)*((O_ano(:,j,dim(2)-1)-O_ano(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 3. u prime * O2 prime /dx")
   print("Total CPU time: " + get_cpu_time())
   delete([/j,i/])
;-----------------------------------------------------------------------------------------
; Make u prime * O2 bar /dx
;-----------------------------------------------------------------------------------------
u_prime_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_prime_O_bar(:,j,0)=-u_ano(:,j,0)*((O_clim(:,j,1)-O_clim(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_prime_O_bar(:,j,i)=-u_ano(:,j,i)*((O_clim(:,j,i+1)-O_clim(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_prime_O_bar(:,j,dim(2)-1)=-u_ano(:,j,dim(2)-1)*((O_clim(:,j,dim(2)-1)-O_clim(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 4. u prime * O2 bar /dx")
   print("Total CPU time: " + get_cpu_time())
copy_VarCoords(O,u_bar_O_prime)
copy_VarCoords(O,u_bar_O_bar)
copy_VarCoords(O,u_prime_O_prime)
copy_VarCoords(O,u_prime_O_bar)

system("rm -f "+dir2+"LT_${A}_dO_dx_${i}_advection_199${A}01-201712.nc")
out=addfile(    dir2+"LT_${A}_dO_dx_${i}_advection_199${A}01-201712.nc","c")
out->u_bar_O_prime=u_bar_O_prime
out->u_bar_O_bar=u_bar_O_bar
out->u_prime_O_prime=u_prime_O_prime
out->u_prime_O_bar=u_prime_O_bar
;out->lat=lat
;out->lon=lon

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl

 done
done
