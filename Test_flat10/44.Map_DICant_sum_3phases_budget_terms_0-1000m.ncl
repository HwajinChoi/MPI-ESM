begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

g=addfile(dir0+"flat10_cdr_budget_terms_tsco212_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
tot1=g->tsco212_tot ; time 450 lat 96 lon 192
adv1=g->tsco212_adv
dif1=g->tsco212_dif
gm1=g->tsco212_gm
sosi1=g->tsco212_sosi
surf1=g->tsco212_surf

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
tot2=f->tsco212nat_tot ; time 450 lat 96 lon 192
adv2=f->tsco212nat_adv
dif2=f->tsco212nat_dif
gm2=f->tsco212nat_gm
sosi2=f->tsco212nat_sosi
surf2=f->tsco212nat_surf
dim=dimsizes(tot1)

tot=tot1-tot2
adv=adv1-adv2
dif=dif1-dif2
gm=gm1-gm2
sosi=sosi1-sosi2
surf=surf1-surf2
copy_VarCoords(tot1,tot)
copy_VarCoords(adv1,adv)
copy_VarCoords(sosi1,sosi)
copy_VarCoords(dif1,dif)
copy_VarCoords(gm1,gm)
copy_VarCoords(surf1,surf)

Inc=new((/6,150,dim(1),dim(2)/),typeof(tot))
Dec=new((/6,150,dim(1),dim(2)/),typeof(tot))
Zec=new((/6,150,dim(1),dim(2)/),typeof(tot))

Inc(0,:,:,:)=tot(0:149,:,:)
Dec(0,:,:,:)=tot(150:299,:,:)
Zec(0,:,:,:)=tot(300:449,:,:)

Inc(1,:,:,:)=adv(0:149,:,:)
Dec(1,:,:,:)=adv(150:299,:,:)
Zec(1,:,:,:)=adv(300:449,:,:)

Inc(2,:,:,:)=dif(0:149,:,:)
Dec(2,:,:,:)=dif(150:299,:,:)
Zec(2,:,:,:)=dif(300:449,:,:)

Inc(3,:,:,:)=gm(0:149,:,:)
Dec(3,:,:,:)=gm(150:299,:,:)
Zec(3,:,:,:)=gm(300:449,:,:)

Inc(4,:,:,:)=sosi(0:149,:,:)
Dec(4,:,:,:)=sosi(150:299,:,:)
Zec(4,:,:,:)=sosi(300:449,:,:)

Inc(5,:,:,:)=surf(0:149,:,:)
Dec(5,:,:,:)=surf(150:299,:,:)
Zec(5,:,:,:)=surf(300:449,:,:)


Inc_avg=dim_sum_n_Wrap(Inc,1)
Dec_avg=dim_sum_n_Wrap(Dec,1)
Zec_avg=dim_sum_n_Wrap(Zec,1)

Inc_avg=Inc_avg*1000
Dec_avg=Dec_avg*1000
Zec_avg=Zec_avg*1000

plot=new(6,graphic)
plot3=new(6,graphic)
plot2=new(6,graphic)

wks   = gsn_open_wks ("png", dir1+"Map_CDR_DICant_sum_3phases_Budget_terms_0-1000m" )          ; send graphics to PNG file
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
res@cnMaxLevelValF         =     0.005
res@cnMinLevelValF         =     -0.005
res@cnLevelSpacingF        =      0.001
;printMinMax(Inc_avg(0,:,:),0)
;exit
plot(0)  = gsn_csm_contour_map(wks, Inc_avg(0,:,:), res )   ; plaace holder
res@gsnCenterString="Advection"
plot(1)  = gsn_csm_contour_map(wks, Inc_avg(1,:,:),res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Diffusion"
plot(2)  = gsn_csm_contour_map(wks,Inc_avg(2,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="GM"
plot(3)  = gsn_csm_contour_map(wks, Inc_avg(3,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source&sink"
plot(4)  = gsn_csm_contour_map(wks, Inc_avg(4,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Surf"
plot(5)  = gsn_csm_contour_map(wks, Inc_avg(5,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.00005
;res@cnMinLevelValF         =     -0.00005
;res@cnLevelSpacingF        =      0.00001
res@gsnCenterString="Change"
res@cnMaxLevelValF         =     0.005
res@cnMinLevelValF         =     -0.005
res@cnLevelSpacingF        =      0.001
plot2(0)  = gsn_csm_contour_map(wks, Dec_avg(0,:,:), res )   ; plaace holder
res@gsnCenterString="Advection"
plot2(1)  = gsn_csm_contour_map(wks, Dec_avg(1,:,:),res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Diffusion"
plot2(2)  = gsn_csm_contour_map(wks, Dec_avg(2,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="GM"
plot2(3)  = gsn_csm_contour_map(wks, Dec_avg(3,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source&sink"
plot2(4)  = gsn_csm_contour_map(wks, Dec_avg(4,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Surf"
plot2(5)  = gsn_csm_contour_map(wks, Dec_avg(5,:,:), res )   ; plaace holder
res@gsnCenterString="Change"
res@cnMaxLevelValF         =     0.005
res@cnMinLevelValF         =     -0.005
res@cnLevelSpacingF        =      0.001
plot3(0)  = gsn_csm_contour_map(wks, Zec_avg(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Advection"
plot3(1)  = gsn_csm_contour_map(wks, Zec_avg(1,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot3(2)  = gsn_csm_contour_map(wks, Zec_avg(2,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="GM"
plot3(3)  = gsn_csm_contour_map(wks, Zec_avg(3,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source&sink"
plot3(4)  = gsn_csm_contour_map(wks, Zec_avg(4,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Surf"
plot3(5)  = gsn_csm_contour_map(wks, Zec_avg(5,:,:), res )   ; plaace holder
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
gsn_text_ndc(wks,"[m mol/m~S~2~N~]",0.84,0.035,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)

end
