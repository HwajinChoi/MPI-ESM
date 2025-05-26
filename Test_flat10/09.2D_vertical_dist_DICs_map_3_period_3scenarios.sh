#!/bin/bash

#for S in "flat10" "flat10_zec" "flat10_cdr" ;do
for S in "flat10" ; do
# for P in "First" "Middle" "Last" ;do

# if [ $P = "First" ];then
#  A=
# elif [ $P = "Middle" ];then
#  A=
# else
#  A=
# fi

cat <<EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------------------------- CTL-------------------------
a=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231_lon_340.nc","r")
tot_ctl_atl=a->dissic(:,:,:,0) ; time x depth x lat x lon
b=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicnat_19710101_20001231_lon_340.nc","r")
nat_ctl_atl=b->dissicnat(:,:,:,0)

a1=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231_lon_190.nc","r")
tot_ctl_pac=a1->dissic(:,:,:,0)
b1=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicnat_19710101_20001231_lon_190.nc","r")
nat_ctl_pac=b1->dissicnat(:,:,:,0)

a2=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231_lon_70.nc","r")
tot_ctl_ind=a2->dissic(:,:,:,0)
b2=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicnat_19710101_20001231_lon_70.nc","r")
nat_ctl_ind=b2->dissicnat(:,:,:,0)
;-----------------------------------------------------
dim=dimsizes(tot_ctl_atl)
tot_ctl_atl_an=new((/300,dim(1),dim(2)/),typeof(tot_ctl_atl))
nat_ctl_atl_an=new((/300,dim(1),dim(2)/),typeof(tot_ctl_atl))
tot_ctl_pac_an=new((/300,dim(1),dim(2)/),typeof(tot_ctl_pac))
nat_ctl_pac_an=new((/300,dim(1),dim(2)/),typeof(tot_ctl_pac))
tot_ctl_ind_an=new((/300,dim(1),dim(2)/),typeof(tot_ctl_ind))
nat_ctl_ind_an=new((/300,dim(1),dim(2)/),typeof(tot_ctl_ind))

do i=0,299
 tot_ctl_atl_an(i,:,:)=dim_avg_n_Wrap(tot_ctl_atl,0)
 tot_ctl_pac_an(i,:,:)=dim_avg_n_Wrap(tot_ctl_pac,0)
 tot_ctl_ind_an(i,:,:)=dim_avg_n_Wrap(tot_ctl_ind,0)

 nat_ctl_atl_an(i,:,:)=dim_avg_n_Wrap(nat_ctl_atl,0)
 nat_ctl_pac_an(i,:,:)=dim_avg_n_Wrap(nat_ctl_pac,0)
 nat_ctl_ind_an(i,:,:)=dim_avg_n_Wrap(nat_ctl_ind,0)
end do

;------------------------------------------------------
f=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_340.nc","r")
tot_flt_atl=f->dissic(:,:,:,0) ; time x depth x lat
g=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_340.nc","r")
nat_flt_atl=g->dissicnat(:,:,:,0)
h=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_340.nc","r")
ant_flt_atl=h->dissic(:,:,:,0)

f1=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_190.nc","r")
tot_flt_pac=f1->dissic(:,:,:,0)
g1=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_190.nc","r")
nat_flt_pac=g1->dissicnat(:,:,:,0)
h1=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_190.nc","r")
ant_flt_pac=h1->dissic(:,:,:,0)

f2=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_70.nc","r")
tot_flt_ind=f2->dissic(:,:,:,0)
g2=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_70.nc","r")
nat_flt_ind=g2->dissicnat(:,:,:,0)
h2=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_70.nc","r")
ant_flt_ind=h2->dissic(:,:,:,0)
;------------------------------------------------------
tot_flt_atl_an=month_to_annual(tot_flt_atl,1)
nat_flt_atl_an=month_to_annual(nat_flt_atl,1)
ant_flt_atl_an=month_to_annual(ant_flt_atl,1)

tot_flt_pac_an=month_to_annual(tot_flt_pac,1)
nat_flt_pac_an=month_to_annual(nat_flt_pac,1)
ant_flt_pac_an=month_to_annual(ant_flt_pac,1)

tot_flt_ind_an=month_to_annual(tot_flt_ind,1)
nat_flt_ind_an=month_to_annual(nat_flt_ind,1)
ant_flt_ind_an=month_to_annual(ant_flt_ind,1)
;------------------------------------------------------
tot_atl_ano=tot_flt_atl_an-tot_ctl_atl_an
nat_atl_ano=nat_flt_atl_an-nat_ctl_atl_an
ant_atl_ano=ant_flt_atl_an

tot_pac_ano=tot_flt_pac_an-tot_ctl_pac_an
nat_pac_ano=nat_flt_pac_an-nat_ctl_pac_an
ant_pac_ano=ant_flt_pac_an

tot_ind_ano=tot_flt_ind_an-tot_ctl_ind_an
nat_ind_ano=nat_flt_ind_an-nat_ctl_ind_an
ant_ind_ano=ant_flt_ind_an

copy_VarCoords(tot_flt_atl_an,tot_atl_ano)
copy_VarCoords(nat_flt_atl_an,nat_atl_ano)
copy_VarCoords(tot_flt_pac_an,tot_pac_ano)
copy_VarCoords(nat_flt_pac_an,nat_pac_ano)
copy_VarCoords(tot_flt_ind_an,tot_ind_ano)
copy_VarCoords(nat_flt_ind_an,nat_ind_ano)

;------------------------------------------------------

;gsn_panel(wks,plot,(/3,3/),pres)
;frame(wks)

end

EOF

ncl ./imsi.ncl
rm -f ./imsi.ncl
done
