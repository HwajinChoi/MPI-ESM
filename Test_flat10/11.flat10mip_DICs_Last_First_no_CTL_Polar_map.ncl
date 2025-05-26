begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------Flat10------
f=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissic_dep6_18500101_21491231.nc","r")
flt_tot=f->dissic(:,0,:,:)
flt_tot_an=month_to_annual(flt_tot,1)
g=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_dep6_18500101_21491231.nc","r")
flt_nat=g->dissicnat(:,0,:,:)
flt_nat_an=month_to_annual(flt_nat,1)
h=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissicant_dep6_18500101_21491231.nc","r")
flt_ant=h->dissic(:,0,:,:)
flt_ant_an=month_to_annual(flt_ant,1)
dim=dimsizes(flt_ant)
;------Flat-zec------
f1=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissic_dep6_18500101_21491231.nc","r")
flt_zec_tot=f1->dissic(:,0,:,:)
flt_zec_tot_an=month_to_annual(flt_zec_tot,1)
g1=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicnat_dep6_18500101_21491231.nc","r")
flt_zec_nat=g1->dissicnat(:,0,:,:)
flt_zec_nat_an=month_to_annual(flt_zec_nat,1)
h1=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicant_dep6_18500101_21491231.nc","r")
flt_zec_ant=h1->dissic(:,0,:,:)
flt_zec_ant_an=month_to_annual(flt_zec_ant,1)
;------Flat-cdr------
f2=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissic_dep6_18500101_21491231.nc","r")
flt_cdr_tot=f2->dissic(:,0,:,:)
flt_cdr_tot_an=month_to_annual(flt_cdr_tot,1)
g2=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissicnat_dep6_18500101_21491231.nc","r")
flt_cdr_nat=g2->dissicnat(:,0,:,:)
flt_cdr_nat_an=month_to_annual(flt_cdr_nat,1)
h2=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissicant_dep6_18500101_21491231.nc","r")
flt_cdr_ant=h2->dissic(:,0,:,:)
flt_cdr_ant_an=month_to_annual(flt_cdr_ant,1)

First_flt=new((/3,dim(1),dim(2)/),typeof(flt_tot))
First_flt(0,:,:)=dim_avg_n_Wrap(flt_tot_an(0:29,:,:),0)
First_flt(1,:,:)=dim_avg_n_Wrap(flt_nat_an(0:29,:,:),0)
First_flt(2,:,:)=dim_avg_n_Wrap(flt_ant_an(0:29,:,:),0)
First_flt!0="scenarios"

Last_flt=new((/3,dim(1),dim(2)/),typeof(flt_tot))
Last_flt(0,:,:)=dim_avg_n_Wrap(flt_tot_an(270:299,:,:),0)
Last_flt(1,:,:)=dim_avg_n_Wrap(flt_nat_an(270:299,:,:),0)
Last_flt(2,:,:)=dim_avg_n_Wrap(flt_ant_an(270:299,:,:),0)
Last_flt!0="scenarios"

First_flt_zec=new((/3,dim(1),dim(2)/),typeof(flt_zec_tot))
First_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_tot_an(0:29,:,:),0)
First_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_nat_an(0:29,:,:),0)
First_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_ant_an(0:29,:,:),0)
First_flt_zec!0="scenarios"

Last_flt_zec=new((/3,dim(1),dim(2)/),typeof(flt_zec_tot))
Last_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_tot_an(270:299,:,:),0)
Last_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_nat_an(270:299,:,:),0)
Last_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_ant_an(270:299,:,:),0)
Last_flt_zec!0="scenarios"

First_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot))
First_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(0:29,:,:),0)
First_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(0:29,:,:),0)
First_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(0:29,:,:),0)
First_flt_cdr!0="scenarios"

Last_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot))
Last_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(270:299,:,:),0)
Last_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(270:299,:,:),0)
Last_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(270:299,:,:),0)
Last_flt_cdr!0="scenarios"

Last_First_flt=Last_flt-First_flt
copy_VarCoords(Last_flt,Last_First_flt)
Last_First_flt_zec=Last_flt_zec-First_flt_zec
copy_VarCoords(Last_flt,Last_First_flt_zec)
Last_First_flt_cdr=Last_flt_cdr-First_flt_cdr
copy_VarCoords(Last_flt,Last_First_flt_cdr)

plot=new(9,graphic)
 wks=gsn_open_wks("png",dir1+"Flat10mip_DICs_no_CTL_Last_First_ANO_Polar_map_dep_6")
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
 res@gsnCenterStringFontHeightF= 0.045
 res@gsnCenterString="(a) flat10 "
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.10
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
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
 plot(0)=gsn_csm_contour_map_polar(wks,Last_First_flt(0,:,:),res)
 res@gsnCenterString=""
 plot(3)=gsn_csm_contour_map_polar(wks,Last_First_flt(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(6)=gsn_csm_contour_map_polar(wks,Last_First_flt(2,:,:),res)
 res@gsnCenterString="(b) flat10-zec"
 res@lbLabelBarOn           =      False
 plot(1)=gsn_csm_contour_map_polar(wks,Last_First_flt_zec(0,:,:),res)
 res@gsnCenterString=""
 plot(4)=gsn_csm_contour_map_polar(wks,Last_First_flt_zec(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(7)=gsn_csm_contour_map_polar(wks,Last_First_flt_zec(2,:,:),res)
 res@gsnCenterString="(c) flat10-cdr"
 res@lbLabelBarOn           =      False
 ;res@cnLevelSelectionMode   =       "ManualLevels"
 ;res@cnMaxLevelValF         =      0.1
 ;res@cnMinLevelValF         =      0.
 ;res@cnLevelSpacingF        =      0.01
 ;res@cnFillPalette          =       "cmocean_deep"
 plot(2)=gsn_csm_contour_map_polar(wks,Last_First_flt_cdr(0,:,:),res)
 res@gsnCenterString=""
 plot(5)=gsn_csm_contour_map_polar(wks,Last_First_flt_cdr(1,:,:),res)
 ;res@lbLabelBarOn           = True
 plot(8)=gsn_csm_contour_map_polar(wks,Last_First_flt_cdr(2,:,:),res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString="Last-First (Surface)"

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

