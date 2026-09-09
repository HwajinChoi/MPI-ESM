begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"agessc_r192x96_185012-229912_lon190.nc","r")
agessc=f->agessc(:,:,:,0) ; time * depth * lat

First=dim_avg_n_Wrap(agessc(0:29,:,:),0)
Middle=dim_avg_n_Wrap(agessc(135:164,:,:),0)
Last=dim_avg_n_Wrap(agessc(270:299,:,:),0)
Last1=dim_avg_n_Wrap(agessc(285:314,:,:),0)
Last2=dim_avg_n_Wrap(agessc(420:449,:,:),0)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_vertical_CDR_agessc_Pacific" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLevelSelectionMode   =       "ManualLevels"
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@gsnDraw                =       False
res@gsnFrame               =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@gsnCenterStringFontHeightF= 0.035
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.03
res@tmYLLabelFontHeightF=0.03
res@tiYAxisFontHeightF=0.04

res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =      True
res@gsnContourZeroLineThicknessF = 2.          ; doubles thickness of zero contour
res@gsnContourNegLineDashPattern=2
res@cnLinesOn=True
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@cnMaxLevelValF         =     100
res@cnMinLevelValF         =     -100
res@cnLevelSpacingF        =      10
res@gsnCenterString="(a) Positive emissions"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
res@tmXBLabelsOn        = False
res@tmYLLabelsOn        = True
plot(0)  = gsn_csm_contour(wks, Middle_First, res )   ; plaace holder
res@gsnCenterString="(b) Negative emissions"
plot(1)  = gsn_csm_contour(wks, Last_Middle, res )   ; plaace holder
res@gsnCenterString="(c) Zero emissions"
res@tmXBLabelsOn        = True
plot(2)  = gsn_csm_contour(wks, Last2_Last1, res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 4
pres@gsnPanelLabelBar      = True
pres@gsnPanelTop=1.
pres@gsnPanelBottom=0.04


txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[ yr ]",0.8,0.04,txres2)
gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
