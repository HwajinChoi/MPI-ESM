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

dim=dimsizes(dic)
sedi=new((/3,dim(0),dim(1),dim(2)/),typeof(dic))
sedi_ano=new((/3,dim(0),dim(1),dim(2)/),typeof(dic))
sedi(0,:,:,:)=dic
sedi(1,:,:,:)=alk
sedi(2,:,:,:)=po4

sedi_clim=dim_avg_n_Wrap(sedi,1)

do i=0,450-1
 sedi_ano(:,i,:,:)=sedi(:,i,:,:)-sedi_clim
end do
copy_VarCoords(sedi,sedi_ano)

sedi_ano_cumsum=dim_cumsum_n_Wrap(sedi_ano,1,1)

First=new((/3,dim(1),dim(2)/),typeof(dic))
Middle=new((/3,dim(1),dim(2)/),typeof(dic))
Last=new((/3,dim(1),dim(2)/),typeof(dic))
Last1=new((/3,dim(1),dim(2)/),typeof(dic))
Last2=new((/3,dim(1),dim(2)/),typeof(dic))

First=dim_avg_n_Wrap(sedi_ano_cumsum(:,0:29,:,:),1)
Middle=dim_avg_n_Wrap(sedi_ano_cumsum(:,135:164,:,:),1)
Last=dim_avg_n_Wrap(sedi_ano_cumsum(:,270:299,:,:),1)
Last1=dim_avg_n_Wrap(sedi_ano_cumsum(:,285:314,:,:),1)
Last2=dim_avg_n_Wrap(sedi_ano_cumsum(:,420:449,:,:),1)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)
;----------------------------------------------------------------------------------------------------------
plot=new(9,graphic)
wks   = gsn_open_wks ("png", dir2+"Map_CDR_sedi_cumsum_without_mean_3phases_diff" )

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
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(3)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:),res )
plot(6)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:),res )
res@cnMaxLevelValF         =     16.
res@cnMinLevelValF         =     -16.
res@cnLevelSpacingF        =     4.
res@gsnCenterString="sed_alk"
plot(1)  = gsn_csm_contour_map(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString=""
plot(4)  = gsn_csm_contour_map(wks, Last_Middle(1,:,:),res )
plot(7)  = gsn_csm_contour_map(wks, Last2_Last1(1,:,:),res )
res@gsnCenterString=""
res@gsnCenterString="sed_po4"
res@cnMaxLevelValF         =    0.6
res@cnMinLevelValF         =     -0.6
res@cnLevelSpacingF        =      0.1
plot(2)  = gsn_csm_contour_map(wks, Middle_First(2,:,:),res )   ; plaace holder
res@gsnCenterString=""
plot(5)  = gsn_csm_contour_map(wks, Last_Middle(2,:,:),res )
plot(8)  = gsn_csm_contour_map(wks, Last2_Last1(2,:,:),res )

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
