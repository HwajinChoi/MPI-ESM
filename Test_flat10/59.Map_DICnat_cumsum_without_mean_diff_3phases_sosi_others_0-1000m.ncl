begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
tot=f->tsco212nat_tot ; time 450 lat 96 lon 192
adv=f->tsco212nat_adv
dif=f->tsco212nat_dif
gm=f->tsco212nat_gm
sosi=f->tsco212nat_sosi
surf=f->tsco212nat_surf
dim=dimsizes(tot)

adv := adv+gm
copy_VarCoords(tot,adv)

Bud=new((/5,dim(0),dim(1),dim(2)/),typeof(tot))
Bud_ano=new((/5,dim(0),dim(1),dim(2)/),typeof(tot))
Bud(0,:,:,:)=tot
Bud(1,:,:,:)=adv
Bud(2,:,:,:)=dif
Bud(4,:,:,:)=sosi
Bud(3,:,:,:)=surf

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

dim0=dimsizes(Last)
Inc_sub=new((/3,dim0(1),dim0(2)/),typeof(Last))
Inc_sub(:,:,:)=Middle_First(1:3,:,:)
Inc_sum=dim_sum_n_Wrap(Inc_sub,0)

Dec_sub=new((/3,dim0(1),dim0(2)/),typeof(Last))
Dec_sub(:,:,:)=Last_Middle(1:3,:,:)
Dec_sum=dim_sum_n_Wrap(Dec_sub,0)

Zec_sub=new((/3,dim0(1),dim0(2)/),typeof(Last))
Zec_sub(:,:,:)=Last2_Last1(1:3,:,:)
Zec_sum=dim_sum_n_Wrap(Zec_sub,0)

plot=new(3,graphic)
plot3=new(3,graphic)
plot2=new(3,graphic)

wks   = gsn_open_wks ("png", dir1+"Map_CDR_DICnat_cumsum_without_mean_3phases_sosi_others_0-1000m" )
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
res@cnMaxLevelValF         =    120 
res@cnMinLevelValF         =     -120
res@cnLevelSpacingF        =      20
;printMinMax(Inc_avg(0,:,:),0)
;exit
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString="Adv+dif+GM+surf"
plot(1)  = gsn_csm_contour_map(wks, Inc_sum,res )   ; plaace holder
res@gsnCenterString="Source & Sink"
plot(2)  = gsn_csm_contour_map(wks, Middle_First(4,:,:), res )   ; plaace holder
res@gsnCenterString="Change"
plot2(0)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:), res )   ; plaace holder
res@gsnCenterString="Adv+dif+GM+surf"
plot2(1)  = gsn_csm_contour_map(wks, Dec_sum,res ) 
res@gsnCenterString="Source & Sink"
plot2(2)  = gsn_csm_contour_map(wks, Last_Middle(4,:,:), res )   ; plaace holder
res@gsnCenterString="Change"
plot3(0)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:), res )   ; plaace holder
res@gsnCenterString="Adv+dif+GM+surf"
plot3(1)  = gsn_csm_contour_map(wks, Zec_sum,res )   ; plaace holder
res@gsnCenterString="Source & Sink"
plot3(2)  = gsn_csm_contour_map(wks, Last2_Last1(4,:,:), res ) 

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
gsn_panel(wks,plot,(/1,3/),pres)
gsn_panel(wks,plot2,(/1,3/),pres2)
gsn_panel(wks,plot3,(/1,3/),pres3)
frame(wks)

end
