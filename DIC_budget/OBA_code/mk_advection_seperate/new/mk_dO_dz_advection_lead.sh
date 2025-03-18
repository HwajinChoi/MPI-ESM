#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels # Raw data
dir3=/data/hjchoi/CMI/OBA/data/advection/new/raw
B=${dir1}/st_ocean
C=${dir2}/sw_ocean_lead
#for A in "1" "2" ;do
for A in "2" ;do
 for n in $(seq 0 1 33) ;do 

 if [ $n = 0 ] ; then
    ncl ./mk_dO_dz_advection_surface_layer_lead_${A}.ncl
 elif [ $n = 33 ] ; then
    ncl ./mk_dO_dz_advection_bottom_layer_lead_${A}.ncl
 else
 cat <<EOF > ./mk_dO_dz_advection_middle_layer_lead_${A}.ncl
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
f1=addfile("${dir2}/o2_"+N(${n}-1)+"m_lead_${A}_199${A}-2017.nc","r")
f2=addfile("${dir2}/o2_"+N(${n}+1)+"m_lead_${A}_199${A}-2017.nc","r")
o2_1=f1->o2(:,:,:) ;time*yt_ocean*xt_ocean
o2_2=f2->o2(:,:,:) ;time*yt_ocean*xt_ocean

M=asciiread("${C}",-1,"string")
k1=addfile("${dir2}/wt_"+M(${n})+"m_lead_${A}_199${A}-2017.nc","r")
k2=addfile("${dir2}/wt_"+M(${n}+1)+"m_lead_${A}_199${A}-2017.nc","r")
wt_1=k1->wt(:,:,:)
wt_2=k2->wt(:,:,:)

dim=dimsizes(o2_1);time*lat*lon
O=new((/dim(0),dim(1),dim(2),2/),"float")
O(:,:,:,0)=o2_1
O(:,:,:,1)=o2_2
O!3="depth"
O=O*1000000 ; For change unit micro mol/kg
O@units="micro mol/kg"

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
; Make O2 bar(O_clim) and O2 prime(O_ano)
;-----------------------------------------------------------------------------------------
O_clim_12=clmMonTLLL(O);time(12)*yt_ocean*xt_ocean*depth
O_clim=new((/dim(0),dim(1),dim(2),2/),"float")
    do m =0,dim(0)/12-1
        O_clim(12*m:12*m+11,:,:,:)=O_clim_12(:,:,:,:)
    end do
O_ano=calcMonAnomTLLL(O,O_clim_12)
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
; Make w bar * O2 prime /dz
;-----------------------------------------------------------------------------------------
NN=stringtofloat(N)
w_bar_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
    w_bar_O_prime(:,:,:)=-w_clim(:,:,:)*((O_ano(:,:,:,0)-O_ano(:,:,:,1))/(NN(${n}+1)-NN(${n}-1)))
   print("Accomplished 1. w bar * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w bar * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_bar_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
    w_bar_O_bar(:,:,:)=-w_clim(:,:,:)*((O_clim(:,:,:,0)-O_clim(:,:,:,1))/(NN(${n}+1)-NN(${n}-1)))
   print("Accomplished 2. w bar * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 prime /dz
;-----------------------------------------------------------------------------------------
w_prime_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
    w_prime_O_prime(:,:,:)=-w_ano(:,:,:)*((O_ano(:,:,:,0)-O_ano(:,:,:,1))/(NN(${n}+1)-NN(${n}-1)))
   print("Accomplished 3. w prime * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_prime_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
    w_prime_O_bar(:,:,:)=-w_ano(:,:,:)*((O_clim(:,:,:,0)-O_clim(:,:,:,1))/(NN(${n}+1)-NN(${n}-1)))
   print("Accomplished 4. w prime * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())

    copy_VarCoords(w,w_bar_O_prime)
    copy_VarCoords(w,w_bar_O_bar)
    copy_VarCoords(w,w_prime_O_prime)
    copy_VarCoords(w,w_prime_O_bar)
system("rm -f ${dir3}/LT_${A}_dO_dz_"+N(${n})+"m_advection_199${A}01-201712.nc")
out=addfile( "${dir3}/LT_${A}_dO_dz_"+N(${n})+"m_advection_199${A}01-201712.nc","c")
out->w_bar_O_prime=w_bar_O_prime
out->w_bar_O_bar=w_bar_O_bar
out->w_prime_O_prime=w_prime_O_prime
out->w_prime_O_bar=w_prime_O_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time
end
EOF

 ncl   ./mk_dO_dz_advection_middle_layer_lead_${A}.ncl
 rm -f ./mk_dO_dz_advection_middle_layer_lead_${A}.ncl
 fi
 done
done
