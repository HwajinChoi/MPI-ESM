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

f=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissic_dep${dep}_18500101_21491231.nc","r")
flt_tot=f->dissic(:,0,:,:)
flt_tot_an=month_to_annual(flt_tot,1)
g=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicnat_dep${dep}_18500101_21491231.nc","r")
flt_nat=g->dissicnat(:,0,:,:)
flt_nat_an=month_to_annual(flt_nat,1)
h=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicant_dep${dep}_18500101_21491231.nc","r")
flt_ant=h->dissic(:,0,:,:)
flt_ant_an=month_to_annual(flt_ant,1)
dim=dimsizes(flt_ant)

First=new((/3,dim(1),dim(2)/),typeof(flt_tot))
First(0,:,:)=dim_avg_n_Wrap(flt_tot_an(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(flt_nat_an(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(flt_ant_an(0:29,:,:),0)
First!0="scenarios"

Middle=new((/3,dim(1),dim(2)/),typeof(flt_tot))
Middle(0,:,:)=dim_avg_n_Wrap(flt_tot_an(135:164,:,:),0)
Middle(1,:,:)=dim_avg_n_Wrap(flt_nat_an(135:164,:,:),0)
Middle(2,:,:)=dim_avg_n_Wrap(flt_ant_an(135:164,:,:),0)
Middle!0="scenarios"

Last=new((/3,dim(1),dim(2)/),typeof(flt_tot))
Last(0,:,:)=dim_avg_n_Wrap(flt_tot_an(270:299,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(flt_nat_an(270:299,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(flt_ant_an(270:299,:,:),0)
Last!0="scenarios"

Last_First=Last-First
Last_Middle=Last-Middle
Middle_First=Middle-First
copy_VarCoords(Last,Last_First)
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)

plot=new(9,graphic)
 wks=gsn_open_wks("png",dir1+"Flat10_zec_DICs_no_CTL_ANO_Polar_map_3periods_dep_${dep}")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@mpMinLatF			=60
 ;res@mpProjection ="Robinson"
 ;res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnPolar   = "NH" 
 res@gsnCenterStringFontHeightF= 0.040
 res@gsnCenterString="(a) Middle - First "
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "gray"
 res@tmXBLabelFontHeightF=       0.026
 res@gsnPolarLabelFontHeightF=0.02
 res@tmXBLabelFontThicknessF=    2
 res@tmXBMajorLengthF    =       0.02
 res@tmXBMinorLengthF    =       0.01
 res@tmXBLabelStride     =       2
 res@tmYLLabelFontHeightF=       0.016
 res@tmYLMajorLengthF   =       0.02
 res@tmYLMinorLengthF   =       0.01
 res@tmYLLabelFontThicknessF=    2

 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =     0.25
 res@cnMinLevelValF         =     -0.25
 res@cnLevelSpacingF        =      0.025
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "temp_diff_18lev"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map_polar(wks,Middle_First(0,:,:),res)
 res@gsnCenterString=""
 plot(3)=gsn_csm_contour_map_polar(wks,Middle_First(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(6)=gsn_csm_contour_map_polar(wks,Middle_First(2,:,:),res)
 res@gsnCenterString="(b) Last - First"
 res@lbLabelBarOn           =      False
 plot(1)=gsn_csm_contour_map_polar(wks,Last_First(0,:,:),res)
 res@gsnCenterString=""
 plot(4)=gsn_csm_contour_map_polar(wks,Last_First(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(7)=gsn_csm_contour_map_polar(wks,Last_First(2,:,:),res)
 res@gsnCenterString="(c) Last - Middle"
 res@lbLabelBarOn           =      False
 ;res@cnLevelSelectionMode   =       "ManualLevels"
 ;res@cnMaxLevelValF         =      0.1
 ;res@cnMinLevelValF         =      0.
 ;res@cnLevelSpacingF        =      0.01
 ;res@cnFillPalette          =       "cmocean_deep"
 plot(2)=gsn_csm_contour_map_polar(wks,Last_Middle(0,:,:),res)
 res@gsnCenterString=""
 plot(5)=gsn_csm_contour_map_polar(wks,Last_Middle(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(8)=gsn_csm_contour_map_polar(wks,Last_Middle(2,:,:),res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString="Flat10-zec anomaly (${A})"

 txres1               = True
 txres1@txFontHeightF = 0.017
 gsn_text_ndc(wks,"DIC~B~tot~N~",0.07,0.79,txres1)
 gsn_text_ndc(wks,"DIC~B~nat~N~",0.07,0.49,txres1)
 gsn_text_ndc(wks,"DIC~B~ant~N~",0.07,0.21,txres1)
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


