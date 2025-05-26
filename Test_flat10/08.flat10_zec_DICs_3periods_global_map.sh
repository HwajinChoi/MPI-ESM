#!/bin/bash
for dep in "6" "182.5" ;do

 if [ $dep = "6" ];then
  A="Surface"
 else
  A="200m"
 fi

cat << EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

a=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_dep${dep}_19710101_20001231.nc","r")
ctl_tot=a->dissic(:,0,:,:)
b=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicnat_dep${dep}_19710101_20001231.nc","r")
ctl_nat=b->dissicnat(:,0,:,:)
;c=addfile(dir0+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissicant_dep${dep}_19710101_20001231.nc","r")
;ctl_ant=a->dissic(:,0,:,:)
;-----------------------------------------
dim=dimsizes(ctl_tot)
ctl_tot_clim=new((/300,dim(1),dim(2)/),typeof(ctl_tot))
ctl_nat_clim=new((/300,dim(1),dim(2)/),typeof(ctl_tot))
;ctl_ant_clim=new((/300,dim(1),dim(2)/),typeof(ctl_tot))

 do i=0,299
  ctl_tot_clim(i,:,:)=dim_avg_n_Wrap(ctl_tot,0)
  ctl_nat_clim(i,:,:)=dim_avg_n_Wrap(ctl_nat,0)
 ;ctl_ant_clim(i,:,:)=dim_avg_n_Wrap(ctl_ant,0)
 end do

f=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissic_dep${dep}_18500101_21491231.nc","r")
flt_tot=f->dissic(:,0,:,:)
flt_tot_an=month_to_annual(flt_tot,1)
g=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicnat_dep${dep}_18500101_21491231.nc","r")
flt_nat=g->dissicnat(:,0,:,:)
flt_nat_an=month_to_annual(flt_nat,1)
h=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicant_dep${dep}_18500101_21491231.nc","r")
flt_ant=h->dissic(:,0,:,:)
flt_ant_an=month_to_annual(flt_ant,1)

tot=flt_tot_an-ctl_tot_clim
copy_VarCoords(flt_tot_an,tot)
nat=flt_nat_an-ctl_nat_clim
copy_VarCoords(flt_nat_an,nat)
ant=flt_ant_an

;printVarSummary(tot)
;printMinMax(tot,1)
;printMinMax(nat,1)
;printMinMax(ant,1)
;exit

First=new((/3,dim(1),dim(2)/),typeof(tot))
First(0,:,:)=dim_avg_n_Wrap(tot(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(nat(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(ant(0:29,:,:),0)
First!0="scenarios"

Middle=new((/3,dim(1),dim(2)/),typeof(tot))
Middle(0,:,:)=dim_avg_n_Wrap(tot(135:164,:,:),0)
Middle(1,:,:)=dim_avg_n_Wrap(nat(135:164,:,:),0)
Middle(2,:,:)=dim_avg_n_Wrap(ant(135:164,:,:),0)
Middle!0="scenarios"

Last=new((/3,dim(1),dim(2)/),typeof(tot))
Last(0,:,:)=dim_avg_n_Wrap(tot(270:299,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(nat(270:299,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(ant(270:299,:,:),0)
Last!0="scenarios"

plot=new(9,graphic)
 wks=gsn_open_wks("png",dir1+"Flat10_zec_DICs_ANO_global_map_3periods_dep_${dep}")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.028
 res@gsnCenterString="(a) First 30 years"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =     0.25
 res@cnMinLevelValF         =     -0.25
 res@cnLevelSpacingF        =      0.025
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "temp_diff_18lev"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map(wks,First(0,:,:),res)
 res@gsnCenterString=""
 plot(3)=gsn_csm_contour_map(wks,First(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(6)=gsn_csm_contour_map(wks,First(2,:,:),res)
 res@gsnCenterString="(b) Middle 30 years"
 res@lbLabelBarOn           =      False
 plot(1)=gsn_csm_contour_map(wks,Middle(0,:,:),res)
 res@gsnCenterString=""
 plot(4)=gsn_csm_contour_map(wks,Middle(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(7)=gsn_csm_contour_map(wks,Middle(2,:,:),res)
 res@gsnCenterString="(c) Last 30 years"
 res@lbLabelBarOn           =      False
 ;res@cnLevelSelectionMode   =       "ManualLevels"
 ;res@cnMaxLevelValF         =      0.1
 ;res@cnMinLevelValF         =      0.
 ;res@cnLevelSpacingF        =      0.01
 ;res@cnFillPalette          =       "cmocean_deep"
 plot(2)=gsn_csm_contour_map(wks,Last(0,:,:),res)
 res@gsnCenterString=""
 plot(5)=gsn_csm_contour_map(wks,Last(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(8)=gsn_csm_contour_map(wks,Last(2,:,:),res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString="Flat10 anomaly (${A})"

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"DIC~B~tot~N~",0.05,0.67,txres1)
 gsn_text_ndc(wks,"DIC~B~nat~N~",0.05,0.47,txres1)
 gsn_text_ndc(wks,"DIC~B~ant~N~",0.05,0.29,txres1)
 txres1@txFontHeightF = 0.014
 ;gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.85,0.12,txres1)
 ;gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.54,0.12,txres1)
 ;gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.24,0.12,txres1)

 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.54,0.15,txres1)

 gsn_panel(wks,plot,(/3,3/),pres)
 frame(wks)

end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done


