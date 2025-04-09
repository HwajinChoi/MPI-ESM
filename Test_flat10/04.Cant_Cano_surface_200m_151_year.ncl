begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f_sur0=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_dep6_18500101_20001231.nc","r")
dis_tot_sur_151=f_sur0->dissic(1800:1811,0,:,:)
dis_tot_sur_1=f_sur0->dissic(0:11,0,:,:)
f_sur2=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicant_dep6_18500101_20001231.nc","r")
dis_ant_sur=f_sur2->dissic(1800:1811,0,:,:)
dis_tot_sur_ano=dis_tot_sur_151-dis_tot_sur_1
copy_VarCoords(dis_tot_sur_1,dis_tot_sur_ano)
diff_sur=dis_tot_sur_ano-dis_ant_sur
copy_VarCoords(dis_tot_sur_ano,diff_sur)

f_200m_0=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_dep182.5_18500101_20001231.nc","r")
dis_tot_200m_151=f_200m_0->dissic(1800:1811,0,:,:)
dis_tot_200m_1=f_200m_0->dissic(0:11,0,:,:)
f_200m_2=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicant_dep182.5_18500101_20001231.nc","r")
dis_ant_200m=f_200m_2->dissic(1800:1811,0,:,:)
dis_tot_200m_ano=dis_tot_200m_151-dis_tot_200m_1
copy_VarCoords(dis_tot_200m_151,dis_tot_200m_ano)
diff_200m=dis_tot_200m_ano-dis_ant_200m
copy_VarCoords(dis_ant_200m,diff_200m)

dim=dimsizes(dis_tot_sur_1)
;-----make clim-------
dis_sur=new((/3,dim(1),dim(2)/),"float")
dis_sur(0,:,:)=dim_avg_n_Wrap(dis_tot_sur_ano,0)
dis_sur(1,:,:)=dim_avg_n_Wrap(dis_ant_sur,0)
dis_sur(2,:,:)=dim_avg_n_Wrap(diff_sur,0)
dis_sur!0="var"

dis_200m=new((/3,dim(1),dim(2)/),"float")
dis_200m(0,:,:)=dim_avg_n_Wrap(dis_tot_200m_ano,0)
dis_200m(1,:,:)=dim_avg_n_Wrap(dis_ant_200m,0)
dis_200m(2,:,:)=dim_avg_n_Wrap(diff_200m,0)
dis_200m!0="var"

plot=new(6,graphic)
 wks=gsn_open_wks("png",dir2+"Flat10_Cano_Cant_surface_200m_global_map_151_year")
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
 res@gsnCenterString="(a) Surface"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.14
 res@cnMinLevelValF         =      0.
 res@cnLevelSpacingF        =      0.01
 res@cnFillPalette          =       "cmocean_deep"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map(wks,dis_sur(0,:,:),res)
 res@gsnCenterString=""
 ;res@lbLabelBarOn           = True
 plot(2)=gsn_csm_contour_map(wks,dis_sur(1,:,:),res)
 res@gsnCenterString="(b) 200m"
 ;res@lbLabelBarOn           =      False
 plot(1)=gsn_csm_contour_map(wks,dis_200m(0,:,:),res)
 res@gsnCenterString=""
 ;res@lbLabelBarOn           = True
 plot(3)=gsn_csm_contour_map(wks,dis_200m(1,:,:),res)
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.16
 res@cnMinLevelValF         =      -0.16
 res@cnLevelSpacingF        =      0.02
 res@cnFillPalette          =       "BlueDarkRed18"
 plot(4)=gsn_csm_contour_map(wks,dis_sur(2,:,:),res)
 plot(5)=gsn_csm_contour_map(wks,dis_200m(2,:,:),res)

 pres                       =   True
 pres@lbOrientation       = "vertical"
 pres@lbLabelFontHeightF  = 0.018
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   3
 pres@gsnPanelMainString="151 year"
 pres@pmLabelBarHeightF   = 0.45 
 pres@gsnPanelLeft=0.15
 pres@gsnPanelRight=0.95
 pres@gsnPanelTop=0.95
 pres@gsnPanelBottom=0.35
 pres@pmLabelBarWidthF=0.05
 pres2=pres
 pres2@gsnPanelMainString=""
 pres2@gsnPanelTop=0.36
 pres2@gsnPanelBottom=0.05
 pres2@pmLabelBarHeightF   = 0.25

 txres1               = True
 txres1@txFontHeightF = 0.018
 gsn_text_ndc(wks,"C~B~ano~N~",0.075,0.75,txres1)
 gsn_text_ndc(wks,"C~B~ant~N~ ",0.075,0.52,txres1)
 txres1@txFontHeightF = 0.016
 gsn_text_ndc(wks,"Diff (C~B~ano~N~-C~B~ant~N~) ",0.08,0.2,txres1)
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.88,0.4,txres1)

 gsn_panel(wks,plot(0:3),(/2,2/),pres)
 gsn_panel(wks,plot(4:5),(/1,2/),pres2)
 frame(wks)

end
