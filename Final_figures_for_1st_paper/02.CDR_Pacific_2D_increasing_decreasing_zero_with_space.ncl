begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/Final_figures/"
f3=addfile(dir0+"dissic_flat10_cdr_r192x96_1850-2299_lon_190.nc","r")
tot_flt=f3->dissic(:,:,:,0) ; time x depth x lat
g3=addfile(dir0+"dissicnat_flat10_cdr_r192x96_1850-2299_lon_190.nc","r")
nat_flt=g3->dissicnat(:,:,:,0)
ant_flt=tot_flt-nat_flt
copy_VarCoords(tot_flt,ant_flt)
flt_tot_an=month_to_annual(tot_flt,1)
flt_nat_an=month_to_annual(nat_flt,1)
flt_ant_an=month_to_annual(ant_flt,1)

g1=addfile(dir0+"preformed_DIC_flat10_cdr_r192x96_1850-2299_lon_190.nc","r")
pre_flt=g1->preformed_DIC(:,:,:,0)
pre_flt=pre_flt*1000
reg_flt=tot_flt-pre_flt
copy_VarCoords(pre_flt,reg_flt)
flt_reg_an=month_to_annual(reg_flt,1)

k3=addfile(dir0+"preformed_PO4_flat10_cdr_r192x96_1850-2299_lon_190.nc","r")
pre_po4=k3->preformed_PO4(:,:,:,0)
pre_po4=pre_po4*1000
pre_po4_an=month_to_annual(pre_po4,1)
h3=addfile(dir0+"po4_flat10_cdr_r192x96_1850-2299_lon_190.nc","r")
po4_an=h3->po4(:,:,:,0)

reg_om_an=(po4_an-pre_po4_an)*122
copy_VarCoords(po4_an,reg_om_an)
reg_caco3_an=flt_reg_an-reg_om_an
copy_VarCoords(po4_an,reg_caco3_an)

dim=dimsizes(tot_flt)
First=new((/6,dim(1),dim(2)/),typeof(flt_tot_an))
First(0,:,:)=dim_avg_n_Wrap(flt_tot_an(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(flt_nat_an(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(flt_ant_an(0:29,:,:),0)
First(3,:,:)=dim_avg_n_Wrap(flt_reg_an(0:29,:,:),0)
First(4,:,:)=dim_avg_n_Wrap(reg_om_an(0:29,:,:),0)
First(5,:,:)=dim_avg_n_Wrap(reg_caco3_an(0:29,:,:),0)
First!0="Variables"

Middle=new((/6,dim(1),dim(2)/),typeof(flt_tot_an))
Middle(0,:,:)=dim_avg_n_Wrap(flt_tot_an(135:164,:,:),0)
Middle(1,:,:)=dim_avg_n_Wrap(flt_nat_an(135:164,:,:),0)
Middle(2,:,:)=dim_avg_n_Wrap(flt_ant_an(135:164,:,:),0)
Middle(3,:,:)=dim_avg_n_Wrap(flt_reg_an(135:164,:,:),0)
Middle(4,:,:)=dim_avg_n_Wrap(reg_om_an(135:164,:,:),0)
Middle(5,:,:)=dim_avg_n_Wrap(reg_caco3_an(135:164,:,:),0)
Middle!0="scenarios"

Last=new((/6,dim(1),dim(2)/),typeof(flt_tot_an))
Last(0,:,:)=dim_avg_n_Wrap(flt_tot_an(270:299,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(flt_nat_an(270:299,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(flt_ant_an(270:299,:,:),0)
Last(3,:,:)=dim_avg_n_Wrap(flt_reg_an(270:299,:,:),0)
Last(4,:,:)=dim_avg_n_Wrap(reg_om_an(270:299,:,:),0)
Last(5,:,:)=dim_avg_n_Wrap(reg_caco3_an(270:299,:,:),0)
Last!0="scenarios"

Last1=new((/6,dim(1),dim(2)/),typeof(flt_tot_an))
Last1(0,:,:)=dim_avg_n_Wrap(flt_tot_an(285:314,:,:),0)
Last1(1,:,:)=dim_avg_n_Wrap(flt_nat_an(285:314,:,:),0)
Last1(2,:,:)=dim_avg_n_Wrap(flt_ant_an(285:314,:,:),0)
Last1(3,:,:)=dim_avg_n_Wrap(flt_reg_an(285:314,:,:),0)
Last1(4,:,:)=dim_avg_n_Wrap(reg_om_an(285:314,:,:),0)
Last1(5,:,:)=dim_avg_n_Wrap(reg_caco3_an(285:314,:,:),0)
Last1!0="scenarios"

Last2=new((/6,dim(1),dim(2)/),typeof(flt_tot_an))
Last2(0,:,:)=dim_avg_n_Wrap(flt_tot_an(420:449,:,:),0)
Last2(1,:,:)=dim_avg_n_Wrap(flt_nat_an(420:449,:,:),0)
Last2(2,:,:)=dim_avg_n_Wrap(flt_ant_an(420:449,:,:),0)
Last2(3,:,:)=dim_avg_n_Wrap(flt_reg_an(420:449,:,:),0)
Last2(4,:,:)=dim_avg_n_Wrap(reg_om_an(420:449,:,:),0)
Last2(5,:,:)=dim_avg_n_Wrap(reg_caco3_an(420:449,:,:),0)
Last2!0="scenarios"

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)
Last_Middle=Last_Middle*1000
Middle_First=Middle_First*1000
Last2_Last1=Last2_Last1*1000

plot=new(6,graphic)
plot2=new(6,graphic)
plot3=new(6,graphic)
wks   = gsn_open_wks ("pdf", dir1+"2D_vertical_CDR_DICs_Regs_Pacific_with_space_zero" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLevelSelectionMode   =       "ManualLevels"
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@gsnDraw                =       False
res@gsnFrame               =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@gsnCenterStringFontHeightF= 0.055
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04

res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@cnMaxLevelValF         =     200
res@cnMinLevelValF         =     -200
res@cnLevelSpacingF        =      20
res@gsnCenterString="DIC~B~tot~N~"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
res@tmXBLabelsOn        = False
res@tmYLLabelsOn        = True
plot(0)  = gsn_csm_contour(wks, Middle_First(0,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnCenterString="DIC~B~nat~N~"
plot(2)  = gsn_csm_contour(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString="DIC~B~ant~N~"
plot(1)  = gsn_csm_contour(wks, Middle_First(2,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnCenterString="DIC~B~tot,reg~N~"
plot(3)  = gsn_csm_contour(wks, Middle_First(3,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = False
res@gsnCenterString="DIC~B~tot,reg_soft~N~"
res@tiYAxisString=""
plot(4)  = gsn_csm_contour(wks, Middle_First(4,:,:), res )   ; plaace holder
res@gsnCenterString="DIC~B~tot,reg_CaCO~B~3~N~"
plot(5)  = gsn_csm_contour(wks, Middle_First(5,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnCenterString="DIC~B~tot~N~"
plot2(0)  = gsn_csm_contour(wks, Last_Middle(0,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnCenterString="DIC~B~nat~N~"
plot2(2)  = gsn_csm_contour(wks, Last_Middle(1,:,:),res )   ; plaace holder
res@gsnCenterString="DIC~B~ant~N~"
plot2(1)  = gsn_csm_contour(wks, Last_Middle(2,:,:), res )   ; plaace holder
res@tiYAxisString="Depth (m)"
res@gsnCenterString="DIC~B~tot,reg~N~"
res@tmYLLabelsOn        = True
plot2(3)  = gsn_csm_contour(wks, Last_Middle(3,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = False
res@gsnCenterString="DIC~B~tot,reg_soft~N~"
res@tiYAxisString=""
plot2(4)  = gsn_csm_contour(wks, Last_Middle(4,:,:), res )   ; plaace holder
res@gsnCenterString="DIC~B~tot,reg_CaCO~B~3~N~"
plot2(5)  = gsn_csm_contour(wks, Last_Middle(5,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnCenterString="DIC~B~tot~N~"
plot3(0)  = gsn_csm_contour(wks, Last2_Last1(0,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnCenterString="DIC~B~nat~N~"
plot3(2)  = gsn_csm_contour(wks, Last2_Last1(1,:,:),res )   ; plaace holder
res@gsnCenterString="DIC~B~ant~N~"
plot3(1)  = gsn_csm_contour(wks, Last2_Last1(2,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = True
res@tmXBLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnCenterString="DIC~B~tot,reg~N~"
plot3(3)  = gsn_csm_contour(wks, Last2_Last1(3,:,:), res )   ; plaace holder
res@tmYLLabelsOn        = False
res@gsnCenterString="DIC~B~tot,reg_soft~N~"
res@tiYAxisString=""
plot3(4)  = gsn_csm_contour(wks, Last2_Last1(4,:,:), res )   ; plaace holder
res@gsnCenterString="DIC~B~tot,reg_CaCO~B~3~N~"
plot3(5)  = gsn_csm_contour(wks, Last2_Last1(5,:,:), res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 4
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.9
pres@gsnPanelLabelBar      = False
pres2=pres
pres3=pres
pres@gsnPanelTop=1.
pres@gsnPanelBottom=0.70
pres2@gsnPanelTop=0.69
pres2@gsnPanelBottom=0.39

pres3@gsnPanelTop=0.38
pres3@gsnPanelBottom=0.04
pres3@gsnPanelLeft=0.05
pres3@gsnPanelRight=0.95
pres3@gsnPanelLabelBar      = True
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.017
gsn_text_ndc(wks,"Positive emissions",0.12,0.84,txres1)
gsn_text_ndc(wks,"Negative emissions",0.12,0.53,txres1)
gsn_text_ndc(wks,"Zero emissions",0.12,0.22,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mmol/m~S~3~N~]",0.84,0.045,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)

end
