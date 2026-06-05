begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_r192x96_toxygen_1850_2299_lon_190.nc","r")
tot=f->toxygen_tot(:,:,:,0)
adv=f->toxygen_adv(:,:,:,0)
dif=f->toxygen_dif(:,:,:,0)
gm=f->toxygen_gm(:,:,:,0)
sosi=f->toxygen_sosi(:,:,:,0)
surf=f->toxygen_surf(:,:,:,0)
dim=dimsizes(tot)

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

Inc(4,:,:,:)=surf(0:149,:,:)
Dec(4,:,:,:)=surf(150:299,:,:)
Zec(4,:,:,:)=surf(300:449,:,:)

Inc(5,:,:,:)=sosi(0:149,:,:)
Dec(5,:,:,:)=sosi(150:299,:,:)
Zec(5,:,:,:)=sosi(300:449,:,:)

Inc_avg=dim_avg_n_Wrap(Inc,1)
Dec_avg=dim_avg_n_Wrap(Dec,1)
Zec_avg=dim_avg_n_Wrap(Zec,1)

Inc_avg=Inc_avg*1000*1000
Dec_avg=Dec_avg*1000*1000
Zec_avg=Zec_avg*1000*1000

dim0=dimsizes(Inc_avg)
Inc_sub=new((/4,dim0(1),dim0(2)/),typeof(Inc_avg))
Inc_sub(:,:,:)=Inc_avg(1:4,:,:)
Inc_sum=dim_sum_n_Wrap(Inc_sub,0)

Dec_sub=new((/4,dim0(1),dim0(2)/),typeof(Dec_avg))
Dec_sub(:,:,:)=Dec_avg(1:4,:,:)
Dec_sum=dim_sum_n_Wrap(Dec_sub,0)

Zec_sub=new((/4,dim0(1),dim0(2)/),typeof(Zec_avg))
Zec_sub(:,:,:)=Zec_avg(1:4,:,:)
Zec_sum=dim_sum_n_Wrap(Zec_sub,0)

plot=new(3,graphic)
plot3=new(3,graphic)
plot2=new(3,graphic)

wks   = gsn_open_wks ("png", dir1+"2D_vertical_CDR_oxygen_tend_sosi_others_terms_Pacific" )          ; send graphics to PNG file
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
res@lbOrientation="vertical"

res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = True
res@gsnCenterString="Tendency"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
res@tmXBLabelsOn        = False
res@tmYLLabelsOn        = True
res@cnMaxLevelValF         =     0.00005
res@cnMinLevelValF         =     -0.00005
res@cnLevelSpacingF        =      0.00001
plot(0)  = gsn_csm_contour(wks, Inc_avg(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnCenterString="Adv+dif+GM+surf"
plot(1)  = gsn_csm_contour(wks, Inc_sum,res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source & Sink"
plot(2)  = gsn_csm_contour(wks,Inc_avg(5,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@tmYLLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnCenterString="Tendency"
plot2(0)  = gsn_csm_contour(wks, Dec_avg(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnCenterString="Adv+dif+GM+surf"
plot2(1)  = gsn_csm_contour(wks, Dec_sum,res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source & Sink"
plot2(2)  = gsn_csm_contour(wks, Dec_avg(5,:,:), res )   ; plaace holder
;res@cnMinLevelValF         =     -0.00005
;res@cnLevelSpacingF        =      0.00001
res@tmYLLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnCenterString="Tendency"
plot3(0)  = gsn_csm_contour(wks, Zec_avg(0,:,:), res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnCenterString="Adv+dif+GM+surf"
plot3(1)  = gsn_csm_contour(wks, Zec_sum,res )   ; plaace holder
;res@cnMaxLevelValF         =     0.005
;res@cnMinLevelValF         =     -0.005
;res@cnLevelSpacingF        =      0.001
res@gsnCenterString="Source & Sink"
plot3(2)  = gsn_csm_contour(wks, Zec_avg(5,:,:), res )   ; plaace holder

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
gsn_text_ndc(wks,"Positive emissions",0.08,0.84,txres1)
gsn_text_ndc(wks,"Negative emissions",0.08,0.53,txres1)
gsn_text_ndc(wks,"Zero emissions",0.08,0.22,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[micro mol/m~S~3~N~ s~S~1~N~]",0.84,0.035,txres2)
gsn_panel(wks,plot,(/1,3/),pres)
gsn_panel(wks,plot2,(/1,3/),pres2)
gsn_panel(wks,plot3,(/1,3/),pres3)
frame(wks)

end
