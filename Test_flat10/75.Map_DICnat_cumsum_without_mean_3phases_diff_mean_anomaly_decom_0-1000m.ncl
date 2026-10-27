begin
dir1="/work/uo1451/m301158/MPI-ESM/data/Test_advection/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"DIC_horizontal_advection_r192x96_mul_dz_0-1000m_1850-2299.nc","r")

HmeanCprime=f->advH_meanCprime
HprimeCmean=f->advH_primeCmean
HprimeCprime=f->advH_primeCprime

g=addfile(dir1+"DIC_vertical_advection_r192x96_mul_dz_0-1000m_1850-2299.nc","r")
VmeanCprime=g->advV_meanCprime
VprimeCmean=g->advV_primeCmean
VprimeCprime=g->advV_primeCprime

dim=dimsizes(HmeanCprime)
Bud=new((/6,dim(0),dim(1),dim(2)/),typeof(HmeanCprime))
Bud(0,:,:,:)=HmeanCprime
Bud(1,:,:,:)=HprimeCmean
Bud(2,:,:,:)=HprimeCprime
Bud(3,:,:,:)=VmeanCprime
Bud(4,:,:,:)=VprimeCmean
Bud(5,:,:,:)=VprimeCprime

Bud=Bud*365.25*86400

Bud_ano_cumsum=dim_cumsum_n_Wrap(Bud,1,1)

First=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Middle=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Last=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Last1=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Last2=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))

First=dim_avg_n_Wrap(Bud_ano_cumsum(:,0:29,:,:),1)
Middle=dim_avg_n_Wrap(Bud_ano_cumsum(:,135:164,:,:),1)
Last=dim_avg_n_Wrap(Bud_ano_cumsum(:,270:299,:,:),1)
Last1=dim_avg_n_Wrap(Bud_ano_cumsum(:,285:314,:,:),1)
Last2=dim_avg_n_Wrap(Bud_ano_cumsum(:,420:449,:,:),1)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)
;----------------------------------------------------------------------------------------------------------
plot=new(6,graphic)
plot3=new(6,graphic)
plot2=new(6,graphic)

wks   = gsn_open_wks ("png", dir2+"Map_CDR_DICnat_cumsum_without_mean_3phases_anomaly_decom_0-1000m" )
res                      = True                 ; plot mods desired
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@lbLabelFontHeightF  = 0.023
res@vpHeightF      = 0.5
res@gsnDraw                =       False
res@gsnFrame               =       False
res@cnLineLabelsOn         =       False
res@cnFillOn             = True                 ; turn on color fill
res@cnInfoLabelOn          =   False

res@cnLinesOn=False
res@cnFillPalette        = "GMT_polar"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =-50
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.1
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"

res@cnFillPalette        = "GMT_polar"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     120
res@cnMinLevelValF         =     -120
res@cnLevelSpacingF        =      20
;printMinMax(Inc_avg(0,:,:),0)
;exit
res@lbLabelBarOn           = False
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~H-~h~N~C~S~'~N~)"
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~S~'~N~h~N~C~H-~)"
plot(1)  = gsn_csm_contour_map(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~S~'~N~h~N~C~S~'~N~)"
plot(2)  = gsn_csm_contour_map(wks,Middle_First(2,:,:), res )   ; plaace holder
res@gsnCenterString="w~H-~C~S~'~N~"
plot(3)  = gsn_csm_contour_map(wks, Middle_First(3,:,:), res )   ; plaace holder
res@gsnCenterString="w~S~'~N~C~H-~"
plot(4)  = gsn_csm_contour_map(wks, Middle_First(4,:,:), res )   ; plaace holder
res@gsnCenterString="w~S~'~N~C~S~'~N~"
plot(5)  = gsn_csm_contour_map(wks, Middle_First(5,:,:), res )   ; plaace holder

res@gsnCenterString="-~F8~∇~F21~h~N~·(u~H-~h~N~C~S~'~N~)"
plot2(0)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:), res )   ; plaace holder
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~S~'~N~h~N~C~H-~)"
plot2(1)  = gsn_csm_contour_map(wks, Last_Middle(1,:,:),res )   ; plaace holder
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~S~'~N~h~N~C~S~'~N~)"
plot2(2)  = gsn_csm_contour_map(wks,Last_Middle(2,:,:), res )   ; plaace holder
res@gsnCenterString="w~H-~C~S~'~N~"
plot2(3)  = gsn_csm_contour_map(wks, Last_Middle(3,:,:), res )   ; plaace holder
res@gsnCenterString="w~S~'~N~C~H-~"
plot2(4)  = gsn_csm_contour_map(wks, Last_Middle(4,:,:), res )   ; plaace holder
res@gsnCenterString="w~S~'~N~C~S~'~N~"
plot2(5)  = gsn_csm_contour_map(wks, Last_Middle(5,:,:), res )   ; plaace holder

res@gsnCenterString="-~F8~∇~F21~h~N~·(u~H-~h~N~C~S~'~N~)"
plot3(0)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:), res )   ; plaace holder
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~S~'~N~h~N~C~H-~)"
plot3(1)  = gsn_csm_contour_map(wks, Last2_Last1(1,:,:),res )   ; plaace holder
res@gsnCenterString="-~F8~∇~F21~h~N~·(u~S~'~N~h~N~C~S~'~N~)"
plot3(2)  = gsn_csm_contour_map(wks,Last2_Last1(2,:,:), res )   ; plaace holder
res@gsnCenterString="w~H-~C~S~'~N~"
plot3(3)  = gsn_csm_contour_map(wks, Last2_Last1(3,:,:), res )   ; plaace holder
res@gsnCenterString="w~S~'~N~C~H-~"
plot3(4)  = gsn_csm_contour_map(wks, Last2_Last1(4,:,:), res )   ; plaace holder
res@gsnCenterString="w~S~'~N~C~S~'~N~"
plot3(5)  = gsn_csm_contour_map(wks, Last2_Last1(5,:,:), res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 3
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
pres3@gsnPanelLeft=0.11
pres3@gsnPanelRight=0.89
pres3@gsnPanelLabelBar      = False
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.017
gsn_text_ndc(wks,"Positive emissions",0.06,0.84,txres1)
gsn_text_ndc(wks,"Negative emissions",0.06,0.53,txres1)
gsn_text_ndc(wks,"Zero emissions",0.06,0.22,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.84,0.1,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)

end
