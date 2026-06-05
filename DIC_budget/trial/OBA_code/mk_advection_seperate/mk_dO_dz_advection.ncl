begin
dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"o2_0-100mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
f2=addfile(dir1+"o2_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
f3=addfile(dir1+"o2_300-800mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")

o2_0_100=f1->o2 ;time*yt_ocean*xt_ocean
o2_100_300=f2->o2 ;time*yt_ocean*xt_ocean
o2_300_800=f3->o2 ;time*yt_ocean*xt_ocean
o2_0_100=o2_0_100*1000000 ; For change unit micro mol/kg
o2_100_300=o2_100_300*1000000
o2_300_800=o2_300_800*1000000
o2_0_100@units="micro mol/kg"
o2_100_300@units="micro mol/kg"
o2_300_800@units="micro mol/kg"

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

dim=dimsizes(o2_0_100);time*lat*lon
;----------Make vertical velocity (w)----------------
w=new((/dim(0),dim(1),dim(2),3/),"float");time(month)*yt_ocean*xt_ocean*depth
w(:,:,:,0)=(wt_100_300(:,:,:)+wt_0_100(:,:,:))*0.5
w(:,:,:,1)=(wt_300_800(:,:,:)+wt_100_300(:,:,:))*0.5
w(:,:,:,2)=wt_300_800*0.5
copy_VarCoords(wt_100_300,w(:,:,:,0))
w!3="depth"
;---------Merge O2--------------
O=new((/dim(0),dim(1),dim(2),3/),"float")
O(:,:,:,0)=o2_0_100
O(:,:,:,1)=o2_100_300
O(:,:,:,2)=o2_300_800
O!3="depth"
;-----------------------------------------------------------------------------------------
; Make O2 bar(O_clim) and O2 prime(O_ano)
;-----------------------------------------------------------------------------------------
O_clim_12=clmMonTLLL(O);time(12)*yt_ocean*xt_ocean*depth
printVarSummary(O)
printVarSummary(O_clim_12)
    exit
O_clim=new((/dim(0),dim(1),dim(2),3/),"float")
O_ano=new((/dim(0),dim(1),dim(2),3/),"float")
    do m =0,dim(0)/12-1
        O_clim(12*m:12*m+11,:,:,:)=O_clim_12(:,:,:,:)
    end do
O_ano=O-O_clim
copy_VarCoords(O,O_ano)
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
w_bar_O_prime=new((/dim(0),dim(1),dim(2),3/),"float")
    w_bar_O_prime(:,:,:,0)=-w_clim(:,:,:,0)*((O_ano(:,:,:,1)-O_ano(:,:,:,0))/200)
    w_bar_O_prime(:,:,:,1)=-w_clim(:,:,:,1)*((O_ano(:,:,:,2)-O_ano(:,:,:,0))/1400)
    w_bar_O_prime(:,:,:,2)=-w_clim(:,:,:,2)*((O_ano(:,:,:,2)-O_ano(:,:,:,1))/500)
   print("Accomplished 1. w bar * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w bar * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_bar_O_bar=new((/dim(0),dim(1),dim(2),3/),"float")
    w_bar_O_bar(:,:,:,0)=-w_clim(:,:,:,0)*((O_clim(:,:,:,1)-O_clim(:,:,:,0))/200)
    w_bar_O_bar(:,:,:,1)=-w_clim(:,:,:,1)*((O_clim(:,:,:,2)-O_clim(:,:,:,0))/1400)
    w_bar_O_bar(:,:,:,2)=-w_clim(:,:,:,2)*((O_clim(:,:,:,2)-O_clim(:,:,:,1))/500)
   print("Accomplished 2. w bar * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 prime /dz
;-----------------------------------------------------------------------------------------
w_prime_O_prime=new((/dim(0),dim(1),dim(2),3/),"float")
    w_prime_O_prime(:,:,:,0)=-w_ano(:,:,:,0)*((O_ano(:,:,:,1)-O_ano(:,:,:,0))/200)
    w_prime_O_prime(:,:,:,1)=-w_ano(:,:,:,1)*((O_ano(:,:,:,2)-O_ano(:,:,:,0))/1400)
    w_prime_O_prime(:,:,:,2)=-w_ano(:,:,:,2)*((O_ano(:,:,:,2)-O_ano(:,:,:,1))/500)
   print("Accomplished 3. w prime * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_prime_O_bar=new((/dim(0),dim(1),dim(2),3/),"float")
    w_prime_O_bar(:,:,:,0)=-w_ano(:,:,:,0)*((O_clim(:,:,:,1)-O_clim(:,:,:,0))/200)
    w_prime_O_bar(:,:,:,1)=-w_ano(:,:,:,1)*((O_clim(:,:,:,2)-O_clim(:,:,:,0))/1400)
    w_prime_O_bar(:,:,:,2)=-w_ano(:,:,:,2)*((O_clim(:,:,:,2)-O_clim(:,:,:,1))/500)
   print("Accomplished 4. w prime * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
    copy_VarCoords(O,w_bar_O_prime(:,:,:,0))
    copy_VarCoords(O,w_bar_O_bar(:,:,:,0))
    copy_VarCoords(O,w_prime_O_prime(:,:,:,0))
    copy_VarCoords(O,w_prime_O_bar(:,:,:,0))
    w_bar_O_prime!3="depth"

system("rm -f "+dir2+"ECDA-COBALT_dO_dz_all_depth_advection_199001-201712.nc")
out=addfile(    dir2+"ECDA-COBALT_dO_dz_all_depth_advection_199001-201712.nc","c")
out->w_bar_O_prime=w_bar_O_prime
out->w_bar_O_bar=w_bar_O_bar
out->w_prime_O_prime=w_prime_O_prime
out->w_prime_O_bar=w_prime_O_bar
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
out->time=time

end

