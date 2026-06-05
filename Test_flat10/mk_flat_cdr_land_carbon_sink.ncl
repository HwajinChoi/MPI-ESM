begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"

f=addfile(dir1+"flat10_cdr_box_Cpools_total_185001-229901.nc","r")
time=f->time
box=f->box_Cpools_total
g=addfile(dir1+"flat10_cdr_box_Cpools_total_1850-2299.nc","r")
box_Cpools_total=g->box_Cpools_total
lat=g->lat
lon=g->lon
dim=dimsizes(box_Cpools_total)
Cpool=new((/450,12,dim(1),dim(2)/),typeof(box_Cpools_total))

do i=0,450-1
 Cpool(i,:,:,:)=box_Cpools_total(12*i:12*i+11,:,:)
end do

Cpool!0="year"
Cpool!1="month"

Cflux=new((/450,dim(1),dim(2)/),typeof(box_Cpools_total))

Cflux(0,:,:)=((Cpool(1,0,:,:)+Cpool(0,11,:,:))/2)-Cpool(0,0,:,:)

do i= 1,448
 Cflux(i,:,:)=((Cpool(i+1,0,:,:)+Cpool(i,11,:,:))/2)-((Cpool(i,0,:,:)+Cpool(i-1,11,:,:))/2)
end do

Cflux(449,:,:)=Cpool(449,11,:,:)-((Cpool(449,0,:,:)+Cpool(448,11,:,:))/2)
copy_VarCoords(box,Cflux)

Cflux&time=time
Cflux&lat=lat
Cflux&lon=lon

system("rm -f "+dir1+"flat10_cdr_land_carbon_flux_1850-2299.nc")
out=addfile(    dir1+"flat10_cdr_land_carbon_flux_1850-2299.nc","c")
out->Cflux=Cflux
out->lat=lat
out->lon=lon
out->time=time

end
