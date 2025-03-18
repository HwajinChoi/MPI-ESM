#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data/raw
dir2=/data/hjchoi/CMI/OBA/data/raw/spilt_levels # Raw data
dir3=/data/hjchoi/CMI/OBA/data/advection/new/raw
B=${dir1}/st_ocean
C=${dir1}/sw_ocean

for n in $(seq 0 1 33) ;do 
 if [ $n = 0 ] ; then
    ncl ./mk_dT_dz_advection_surface_layer.ncl
 elif [ $n = 33 ] ; then
    ncl ./mk_dT_dz_advection_bottom_layer.ncl
 else
 cat <<EOF > ./mk_dT_dz_advection_middle_layer.ncl
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
f1=addfile("${dir2}/temp_"+N(${n}-1)+"m_COBALT.199001-201712.nc","r")
f2=addfile("${dir2}/temp_"+N(${n}+1)+"m_COBALT.199001-201712.nc","r")
temp_1=f1->temp(:,0,:,:) ;time*yt_ocean*xt_ocean
temp_2=f2->temp(:,0,:,:) ;time*yt_ocean*xt_ocean

M=asciiread("${C}",-1,"string")
k1=addfile("${dir2}/wt_"+M(${n})+"m_COBALT.199001-201712.nc","r")
k2=addfile("${dir2}/wt_"+M(${n}+1)+"m_COBALT.199001-201712.nc","r")
wt_1=k1->wt(:,0,:,:)
wt_2=k2->wt(:,0,:,:)

dim=dimsizes(temp_1);time*lat*lon
T=new((/dim(0),dim(1),dim(2),2/),"float")
T(:,:,:,0)=temp_1
T(:,:,:,1)=temp_2
T!3="depth"

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5
time=f1->time
clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

w=(wt_2+wt_1)*0.5
copy_VarCoords(wt_2,w)
;-----------------------------------------------------------------------------------------
; Make T bar(T_clim) and T prime(T_ano)
;-----------------------------------------------------------------------------------------
T_clim_12=clmMonTLLL(T);time(12)*yt_ocean*xt_ocean*depth
T_clim=new((/dim(0),dim(1),dim(2),2/),"float")
    do m =0,dim(0)/12-1
        T_clim(12*m:12*m+11,:,:,:)=T_clim_12(:,:,:,:)
    end do
T_ano=calcMonAnomTLLL(T,T_clim_12)
;-----------------------------------------------------------------------------------------
; Make w bar(w_clim) and w prime(w_ano)
;-----------------------------------------------------------------------------------------
w_clim_12=clmMonTLL(w)
w_clim=new((/dim(0),dim(1),dim(2)/),"float")
    do m =0,dim(0)/12-1
        w_clim(12*m:12*m+11,:,:)=w_clim_12(:,:,:);time*lat*lon*depth
    end do
w_ano=calcMonAnomTLL(w,w_clim_12)
;-----------------------------------------------------------------------------------------
; Make w bar * T prime /dz
;-----------------------------------------------------------------------------------------
NN=stringtofloat(N)
w_bar_T_prime=new((/dim(0),dim(1),dim(2)/),"float")
    w_bar_T_prime(:,:,:)=-w_clim(:,:,:)*((T_ano(:,:,:,0)-T_ano(:,:,:,1))/((NN(${n}+1)-NN(${n}-1))))
   print("Accomplished 1. w bar * T prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w bar * T bar /dz
;-----------------------------------------------------------------------------------------
w_bar_T_bar=new((/dim(0),dim(1),dim(2)/),"float")
    w_bar_T_bar(:,:,:)=-w_clim(:,:,:)*((T_clim(:,:,:,0)-T_clim(:,:,:,1))/((NN(${n}+1)-NN(${n}-1))))
   print("Accomplished 2. w bar * T bar / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * T prime /dz
;-----------------------------------------------------------------------------------------
w_prime_T_prime=new((/dim(0),dim(1),dim(2)/),"float")
    w_prime_T_prime(:,:,:)=-w_ano(:,:,:)*((T_ano(:,:,:,0)-T_ano(:,:,:,1))/((NN(${n}+1)-NN(${n}-1))))
   print("Accomplished 3. w prime * T prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * T bar /dz
;-----------------------------------------------------------------------------------------
w_prime_T_bar=new((/dim(0),dim(1),dim(2)/),"float")
    w_prime_T_bar(:,:,:)=-w_ano(:,:,:)*((T_clim(:,:,:,0)-T_clim(:,:,:,1))/((NN(${n}+1)-NN(${n}-1))))
   print("Accomplished 4. w prime * T bar / dz")
   print("Total CPU time: " + get_cpu_time())

    copy_VarCoords(w,w_bar_T_prime)
    copy_VarCoords(w,w_bar_T_bar)
    copy_VarCoords(w,w_prime_T_prime)
    copy_VarCoords(w,w_prime_T_bar)
system("rm -f ${dir3}/ECDA-COBALT_dT_dz_"+N(${n})+"m_advection_199001-201712.nc")
out=addfile( "${dir3}/ECDA-COBALT_dT_dz_"+N(${n})+"m_advection_199001-201712.nc","c")
out->w_bar_T_prime=w_bar_T_prime
out->w_bar_T_bar=w_bar_T_bar
out->w_prime_T_prime=w_prime_T_prime
out->w_prime_T_bar=w_prime_T_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time
end
EOF

 ncl   ./mk_dT_dz_advection_middle_layer.ncl
 rm -f ./mk_dT_dz_advection_middle_layer.ncl
 fi
done
