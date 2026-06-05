begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
tot1=f->tsco212_tot ; time 450 lat 96 lon 192
adv1=f->tsco212_adv
dif1=f->tsco212_dif
gm1=f->tsco212_gm
sosi1=f->tsco212_sosi
surf1=f->tsco212_surf
dim=dimsizes(tot1)

g=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
tot2=g->tsco212nat_tot ; time 450 lat 96 lon 192
adv2=g->tsco212nat_adv
dif2=g->tsco212nat_dif
gm2=g->tsco212nat_gm
sosi2=g->tsco212nat_sosi
surf2=g->tsco212nat_surf

tot=tot1-tot2
adv=adv1-adv2
dif=dif1-dif2
gm=gm1-gm2
sosi=sosi1-sosi2
surf=surf1-surf2

adv := adv+gm
copy_VarCoords(tot1,tot)
copy_VarCoords(adv1,adv)
copy_VarCoords(sosi1,sosi)
copy_VarCoords(dif1,dif)
copy_VarCoords(gm1,gm)
copy_VarCoords(surf1,surf)

Bud=new((/5,dim(0),dim(1),dim(2)/),typeof(tot))
Bud_ano=new((/5,dim(0),dim(1),dim(2)/),typeof(tot))
Bud(0,:,:,:)=tot
Bud(1,:,:,:)=adv
Bud(2,:,:,:)=dif
Bud(3,:,:,:)=sosi
Bud(4,:,:,:)=surf

Bud=Bud*365.25*86400

Bud_clim=dim_avg_n_Wrap(Bud,1)

do i=0,450-1
 Bud_ano(:,i,:,:)=Bud(:,i,:,:)-Bud_clim
end do
copy_VarCoords(Bud,Bud_ano)

Bud_ano_cumsum=dim_cumsum_n_Wrap(Bud_ano,1,1)

First=new((/5,dim(1),dim(2)/),typeof(tot))
Middle=new((/5,dim(1),dim(2)/),typeof(tot))
Last=new((/5,dim(1),dim(2)/),typeof(tot))
Last1=new((/5,dim(1),dim(2)/),typeof(tot))
Last2=new((/5,dim(1),dim(2)/),typeof(tot))

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
plot=new(5,graphic)
plot3=new(5,graphic)
plot2=new(5,graphic)

wks   = gsn_open_wks ("png", dir1+"Map_CDR_DICant_cumsum_without_mean_3phases_diff_Budget_terms_0-1000m" )          ; send graphics to PNG file
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
res@gsnCenterString="Change"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     120
res@cnMinLevelValF         =     -120
res@cnLevelSpacingF        =      20
;printMinMax(Inc_avg(0,:,:),0)
;exit
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString="Advection+GM"
plot(1)  = gsn_csm_contour_map(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot(2)  = gsn_csm_contour_map(wks,Middle_First(2,:,:), res )   ; plaace holder
res@gsnCenterString="Source&sink"
plot(3)  = gsn_csm_contour_map(wks, Middle_First(3,:,:), res )   ; plaace holder
res@gsnCenterString="Surf"
plot(4)  = gsn_csm_contour_map(wks, Middle_First(4,:,:), res )   ; plaace holder
res@gsnCenterString="Change"
plot2(0)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:), res )   ; plaace holder
res@gsnCenterString="Advection+GM"
plot2(1)  = gsn_csm_contour_map(wks, Last_Middle(1,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot2(2)  = gsn_csm_contour_map(wks, Last_Middle(2,:,:), res )   ; plaace holder
res@gsnCenterString="Source&sink"
plot2(3)  = gsn_csm_contour_map(wks, Last_Middle(3,:,:), res )   ; plaace holder
res@gsnCenterString="Surf"
plot2(4)  = gsn_csm_contour_map(wks, Last_Middle(4,:,:), res )   ; plaace holder
res@gsnCenterString="Change"
plot3(0)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:), res )   ; plaace holder
res@gsnCenterString="Advection+GM"
plot3(1)  = gsn_csm_contour_map(wks, Last2_Last1(1,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot3(2)  = gsn_csm_contour_map(wks, Last2_Last1(2,:,:), res )   ; plaace holder
res@gsnCenterString="Source&sink"
plot3(3)  = gsn_csm_contour_map(wks, Last2_Last1(3,:,:), res )   ; plaace holder
res@gsnCenterString="Surf"
plot3(4)  = gsn_csm_contour_map(wks, Last2_Last1(4,:,:), res )   ; plaace holder

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
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.84,0.035,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)

end
