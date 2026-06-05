#!/bin/bash

for V in "tsco212" "tsco212nat";do
 for i in $(seq 0 44);do

 S1=$((1850+10*i))
 S2=$((1859+10*i))
 C=flat10_cdr_budget_terms_${V}_${S1}_${S2}_ano_timcumsum_avg.nc
 D=flat10_cdr_budget_terms_${V}_${S1}_${S2}_ano_timcumsum_avg_bathy_sum.nc

cat << EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/mpiom/"
dir1="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/data/budget_slice/"

g=addfile(dir0+"flat10_cdr_001_mpiom_fx_18500101_18501231.nc","r")
ddpo=g->ddpo(0,:,:,:);time,depth_2,y_2,x_2
depth_2=g->depth_2

depth_min=min(depth_2)
depth_max=max(depth_2)

ddpo_sum=dim_sum_n_Wrap(ddpo,0)
dim=dimsizes(ddpo_sum)
f=addfile(dir3+"${C}","r")
tot=f->${V}_tot(0,:,:,:) ; time 450 lat 96 lon 192
adv=f->${V}_adv(0,:,:,:)
dif=f->${V}_dif(0,:,:,:)
gm=f->${V}_gm(0,:,:,:)
sosi=f->${V}_sosi(0,:,:,:)
surf=f->${V}_surf(0,:,:,:)
lat=f->lat
lon=f->lon
lon_bnds=f->lon_bnds
time_bnds=f->time_bnds
lat_bnds=f->lat_bnds

A=new((/6,40,dim(0),dim(1)/),typeof(ddpo))
A@_FillValue = ddpo@_FillValue

dim1=dimsizes(tot)
TOT=new((/6,dim1(0),dim1(1),dim1(2)/),typeof(tot))
TOT(0,:,:,:)=tot
TOT(1,:,:,:)=adv
TOT(2,:,:,:)=dif
TOT(3,:,:,:)=gm
TOT(4,:,:,:)=sosi
TOT(5,:,:,:)=surf
TOT!0="variable"

h=500
layer=12

avg_bathy=new((/6,layer,dim(0),dim(1)/),typeof(ddpo))
avg_bathy@_FillValue = ddpo@_FillValue

do d = 1, layer
 A = A@_FillValue

 do i = 0, dim(0)-1
  do j = 0, dim(1)-1

  depth = ddpo_sum(i,j)

   if (ismissing(depth)) then

   A(:,:,i,j) = A@_FillValue

    else
        shallow_bound = depth -h*d
        deep_bound = depth -h*(d-1)
          ;--------------------------------
          ; bin completely above water
          ;--------------------------------
     if (deep_bound .le. 0) then
        A(:,:,i,j) = A@_FillValue

      else

        shallow_bound := max((/shallow_bound, depth_min/))
        deep_bound    := min((/deep_bound, depth_max/))

       if (shallow_bound .le. 0) then
          tmp1d := TOT(:,{0:deep_bound},i,j)
        else
          tmp1d := TOT(:,{shallow_bound:deep_bound},i,j)
       end if

       if (.not. all(ismissing(tmp1d))) then
            lev = dimsizes(tmp1d)
            A(:,0:lev(1)-1,i,j) = (/ tmp1d /)
            delete(tmp1d)
        else
            A(:,:,i,j) = A@_FillValue
       end if
     end if
    end if

    end do
  end do
print("finished (d ) = "+d)

  ;avg_bathy(:,layer-d,:,:) = dim_avg_n_Wrap(A,1)
  avg_bathy(:,layer-d,:,:) = dim_sum_n_Wrap(A,1)
end do
  avg_bathy!1="depth_3"

  depth_3=ispan(1,12,1)
  avg_bathy&depth_3=depth_3
  avg_bathy!0="variable"
  avg_bathy!2="y"
  avg_bathy!3="x"

system("rm -f "+dir3+"${D}")
out=addfile(    dir3+"${D}","c")
out->avg_bathy=avg_bathy
out->lon=lon
out->lat=lat
out->lon_bnds=lon_bnds
out->time_bnds=time_bnds
out->lat_bnds=lat_bnds

end

EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl

 echo "${D}"

 done
done
