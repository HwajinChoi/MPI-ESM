begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
tot=f->tsco212_tot ; time 450 lat 96 lon 192
adv=f->tsco212_adv
dif=f->tsco212_dif
gm=f->tsco212_gm
sosi=f->tsco212_sosi
surf=f->tsco212_surf

tot_cum=dim_cumsum_Wrap(tot,0)
adv_cum=dim_cumsum_Wrap(adv,0)
dif_cum=dim_cumsum_Wrap(dif,0)
gm_cum=dim_cumsum_Wrap(gm,0)
sosi_cum=dim_cumsum_Wrap(sosi,0)
surf_cum=dim_cumsum_Wrap(surf,0)

dim=dimsizes(tot)

first=new((/6,30,dim(1),dim(2)/),typeof(tot))
middle=new((/6,30,dim(1),dim(2)/),typeof(tot))
last=new((/6,30,dim(1),dim(2)/),typeof(tot))
last1=new((/6,30,dim(1),dim(2)/),typeof(tot))
last2=new((/6,30,dim(1),dim(2)/),typeof(tot))

first(0,:,:,:)=tot(0:29,:,:)
middle(0,:,:,:)=tot(135:164,:,:)
last(0,:,:,:)=tot(270:299,:,:)
last1(0,:,:,:)=tot(285:314,:,:)
last2(0,:,:,:)=tot(420:449,:,:)

first(1,:,:,:)=adv(0:29,:,:)
middle(1,:,:,:)=adv(135:164,:,:)
last(1,:,:,:)=adv(270:299,:,:)
last1(1,:,:,:)=adv(285:314,:,:)
last2(1,:,:,:)=adv(420:449,:,:)

first(2,:,:,:)=dif(0:29,:,:)
middle(2,:,:,:)=dif(135:164,:,:)
last(2,:,:,:)=dif(270:299,:,:)
last1(2,:,:,:)=dif(285:314,:,:)
last2(2,:,:,:)=dif(420:449,:,:)

first(3,:,:,:)=gm(0:29,:,:)
middle(3,:,:,:)=gm(135:164,:,:)
last(3,:,:,:)=gm(270:299,:,:)
last1(3,:,:,:)=gm(285:314,:,:)
last2(3,:,:,:)=gm(420:449,:,:)

first(4,:,:,:)=sosi(0:29,:,:)
middle(4,:,:,:)=sosi(135:164,:,:)
last(4,:,:,:)=sosi(270:299,:,:)
last1(4,:,:,:)=sosi(285:314,:,:)
last2(4,:,:,:)=sosi(420:449,:,:)

first(5,:,:,:)=surf(0:29,:,:)
middle(5,:,:,:)=surf(135:164,:,:)
last(5,:,:,:)=surf(270:299,:,:)
last1(5,:,:,:)=surf(285:314,:,:)
last2(5,:,:,:)=surf(420:449,:,:)

first_clim=dim_avg_n_Wrap(first,1)
middle_clim=dim_avg_n_Wrap(middle,1)
last_clim=dim_avg_n_Wrap(last,1)
last2_clim=dim_avg_n_Wrap(last2,1)
last1_clim=dim_avg_n_Wrap(last1,1)

last_middle=last_clim-middle_clim
middle_first=middle_clim-first_clim
last2_last1=last2_clim-last1_clim
copy_VarCoords(last_clim,last_middle)
copy_VarCoords(last_clim,middle_first)
copy_VarCoords(last_clim,last2_last1)


last_middle=last_middle*1000*1000
middle_first=middle_first*1000*1000
last2_last1=last2_last1*1000*1000

plot=new(6,graphic)
plot3=new(6,graphic)
plot2=new(6,graphic)

wks   = gsn_open_wks ("png", dir1+"Map_CDR_DICtot_3phases_diff_cumsum_Budget_terms_0-1000m" )          ; send graphics to PNG file
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
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"

res@cnFillPalette        = "GMT_polar"
res@lbLabelBarOn           = True
res@gsnCenterString="Tendency"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     0.05
res@cnMinLevelValF         =     -0.05
res@cnLevelSpacingF        =      0.01
;printMinMax(Inc_avg(0,:,:),0)
;exit
plot(0)  = gsn_csm_contour_map(wks, middle_first(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Advection"
plot(1)  = gsn_csm_contour_map(wks, middle_first(1,:,:),res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Diffusion"
plot(2)  = gsn_csm_contour_map(wks,middle_first(2,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="GM"
plot(3)  = gsn_csm_contour_map(wks, middle_first(3,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source&sink"
plot(4)  = gsn_csm_contour_map(wks, middle_first(4,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Surf"
plot(5)  = gsn_csm_contour_map(wks, middle_first(5,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.00005
;res@cnMinLevelValF         =     -0.00005
;res@cnLevelSpacingF        =      0.00001
res@gsnCenterString="Tendency"
plot2(0)  = gsn_csm_contour_map(wks, last_middle(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Advection"
plot2(1)  = gsn_csm_contour_map(wks, last_middle(1,:,:),res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Diffusion"
plot2(2)  = gsn_csm_contour_map(wks, last_middle(2,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="GM"
plot2(3)  = gsn_csm_contour_map(wks, last_middle(3,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source&sink"
plot2(4)  = gsn_csm_contour_map(wks, last_middle(4,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Surf"
plot2(5)  = gsn_csm_contour_map(wks, last_middle(5,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.00005
;res@cnMinLevelValF         =     -0.00005
;res@cnLevelSpacingF        =      0.00001
res@gsnCenterString="Tendency"
plot3(0)  = gsn_csm_contour_map(wks, last2_last1(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Advection"
plot3(1)  = gsn_csm_contour_map(wks, last2_last1(1,:,:),res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Diffusion"
plot3(2)  = gsn_csm_contour_map(wks, last2_last1(2,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="GM"
plot3(3)  = gsn_csm_contour_map(wks, last2_last1(3,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source&sink"
plot3(4)  = gsn_csm_contour_map(wks, last2_last1(4,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Surf"
plot3(5)  = gsn_csm_contour_map(wks, last2_last1(5,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001

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
gsn_text_ndc(wks,"[micro mol/m~S~2~N~ s~S~1~N~]",0.84,0.035,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)

end
