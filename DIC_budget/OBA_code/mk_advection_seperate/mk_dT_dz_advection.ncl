begin

dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"temp_0-100mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
f2=addfile(dir1+"temp_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
f3=addfile(dir1+"temp_300-800mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")

temp_0_100=f1->temp ;time*yt_ocean*xt_ocean
temp_100_300=f2->temp ;time*yt_ocean*xt_ocean
temp_300_800=f3->temp ;time*yt_ocean*xt_ocean

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean;-89.5 - 89.5
time=f1->time

k1=addfile(dir1+"wt_0-100mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
k2=addfile(dir1+"wt_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
k3=addfile(dir1+"wt_300-800mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
wt_0_100=k1->wt
wt_100_300=k2->wt
wt_300_800=k3->wt

clat=cos(rad*lat)
clat := dble2flt(clat)
copy_VarCoords(lat,clat)

dim=dimsizes(temp_0_100);time*lat*lon
;----------Make vertical velocity (w)----------------
w=new((/dim(0),dim(1),dim(2),3/),"float")
w(:,:,:,0)=(wt_100_300(:,:,:)-wt_0_100(:,:,:))*0.5
w(:,:,:,1)=(wt_300_800(:,:,:)-wt_100_300(:,:,:))*0.5
w(:,:,:,2)=wt_300_800*0.5
copy_VarCoords(wt_100_300,w(:,:,:,0))
w!3="depth"
;---------Merge T--------------
T=new((/dim(0),dim(1),dim(2),3/),"float")
T(:,:,:,0)=temp_0_100
T(:,:,:,1)=temp_100_300
T(:,:,:,2)=temp_300_800
T!3="depth"
;-----------------------------------------------------------------------------------------
; Make O2 bar(T_clim) and O2 prime(T_ano)
;-----------------------------------------------------------------------------------------
T_clim_12=clmMonTLLL(T)
T_clim=new((/dim(0),dim(1),dim(2),3/),"float")
T_ano=new((/dim(0),dim(1),dim(2),3/),"float")
    do m =0,dim(0)/12-1
        T_clim(12*m:12*m+11,:,:,:)=T_clim_12(:,:,:,:)
    end do
T_ano=T-T_clim
copy_VarCoords(T,T_ano)
;-----------------------------------------------------------------------------------------
; Make w bar(w_clim) and w prime(w_ano)
;-----------------------------------------------------------------------------------------
w_clim_12=clmMonTLLL(w)
w_clim=new((/dim(0),dim(1),dim(2),3/),"float")
w_ano=new((/dim(0),dim(1),dim(2),3/),"float")
    do m =0,dim(0)/12-1
        w_clim(12*m:12*m+11,:,:,:)=w_clim_12(:,:,:,:);time*lat*lon*depth
    end do
w_ano=w-w_clim
copy_VarCoords(w,w_ano)
;-----------------------------------------------------------------------------------------
; Make w bar * O2 prime /dz
;-----------------------------------------------------------------------------------------
w_bar_T_prime=new((/dim(0),dim(1),dim(2),3/),"float")
    w_bar_T_prime(:,:,:,0)=-w_clim(:,:,:,0)*((T_ano(:,:,:,1)-T_ano(:,:,:,0))/200)
    w_bar_T_prime(:,:,:,1)=-w_clim(:,:,:,1)*((T_ano(:,:,:,2)-T_ano(:,:,:,0))/1400)
    w_bar_T_prime(:,:,:,2)=-w_clim(:,:,:,2)*((T_ano(:,:,:,2)-T_ano(:,:,:,1))/500)
   print("Accomplished 1. w bar * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w bar * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_bar_T_bar=new((/dim(0),dim(1),dim(2),3/),"float")
    w_bar_T_bar(:,:,:,0)=-w_clim(:,:,:,0)*((T_clim(:,:,:,1)-T_clim(:,:,:,0))/200)
    w_bar_T_bar(:,:,:,1)=-w_clim(:,:,:,1)*((T_clim(:,:,:,2)-T_clim(:,:,:,0))/1400)
    w_bar_T_bar(:,:,:,2)=-w_clim(:,:,:,2)*((T_clim(:,:,:,2)-T_clim(:,:,:,1))/500)
   print("Accomplished 2. w bar * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 prime /dz
;-----------------------------------------------------------------------------------------
w_prime_T_prime=new((/dim(0),dim(1),dim(2),3/),"float")
    w_prime_T_prime(:,:,:,0)=-w_ano(:,:,:,0)*((T_ano(:,:,:,1)-T_ano(:,:,:,0))/200)
    w_prime_T_prime(:,:,:,1)=-w_ano(:,:,:,1)*((T_ano(:,:,:,2)-T_ano(:,:,:,0))/1400)
    w_prime_T_prime(:,:,:,2)=-w_ano(:,:,:,2)*((T_ano(:,:,:,2)-T_ano(:,:,:,1))/500)
   print("Accomplished 3. w prime * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_prime_T_bar=new((/dim(0),dim(1),dim(2),3/),"float")
    w_prime_T_bar(:,:,:,0)=-w_ano(:,:,:,0)*((T_clim(:,:,:,1)-T_clim(:,:,:,0))/200)
    w_prime_T_bar(:,:,:,1)=-w_ano(:,:,:,1)*((T_clim(:,:,:,2)-T_clim(:,:,:,0))/1400)
    w_prime_T_bar(:,:,:,2)=-w_ano(:,:,:,2)*((T_clim(:,:,:,2)-T_clim(:,:,:,1))/500)
   print("Accomplished 4. w prime * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
    copy_VarCoords(T,w_bar_T_prime)
    copy_VarCoords(T,w_bar_T_bar)
    copy_VarCoords(T,w_prime_T_prime)
    copy_VarCoords(T,w_prime_T_bar)

system("rm -f "+dir2+"ECDA-COBALT_dT_dz_all_depth_advection_199001-201712.nc")
out=addfile(    dir2+"ECDA-COBALT_dT_dz_all_depth_advection_199001-201712.nc","c")
out->w_bar_T_prime=w_bar_T_prime
out->w_bar_T_bar=w_bar_T_bar
out->w_prime_T_prime=w_prime_T_prime
out->w_prime_T_bar=w_prime_T_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end

