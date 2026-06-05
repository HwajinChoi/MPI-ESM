begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_bacterial_activity_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
bacfrac=f->bacterial_activity
bacfrac=bacfrac*122

bacfrac_cumsum=dim_cumsum_n_Wrap(bacfrac,1,0)
bacfrac_0_150=bacfrac_cumsum(149,:,:)
bacfrac_150_300=bacfrac_cumsum(299,:,:)-bacfrac_cumsum(149,:,:)
bacfrac_300_450=bacfrac_cumsum(449,:,:)-bacfrac_cumsum(299,:,:)

;bacfrac_0_150 := bacfrac_0_150/1000
;bacfrac_150_300 := bacfrac_150_300/1000
;bacfrac_300_450 := bacfrac_300_450/1000

copy_VarCoords(bacfrac(0,:,:),bacfrac_0_150)
copy_VarCoords(bacfrac(0,:,:),bacfrac_150_300)
copy_VarCoords(bacfrac(0,:,:),bacfrac_300_450)
printMinMax(bacfrac_300_450,1)
exit

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_bacfrac_cumsum_3phases_0-1000m" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnLineLabelsOn       = False                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@lbLabelBarOn           = False
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnFillPalette        = "MPL_Oranges"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@gsnCenterStringFontHeightF= 0.028
res@gsnCenterString="First"
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterStringOrthogonalPosF=0.05
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"
res@lbLabelBarOn           =      False
res@cnMaxLevelValF         =     1.5
res@cnMinLevelValF         =     0
res@cnLevelSpacingF        =     0.1
res@gsnCenterString="Positive phase"
plot(0)=gsn_csm_contour_map(wks,bacfrac_0_150,res)
res@gsnCenterString="Negative phase"
plot(1)=gsn_csm_contour_map(wks,bacfrac_150_300,res)
res@gsnCenterString="Zero phase"
plot(2)=gsn_csm_contour_map(wks,bacfrac_300_450,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@lbLabelFontHeightF  = 0.023
pres@pmLabelBarHeightF=0.7
pres@gsnPanelLeft=0.1
pres@lbLabelStride     =   2
pres@lbOrientation        = "vertical"

txres1               = True
txres1@txFontHeightF = 0.018

gsn_text_ndc(wks,"[kmol m-2 ]",0.88,0.13,txres1)
gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
