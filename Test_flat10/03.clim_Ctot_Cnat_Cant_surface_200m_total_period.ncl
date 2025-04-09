begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f_sur0=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_dep6_18500101_20001231.nc","r")
dis_tot_sur=f_sur0->dissic(:,0,:,:)
f_sur1=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_dep6_18500101_20001231.nc","r")
dis_nat_sur=f_sur1->dissicnat(:,0,:,:)
f_sur2=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicant_dep6_18500101_20001231.nc","r")
dis_ant_sur=f_sur2->dissic(:,0,:,:)

f_200m_0=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_dep182.5_18500101_20001231.nc","r")
dis_tot_200m=f_200m_0->dissic(:,0,:,:)
f_200m_1=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_dep182.5_18500101_20001231.nc","r")
dis_nat_200m=f_200m_1->dissicnat(:,0,:,:)
f_200m_2=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicant_dep182.5_18500101_20001231.nc","r")
dis_ant_200m=f_200m_2->dissic(:,0,:,:)

dim=dimsizes(dis_tot_sur)
;-----make clim-------
dis_sur=new((/3,dim(1),dim(2)/),"float")
dis_sur(0,:,:)=dim_avg_n_Wrap(dis_tot_sur,0)
dis_sur(1,:,:)=dim_avg_n_Wrap(dis_nat_sur,0)
dis_sur(2,:,:)=dim_avg_n_Wrap(dis_ant_sur,0)
dis_sur!0="var"

dis_200m=new((/3,dim(1),dim(2)/),"float")
dis_200m(0,:,:)=dim_avg_n_Wrap(dis_tot_200m,0)
dis_200m(1,:,:)=dim_avg_n_Wrap(dis_nat_200m,0)
dis_200m(2,:,:)=dim_avg_n_Wrap(dis_ant_200m,0)
dis_200m!0="var"

plot=new(6,graphic)
 wks=gsn_open_wks("png",dir2+"Flat10_DICs_clim_surface_200m_global_map_total_period")
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
 res@gsnCenterString="(a) C~B~tot~N~"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      2.5
 res@cnMinLevelValF         =      1.7
 res@cnLevelSpacingF        =      0.05
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "cmocean_dense"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map(wks,dis_sur(0,:,:),res)
 res@gsnCenterString=""
 res@lbLabelBarOn           = True
 plot(3)=gsn_csm_contour_map(wks,dis_200m(0,:,:),res)
 res@gsnCenterString="(b) C~B~nat~N~"
 res@lbLabelBarOn           =      False
 plot(1)=gsn_csm_contour_map(wks,dis_sur(1,:,:),res)
 res@gsnCenterString=""
 res@lbLabelBarOn           = True
 plot(4)=gsn_csm_contour_map(wks,dis_200m(1,:,:),res)
 res@gsnCenterString="(c) C~B~ant~N~"
 res@lbLabelBarOn           =      False
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.1
 res@cnMinLevelValF         =      0.
 res@cnLevelSpacingF        =      0.01
 res@cnFillPalette          =       "cmocean_deep"
 plot(2)=gsn_csm_contour_map(wks,dis_sur(2,:,:),res)
 res@gsnCenterString=""
 res@lbLabelBarOn           = True
 plot(5)=gsn_csm_contour_map(wks,dis_200m(2,:,:),res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   3
 pres@gsnPanelMainString="Clim (151years)"

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"Surface",0.05,0.56,txres1)
 gsn_text_ndc(wks,"200m ",0.05,0.36,txres1)
 txres1@txFontHeightF = 0.012
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.85,0.215,txres1)
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.54,0.215,txres1)
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.24,0.215,txres1)

 gsn_panel(wks,plot,(/2,3/),pres)
 frame(wks)

end
