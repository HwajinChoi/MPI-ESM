begin
dir0="/work/uo1451/m301158/MPI-ESM/data/Test_advection/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"tsco212nat_h_v_advs_r192x96_mul_dz_0-1000m_1850-2298.nc","r")
vadv=f->tsco212nat_vadv
hadv=f->tsco212nat_hadv

dim=dimsizes(vadv)

adv=new((/2,dim(0),dim(1),dim(2)/),typeof(vadv))
adv_ano=new((/2,dim(0),dim(1),dim(2)/),typeof(vadv))
adv(0,:,:,:)=hadv
adv(1,:,:,:)=vadv

adv=adv*365.25*86400
adv_clim=dim_avg_n_Wrap(adv,1)

do i=0,449-1
 adv_ano(:,i,:,:)=adv(:,i,:,:)-adv_clim
end do
copy_VarCoords(adv,adv_ano)

adv_ano_cumsum=dim_cumsum_n_Wrap(adv_ano,1,1)

First=new((/2,dim(1),dim(2)/),typeof(adv))
Middle=new((/2,dim(1),dim(2)/),typeof(adv))
Last=new((/2,dim(1),dim(2)/),typeof(adv))
Last1=new((/2,dim(1),dim(2)/),typeof(adv))
Last2=new((/2,dim(1),dim(2)/),typeof(adv))

First=dim_avg_n_Wrap(adv_ano_cumsum(:,0:29,:,:),1)
Middle=dim_avg_n_Wrap(adv_ano_cumsum(:,135:164,:,:),1)
Last=dim_avg_n_Wrap(adv_ano_cumsum(:,270:299,:,:),1)
Last1=dim_avg_n_Wrap(adv_ano_cumsum(:,285:314,:,:),1)
Last2=dim_avg_n_Wrap(adv_ano_cumsum(:,420:448,:,:),1)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)
;----------------------------------------------------------------------------------------------------------
plot=new(6,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_DICnat_cumsum_without_mean_3phases_diff_Advection_terms_0-1000m" )
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

res@gsnCenterStringFontHeightF= 0.04
res@gsnCenterStringOrthogonalPosF=0.1
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="horizontal"

res@cnFillPalette        = "GMT_polar"
res@gsnCenterString="Horizontal adv."
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     120
res@cnMinLevelValF         =     -120
res@cnLevelSpacingF        =      20
res@lbLabelBarOn           = False
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString="Vertical adv."
plot(1)  = gsn_csm_contour_map(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString=""
res@lbLabelBarOn           = False
plot(2)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:), res )   ; plaace holder
plot(3)  = gsn_csm_contour_map(wks, Last_Middle(1,:,:),res )   ; plaace holder
res@lbLabelBarOn           = True
plot(4)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:), res )   ; plaace holder
plot(5)  = gsn_csm_contour_map(wks, Last2_Last1(1,:,:),res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 15
pres@gsnPanelXWhiteSpacePercent = 3
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.9
pres@gsnPanelLabelBar      = False
pres2=pres
pres3=pres

pres@gsnPanelLabelBar      = False
pres@lbLabelFontHeightF  = 0.013
pres@lbLabelStride     =   4
pres3@gsnPanelLabelBar      = False
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.020
gsn_text_ndc(wks,"Positive ",0.05,0.77,txres1)
gsn_text_ndc(wks,"emissions",0.08,0.77,txres1)
gsn_text_ndc(wks,"Negative",0.05,0.47,txres1)
gsn_text_ndc(wks,"emissions",0.08,0.47,txres1)
gsn_text_ndc(wks,"Zero",0.05,0.15,txres1)
gsn_text_ndc(wks,"emissions",0.08,0.15,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.91,0.08,txres2)
gsn_panel(wks,plot,(/3,2/),pres)
frame(wks)

end
