begin
dir1="/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/"

f=addfile(dir1+"flat10_cdr_budget_002_mpiom_fx_18500101_18501231.nc","r")
g=addfile(dir1+"dissicnat_229901_229912.nc","r")
h=addfile(dir1+"velocity_229901_229912.nc","r")

dlxu=f->dlxu(0,0,:,:)
dlyv=f->dlyv(0,0,:,:)
ddpo=f->ddpo(0,:,:,:)
cnat=g->dissicnat ; time(12) depth (40) y(220) x (256) 
depth=g->depth
lon_bnds=g->lon_bnds
lat_bnds=g->lat_bnds
lat=g->lat
lon=g->lon
time=g->time
wo=h->wo ; time(12) depth (41) y(220) x (256)
uo=h->uo
vo=h->vo

dim=dimsizes(cnat)

;------------------------------------------------------------
; making central DIC for the z-coordinate
;------------------------------------------------------------
c_uo=cnat*uo
c_vo=cnat*vo
copy_VarCoords(uo,c_uo)
copy_VarCoords(vo,c_vo)

;------------------------------------------------------------
; making DIC at W points and w*C
;------------------------------------------------------------
c_wo = new((/dim(0),dim(1)+1,dim(2),dim(3)/),typeof(cnat))

; surface and bottom flux = 0
c_wo(:,0,:,:)      = 0.
c_wo(:,dim(1),:,:) = 0.

; internal interfaces: k=1,...,39
do k=1,dim(1)-1
   c_wo(:,k,:,:) = wo(:,k,:,:)*(cnat(:,k-1,:,:)+cnat(:,k,:,:))/2.
end do

;------------------------------------------------------------
; making the time dimension of dx, dy, dz 
;------------------------------------------------------------
dx=new((/12,dim(1),dim(2),dim(3)/),typeof(cnat))
dy=new((/12,dim(1),dim(2),dim(3)/),typeof(cnat))
dz=new((/12,dim(1),dim(2),dim(3)/),typeof(cnat))

do i=0,11
 do j=0,dim(1)-1
 dx(i,j,:,:)=dlxu
 dy(i,j,:,:)=dlyv
 end do
 dz(i,:,:,:)=ddpo
end do
;------------------------------------------------------------
; d(uC)/dx , d(vC)/dy
;------------------------------------------------------------
adv_u=new((/12,dim(1),dim(2),dim(3)-1/),typeof(cnat))
adv_v=new((/12,dim(1),dim(2)-1,dim(3)/),typeof(cnat))

do i=0,dim(2)-2 ; 
 adv_v(:,:,i,:)=(vo(:,:,i+1,:)-vo(:,:,i,:))/dy(:,:,i,:)
end do

do i=0,dim(3)-2 ; 
 adv_u(:,:,:,i)=(uo(:,:,:,i+1)-uo(:,:,:,i))/dx(:,:,:,i)
end do

;------------------------------------------------------------
; d(wC)/dz 
;------------------------------------------------------------
adv_w = new((/dim(0),dim(1),dim(2),dim(3)/),typeof(cnat))

do k=0,dim(1)-1
   adv_w(:,k,:,:) = (wo(:,k+1,:,:)-wo(:,k,:,:))/dz(:,k,:,:)
end do

;------------------------------------------------------------
; Trimming
;------------------------------------------------------------
adv_UC=new((/dim(0),dim(1),dim(2),dim(3)/),typeof(cnat))
adv_VC=new((/dim(0),dim(1),dim(2),dim(3)/),typeof(cnat))
adv_WC=new((/dim(0),dim(1),dim(2),dim(3)/),typeof(cnat))

adv_UC(:,:,:,0:dim(3)-2)=-adv_u
adv_VC(:,:,0:dim(2)-2,:)=-adv_v
adv_WC(:,:,:,:)=adv_w

vel_div=adv_UC+adv_VC+adv_WC
dic_error=cnat*vel_div
copy_VarCoords(cnat,dic_error)
copy_VarCoords(cnat,adv_UC)
copy_VarCoords(cnat,adv_VC)
copy_VarCoords(cnat,adv_WC)

system("rm -f "+dir1+"error_advection_terms_229901-229912.nc")
out=addfile(    dir1+"error_advection_terms_229901-229912.nc","c")
out->adv_UC=adv_UC
out->adv_VC=adv_VC
out->adv_WC=adv_WC
out->dic_error=dic_error
out->lat=lat
out->lon=lon
out->time=time
out->depth=depth
out->lon_bnds=lon_bnds
out->lat_bnds=lat_bnds

end
