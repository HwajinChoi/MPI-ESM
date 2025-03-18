#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels # Raw data
dir3=/data/hjchoi/CMI/OBA/data/advection/cal_mk_annual_data/raw
B=${dir1}/st_ocean

for n in $(seq 0 1 49) ;do
cat <<EOF > ./imsi.ncl
begin
dir0="/data/hjchoi/CMI/data/COBALT/"
;-------------------------Constant-------------------------
t=60*60*24*30*12
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
N=asciiread("${B}",-1,"string")
f1=addfile("${dir2}/temp_"+N(${n})+"m_COBALT.199001-201712.nc","r")
temp=f1->temp(:,0,:,:) ;time*yt_ocean*xt_ocean

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5
g=addfile(dir0+"sst_ATMassim_10NS_100err_WOA_0.1_2nd.1990-2017.nc","r")
time=g->time

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

T=temp;time*lat*lon
T_annual=month_to_annual(T,1)
dim=dimsizes(T_annual);time*lat*lon
T_clim=dim_avg_n_Wrap(T_annual,0)
;-----------------------------------------------------------------------------------------
T_ano=new((/dim(0),dim(1),dim(2)/),"float")
    do m =0,dim(0)-1
        T_ano(m,:,:)=T_annual(m,:,:)-T_clim
    end do
copy_VarCoords(T_annual,T_ano)
T_ano!0="time"
T_ano&time=time
out=addfile("./T_ano_annual_1990-2017.nc","c")
out->time=time
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->T_ano=T_ano
exit
   
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
system("rm -f ${dir3}/ECDA-COBALT_dT_dt_"+N(${n})+"m_advection_199001-201712.nc")
out=addfile( "${dir3}/ECDA-COBALT_dT_dt_"+N(${n})+"m_advection_199001-201712.nc","c")
out->Tt_prime=Tt_prime
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end
EOF

 ncl ./imsi.ncl
 rm -f ./imsi.ncl
 exit
 done

