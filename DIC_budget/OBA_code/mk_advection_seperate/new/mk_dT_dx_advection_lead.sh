#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels # Raw data
dir3=/data/hjchoi/CMI/OBA/data/advection/new/raw
B=${dir1}/st_ocean

#for A in "1" "2" ;do
for A in "2" ;do
    for n in $(seq 0 1 49) ;do
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

T=temp;time*lat*lon
dim=dimsizes(T);time*lat*lon
;-----------------------------------------------------------------------------------------
g=addfile("${dir2}/u_"+N(${n})+"m_lead_${A}_199${A}-2017.nc","r")
u=g->u(:,:,:)
;-----------------------------------------------------------------------------------------
; Make T bar(T_clim) and T prime(T_ano)
;-----------------------------------------------------------------------------------------
T_clim_12=clmMonTLL(T)
T_clim=new((/dim(0),dim(1),dim(2)/),"float")
T_ano=calcMonAnomTLL(T,T_clim_12)

    do m =0,dim(0)/12-1
        T_clim(12*m:12*m+11,:,:)=T_clim_12(:,:,:)
    end do

;-----------------------------------------------------------------------------------------
; Make u bar(u_clim) and u prime(u_ano)
;-----------------------------------------------------------------------------------------
u_clim_12=clmMonTLL(u)
u_clim=new((/dim(0),dim(1),dim(2)/),"float")
u_ano=calcMonAnomTLL(u,u_clim_12)
    do m =0,dim(0)/12-1
        u_clim(12*m:12*m+11,:,:)=u_clim_12(:,:,:)
    end do
;-----------------------------------------------------------------------------------------
; Make u bar * T prime /dx
;-----------------------------------------------------------------------------------------
u_bar_T_prime=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_bar_T_prime(:,j,0)=-u_clim(:,j,0)*((T_ano(:,j,1)-T_ano(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_bar_T_prime(:,j,i)=-u_clim(:,j,i)*((T_ano(:,j,i+1)-T_ano(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_bar_T_prime(:,j,dim(2)-1)=-u_clim(:,j,dim(2)-1)*((T_ano(:,j,dim(2)-1)-T_ano(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 1. u bar * T prime /dx")
   print("Total CPU time: " + get_cpu_time())
   delete([/j,i/])
;-----------------------------------------------------------------------------------------
; Make u bar * T bar /dx
;-----------------------------------------------------------------------------------------
u_bar_T_bar=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_bar_T_bar(:,j,0)=-u_clim(:,j,0)*((T_clim(:,j,1)-T_clim(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_bar_T_bar(:,j,i)=-u_clim(:,j,i)*((T_clim(:,j,i+1)-T_clim(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_bar_T_bar(:,j,dim(2)-1)=-u_clim(:,j,dim(2)-1)*((T_clim(:,j,dim(2)-1)-T_clim(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 2. u bar * T bar /dx")
   print("Total CPU time: " + get_cpu_time())
   delete([/j,i/])
;-----------------------------------------------------------------------------------------
; Make u prime * T prime /dx
;-----------------------------------------------------------------------------------------
u_prime_T_prime=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_prime_T_prime(:,j,0)=-u_ano(:,j,0)*((T_ano(:,j,1)-T_ano(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_prime_T_prime(:,j,i)=-u_ano(:,j,i)*((T_ano(:,j,i+1)-T_ano(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_prime_T_prime(:,j,dim(2)-1)=-u_ano(:,j,dim(2)-1)*((T_ano(:,j,dim(2)-1)-T_ano(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 3. u prime * T prime /dx")
   print("Total CPU time: " + get_cpu_time())
   delete([/j,i/])
;-----------------------------------------------------------------------------------------
; Make u prime * T bar /dx
;-----------------------------------------------------------------------------------------
u_prime_T_bar=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     u_prime_T_bar(:,j,0)=-u_ano(:,j,0)*((T_clim(:,j,1)-T_clim(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     u_prime_T_bar(:,j,i)=-u_ano(:,j,i)*((T_clim(:,j,i+1)-T_clim(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     u_prime_T_bar(:,j,dim(2)-1)=-u_ano(:,j,dim(2)-1)*((T_clim(:,j,dim(2)-1)-T_clim(:,j,dim(2)-2))/(clat(j)*re*rad))
    end do
   print("Accomplished 4. u prime * T bar /dx")
   print("Total CPU time: " + get_cpu_time())
copy_VarCoords(T,u_bar_T_prime)
copy_VarCoords(T,u_bar_T_bar)
copy_VarCoords(T,u_prime_T_prime)
copy_VarCoords(T,u_prime_T_bar)

system("rm -f ${dir3}/LT_${A}_dT_dx_"+N(${n})+"m_advection_199${A}01-201712.nc")
out=addfile( "${dir3}/LT_${A}_dT_dx_"+N(${n})+"m_advection_199${A}01-201712.nc","c")
out->u_bar_T_prime=u_bar_T_prime
out->u_bar_T_bar=u_bar_T_bar
out->u_prime_T_prime=u_prime_T_prime
out->u_prime_T_bar=u_prime_T_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl

    done
done
