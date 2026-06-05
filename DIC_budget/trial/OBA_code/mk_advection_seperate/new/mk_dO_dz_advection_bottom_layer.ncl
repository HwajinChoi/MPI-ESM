begin
dir0="/data/hjchoi/CMI/OBA/data/raw/"
dir1="/data/hjchoi/CMI/OBA/data/raw/spilt_levels/"
dir2="/data/hjchoi/CMI/OBA/data/advection/new/raw/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
N=asciiread(dir0+"st_ocean",-1,"string")
f1=addfile(dir1+"o2_"+N(33-1)+"m_COBALT.199001-201712.nc","r")
f2=addfile(dir1+"o2_"+N(33)+"m_COBALT.199001-201712.nc","r")
o2_1=f1->o2(:,0,:,:) ;time*yt_ocean*xt_ocean
o2_2=f2->o2(:,0,:,:) ;time*yt_ocean*xt_ocean

M=asciiread(dir0+"sw_ocean",-1,"string")
k2=addfile(dir1+"wt_"+M(33)+"m_COBALT.199001-201712.nc","r")
wt_2=k2->wt(:,0,:,:)

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
w=(wt_2)*0.5
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
    w_bar_O_prime(:,:,:)=-w_clim(:,:,:)*((O_ano(:,:,:,0)-O_ano(:,:,:,1))/(NN(33)-NN(33-1)))
   print("Accomplished 1. w bar * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w bar * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_bar_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
    w_bar_O_bar(:,:,:)=-w_clim(:,:,:)*((O_clim(:,:,:,0)-O_clim(:,:,:,1))/(NN(33)-NN(33-1)))
   print("Accomplished 2. w bar * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 prime /dz
;-----------------------------------------------------------------------------------------
w_prime_O_prime=new((/dim(0),dim(1),dim(2)/),"float")
    w_prime_O_prime(:,:,:)=-w_ano(:,:,:)*((O_ano(:,:,:,0)-O_ano(:,:,:,1))/(NN(33)-NN(33-1)))
   print("Accomplished 3. w prime * O2 prime / dz")
   print("Total CPU time: " + get_cpu_time())
;-----------------------------------------------------------------------------------------
; Make w prime * O2 bar /dz
;-----------------------------------------------------------------------------------------
w_prime_O_bar=new((/dim(0),dim(1),dim(2)/),"float")
    w_prime_O_bar(:,:,:)=-w_ano(:,:,:)*((O_clim(:,:,:,0)-O_clim(:,:,:,1))/(NN(33)-NN(33-1)))
   print("Accomplished 4. w prime * O2 bar / dz")
   print("Total CPU time: " + get_cpu_time())
    copy_VarCoords(w,w_bar_O_prime)
    copy_VarCoords(w,w_bar_O_bar)
    copy_VarCoords(w,w_prime_O_prime)
    copy_VarCoords(w,w_prime_O_bar)

    system("rm -f "+dir2+"ECDA-COBALT_dO_dz_"+N(33)+"m_advection_199001-201712.nc")
    out=addfile(    dir2+"ECDA-COBALT_dO_dz_"+N(33)+"m_advection_199001-201712.nc","c")
    out->w_bar_O_prime=w_bar_O_prime
    out->w_bar_O_bar=w_bar_O_bar
    out->w_prime_O_prime=w_prime_O_prime
    out->w_prime_O_bar=w_prime_O_bar
    out->yt_ocean=yt_ocean
    out->xt_ocean=xt_ocean
    out->time=time
end
