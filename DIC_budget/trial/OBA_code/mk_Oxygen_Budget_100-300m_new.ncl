begin
;-----------------------------------------------------------------------------------------
; delta time = 1 month
; EQUATOR : 150-270E, 20S-20N
;-----------------------------------------------------------------------------------------
dir1="/data/hjchoi/CMI/OBA/data/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
f1=addfile(dir1+"o2_0-100mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
f2=addfile(dir1+"o2_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
f3=addfile(dir1+"o2_300-800mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")

g=addfile(dir1+"u_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
h=addfile(dir1+"v_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
u=g->u
time=g->time
v=h->v

k1=addfile(dir1+"wt_0-100mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
k2=addfile(dir1+"wt_100-300mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
k3=addfile(dir1+"wt_300-800mAVG_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
wt_0_100=k1->wt
wt_100_300=k2->wt
wt_300_800=k3->wt

o2_0_100=f1->o2 ;time*yt_ocean*xt_ocean
o2_100_300=f2->o2 ;time*yt_ocean*xt_ocean
o2_300_800=f3->o2 ;time*yt_ocean*xt_ocean
o2_0_100=o2_0_100*1000000 ; For change unit micro mol/kg
o2_100_300=o2_100_300*1000000
o2_300_800=o2_300_800*1000000
o2_0_100@units="micro mol/kg"
o2_100_300@units="micro mol/kg"
o2_300_800@units="micro mol/kg"

lon=f1->xt_ocean;0-359
lat=f1->yt_ocean;-89.5 - 89.5
clat=cos(rad*lat)
clat := dble2flt(clat)

O=o2_100_300;time*lat*lon
dim=dimsizes(O);time*lat*lon
;----------Make vertical velocity (w)----------------
w=new((/dim(0),dim(1),dim(2),3/),"float")
w(:,:,:,0)=(wt_100_300(:,:,:)-wt_0_100(:,:,:))*0.5
w(:,:,:,1)=(wt_300_800(:,:,:)-wt_100_300(:,:,:))*0.5
w(:,:,:,2)=wt_300_800*0.5
copy_VarCoords(wt_100_300,w(:,:,:,0))
w!3="depth"
;---------------------round C/round t---------------
Ot=new((/dim(0),dim(1),dim(2)/),"float")
   Ot(0,:,:)=(O(1,:,:)-O(0,:,:))/(t)   ;time 335
    do i=1,dim(0)-2
    Ot(i,:,:)=(O(i+1,:,:)-O(i-1,:,:))/(2*t)   ;time 335
    end do
   Ot(dim(0)-1,:,:)=(O(dim(0)-1,:,:)-O(dim(0)-2,:,:))/(t)   ;time 335
   print("Accomplished round O / round t")
;---------------------round C/round x---------------
Ox=new((/dim(0),dim(1),dim(2)/),"float")
    do j=0,dim(1)-1 ; lat
     Ox(:,j,0)=-u(:,j,0)*((O(:,j,1)-O(:,j,0))/(clat(j)*re*rad))   ;time 335
     do i=1,dim(2)-2 ; lon
     Ox(:,j,i)=-u(:,j,i)*((O(:,j,i+1)-O(:,j,i-1))/(2*clat(j)*re*rad))   ;time 335
     end do
     Ox(:,j,dim(2)-1)=-u(:,j,dim(2)-1)*((O(:,j,dim(2)-1)-O(:,j,dim(2)-2))/(clat(j)*re*rad))   ;time 335
    end do
   print("Accomplished round O / round x")
;---------------------round C/round y---------------
Oy=new((/dim(0),dim(1),dim(2)/),"float")
   Oy(:,0,:)=-v(:,0,:)*((O(:,1,:)-O(:,0,:))/(re*rad))   ;time 335
    do i=1,dim(1)-2
    Oy(:,i,:)=-v(:,i,:)*((O(:,i+1,:)-O(:,i-1,:))/(re*rad*2))   ;time 335
    end do
   Oy(:,dim(1)-1,:)=-v(:,dim(1)-1,:)*((O(:,dim(1)-1,:)-O(:,dim(1)-2,:))/(re*rad))   ;time 335
   print("Accomplished round O / round y")
;---------------------round C/round z---------------
Oz=new((/dim(0),dim(1),dim(2),3/),"float")
    Oz(:,:,:,0)=-w(:,:,:,0)*((o2_100_300(:,:,:)-o2_0_100(:,:,:))/150)
    Oz(:,:,:,1)=-w(:,:,:,1)*((o2_300_800(:,:,:)-o2_0_100(:,:,:))/500)
    Oz(:,:,:,2)=-w(:,:,:,2)*((o2_300_800(:,:,:)-o2_100_300(:,:,:))/350)
copy_VarCoords(O,Ot)
copy_VarCoords(O,Ox)
copy_VarCoords(O,Oy)
copy_VarCoords(O,Oz(:,:,:,0))
Oz!3="depth"
print("Total CPU time: " + get_cpu_time())

system("rm -f "+dir1+"ECDA-COBALT_Oxygern_budget_advection_199001-201712.nc")
out=addfile(    dir1+"ECDA-COBALT_Oxygern_budget_advection_199001-201712.nc","c")
out->Ot=Ot
out->Oy=Oy
out->Ox=Ox
out->Oz=Oz(:,:,:,1)
out->lat=lat
out->lon=lon
out->time=time

end
