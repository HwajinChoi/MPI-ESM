begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"agessc_pictrl_r192x96_880012-894912_lon190.nc","r")
agessc=f->agessc(:,:,:,0) ; time * depth * lat

First=dim_avg_n_Wrap(agessc(0:29,:,:),0)
Last=dim_avg_n_Wrap(agessc(120:149,:,:),0)

Last_First=Last-First
copy_VarCoords(Last,Last_First)

plot=new(1,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_vertical_piControl_agessc_Pacific" )          ; send graphics to PNG file
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
res@tmXBLabelFontHeightF=0.025
res@tmYLLabelFontHeightF=0.025
res@tiYAxisFontHeightF=0.03

res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =      True
res@gsnContourZeroLineThicknessF = 2.          ; doubles thickness of zero contour
res@gsnContourNegLineDashPattern=2
res@cnLinesOn=True
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = True
res@cnMaxLevelValF         =     100
res@cnMinLevelValF         =     -100
res@cnLevelSpacingF        =      10
res@gsnCenterString="piControl"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
res@tmXBLabelsOn        = True
res@tmYLLabelsOn        = True
plot(0)  = gsn_csm_contour(wks, Last_First, res )   ; plaace holder
txres2=True
txres2@txFontHeightF = 0.02
gsn_text_ndc(wks,"[ yr ]",0.9,0.18,txres2)

draw(plot)
frame(wks)

end
