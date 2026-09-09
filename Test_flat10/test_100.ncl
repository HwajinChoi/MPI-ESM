begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_mul_dz_1000-3000m_r192x96_1850_2299.nc","r")
tot=f->tsco212nat_tot ; time 450 lat 96 lon 192
adv=f->tsco212nat_adv
dif=f->tsco212nat_dif
gm=f->tsco212nat_gm
sosi=f->tsco212nat_sosi
surf=f->tsco212nat_surf
dim=dimsizes(tot)

others=dif+gm+surf
copy_VarCoords(tot,others)

Bud=new((/4,dim(0),dim(1),dim(2)/),typeof(tot))
Bud_ano=new((/4,dim(0),dim(1),dim(2)/),typeof(tot))
Bud(0,:,:,:)=tot
Bud(1,:,:,:)=adv
Bud(2,:,:,:)=sosi
Bud(3,:,:,:)=others

Bud=Bud*365.25*86400

Bud_clim=dim_avg_n_Wrap(Bud,1)

do i=0,450-1
 Bud_ano(:,i,:,:)=Bud(:,i,:,:)-Bud_clim
end do
copy_VarCoords(Bud,Bud_ano)

Bud_ano_cumsum=dim_cumsum_n_Wrap(Bud,1,1)

First=new((/4,dim(1),dim(2)/),typeof(tot))
Middle=new((/4,dim(1),dim(2)/),typeof(tot))
Last=new((/4,dim(1),dim(2)/),typeof(tot))
Last1=new((/4,dim(1),dim(2)/),typeof(tot))
Last2=new((/4,dim(1),dim(2)/),typeof(tot))

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
plot=new(12,graphic)
;plot=new(4,graphic)
;plot3=new(4,graphic)
;plot2=new(4,graphic)

wks   = gsn_open_wks ("png", dir1+"test_Supple_Map_CDR_DICnat_cumsum_without_mean_3phases_diff_Budget_terms_1000-3000m" )
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
res@gsnCenterString="Tendency"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     120
res@cnMinLevelValF         =     -120
res@cnLevelSpacingF        =      20
;printMinMax(Inc_avg(0,:,:),0)
;exit
res@lbLabelBarOn           = False
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString="Advection"
plot(1)  = gsn_csm_contour_map(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sink"
plot(2)  = gsn_csm_contour_map(wks,Middle_First(2,:,:), res )   ; plaace holder
res@gsnCenterString="Diffusion"
res@lbLabelBarOn           = True
plot(3)  = gsn_csm_contour_map(wks, Middle_First(3,:,:), res )   ; plaace holder

res@gsnCenterString=""
res@lbLabelBarOn           = False
plot(4)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:), res )   ; plaace holder
;res@gsnCenterString="Advection"
plot(5)  = gsn_csm_contour_map(wks, Last_Middle(1,:,:),res )   ; plaace holder
;res@gsnCenterString="Source&sink"
plot(6)  = gsn_csm_contour_map(wks, Last_Middle(2,:,:), res )   ; plaace holder
;res@gsnCenterString="Residual"
res@lbLabelBarOn           = True
plot(7)  = gsn_csm_contour_map(wks, Last_Middle(3,:,:), res )   ; plaace holder

;res@gsnCenterString="Tendency"
res@lbLabelBarOn           = False
plot(8)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:), res )   ; plaace holder
;res@gsnCenterString="Advection"
plot(9)  = gsn_csm_contour_map(wks, Last2_Last1(1,:,:),res )   ; plaace holder
;res@gsnCenterString="Source&sink"
plot(10)  = gsn_csm_contour_map(wks, Last2_Last1(2,:,:), res )   ; plaace holder
res@lbLabelBarOn           = True
;res@gsnCenterString="Residual"
plot(11)  = gsn_csm_contour_map(wks, Last2_Last1(3,:,:), res )   ; plaace holder

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
;pres@gsnPanelTop=1.
;pres@gsnPanelBottom=0.70
;pres2@gsnPanelTop=0.69
;pres2@gsnPanelBottom=0.39

pres@gsnPanelLabelBar      = False
pres@lbLabelFontHeightF  = 0.013
pres@lbLabelStride     =   4
;pres3@gsnPanelTop=0.38
;pres3@gsnPanelBottom=0.04
;pres3@gsnPanelLeft=0.11
;pres3@gsnPanelRight=0.89
pres3@gsnPanelLabelBar      = False
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"Positive ",0.05,0.65,txres1)
gsn_text_ndc(wks,"emissions",0.07,0.65,txres1)
gsn_text_ndc(wks,"Negative",0.05,0.49,txres1)
gsn_text_ndc(wks,"emissions",0.07,0.49,txres1)
gsn_text_ndc(wks,"Zero",0.05,0.33,txres1)
gsn_text_ndc(wks,"emissions",0.07,0.33,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.91,0.25,txres2)
gsn_panel(wks,plot,(/3,4/),pres)
;gsn_panel(wks,plot2,(/1,4/),pres2)
;gsn_panel(wks,plot3,(/1,4/),pres3)
frame(wks)

end
