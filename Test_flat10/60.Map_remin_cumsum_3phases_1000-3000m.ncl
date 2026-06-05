begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_remin_of_det_by_O2_mul_dz_1000-3000m_r192x96_1850_2299.nc","r")
remin=f->remin_of_det_by_O2_
remin=remin*122*365.25*86400

remin_cumsum=dim_cumsum_n_Wrap(remin,1,0)
remin_0_150=remin_cumsum(149,:,:)
remin_150_300=remin_cumsum(299,:,:)-remin_cumsum(149,:,:)
remin_300_450=remin_cumsum(449,:,:)-remin_cumsum(299,:,:)

;remin_0_150 := remin_0_150/1000
;remin_150_300 := remin_150_300/1000
;remin_300_450 := remin_300_450/1000

copy_VarCoords(remin(0,:,:),remin_0_150)
copy_VarCoords(remin(0,:,:),remin_150_300)
copy_VarCoords(remin(0,:,:),remin_300_450)

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_remin_cumsum_3phases_1000-3000m" )          ; send graphics to PNG file
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
res@cnMaxLevelValF         =    0.1 
res@cnMinLevelValF         =     0
res@cnLevelSpacingF        =     0.01
res@gsnCenterString="Positive phase"
plot(0)=gsn_csm_contour_map(wks,remin_0_150,res)
res@gsnCenterString="Negative phase"
plot(1)=gsn_csm_contour_map(wks,remin_150_300,res)
res@gsnCenterString="Zero phase"
plot(2)=gsn_csm_contour_map(wks,remin_300_450,res)

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
