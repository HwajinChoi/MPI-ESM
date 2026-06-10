begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"flat10_cdr_001_sedi_r192x96_1850-2299.nc","r")
dic=f->sedfludic(:,0,:,:)
alk=f->sedflualk(:,0,:,:)
po4=f->sedflupo4(:,0,:,:)

dic = dic*365.25*86400*(10^3)
alk = alk*365.25*86400*(10^3)
po4 = po4*365.25*86400*(10^3)

dic_cumsum=dim_cumsum_n_Wrap(dic,1,0)
alk_cumsum=dim_cumsum_n_Wrap(alk,1,0)
po4_cumsum=dim_cumsum_n_Wrap(po4,1,0)

dic_0_150=dic_cumsum(149,:,:)
dic_150_300=dic_cumsum(299,:,:)-dic_cumsum(149,:,:)
dic_300_450=dic_cumsum(449,:,:)-dic_cumsum(299,:,:)

alk_0_150=alk_cumsum(149,:,:)
alk_150_300=alk_cumsum(299,:,:)-alk_cumsum(149,:,:)
alk_300_450=alk_cumsum(449,:,:)-alk_cumsum(299,:,:)

po4_0_150=po4_cumsum(149,:,:)
po4_150_300=po4_cumsum(299,:,:)-po4_cumsum(149,:,:)
po4_300_450=po4_cumsum(449,:,:)-po4_cumsum(299,:,:)

copy_VarCoords(dic(0,:,:),dic_0_150)
copy_VarCoords(dic(0,:,:),dic_150_300)
copy_VarCoords(dic(0,:,:),dic_300_450)

copy_VarCoords(alk(0,:,:),alk_0_150)
copy_VarCoords(alk(0,:,:),alk_150_300)
copy_VarCoords(alk(0,:,:),alk_300_450)

copy_VarCoords(po4(0,:,:),po4_0_150)
copy_VarCoords(po4(0,:,:),po4_150_300)
copy_VarCoords(po4(0,:,:),po4_300_450)

plot=new(9,graphic)
wks   = gsn_open_wks ("png", dir2+"Map_CDR_sedi_ano_each_phase_for_450years" )

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
res@cnFillPalette        = "BlueDarkRed18"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"
res@lbLabelBarOn           = True
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     100.
res@cnMinLevelValF         =    -100.
res@cnLevelSpacingF        =      20.
res@gsnCenterString="sed_dic"
plot(0)  = gsn_csm_contour_map(wks, dic_0_150, res )   ; plaace holder
res@gsnCenterString=""
plot(3)  = gsn_csm_contour_map(wks, dic_150_300,res )
plot(6)  = gsn_csm_contour_map(wks, dic_300_450,res )
res@cnMaxLevelValF         =     30.
res@cnMinLevelValF         =     -30.
res@cnLevelSpacingF        =     5.
res@gsnCenterString="sed_alk"
plot(1)  = gsn_csm_contour_map(wks, alk_0_150,res )   ; plaace holder
res@gsnCenterString=""
plot(4)  = gsn_csm_contour_map(wks, alk_150_300,res )
plot(7)  = gsn_csm_contour_map(wks, alk_300_450,res )
res@gsnCenterString=""
res@gsnCenterString="sed_po4"
res@cnMaxLevelValF         =     1.
res@cnMinLevelValF         =     -1.
res@cnLevelSpacingF        =      0.2
plot(2)  = gsn_csm_contour_map(wks, po4_0_150,res )   ; plaace holder
res@gsnCenterString=""
plot(5)  = gsn_csm_contour_map(wks, po4_150_300,res )
plot(8)  = gsn_csm_contour_map(wks, po4_300_450,res )

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 4
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.9
pres@gsnPanelLabelBar      = False
txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.011
gsn_text_ndc(wks,"Positive emissions",0.06,0.63,txres1)
gsn_text_ndc(wks,"Negative emissions",0.06,0.48,txres1)
gsn_text_ndc(wks,"Zero emissions",0.06,0.35,txres1)

txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mol C/m~S~2~N~]",0.23,0.27,txres2)
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.49,0.27,txres2)
gsn_text_ndc(wks,"[mol P/m~S~2~N~]",0.75,0.27,txres2)

gsn_panel(wks,plot,(/3,3/),pres)
frame(wks)

end
