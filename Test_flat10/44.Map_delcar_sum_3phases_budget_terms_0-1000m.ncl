begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_delcar_mul_dz_0-1000m_r192x96_1850_2299.nc","r")
delcar=f->delcar

Inc=delcar(0:149,:,:)
Dec=delcar(150:299,:,:)
Zec=delcar(300:449,:,:)

Inc_sum=dim_sum_n_Wrap(Inc,0)
Dec_sum=dim_sum_n_Wrap(Dec,0)
Zec_sum=dim_sum_n_Wrap(Zec,0)

;--- Unit convertion---
Inc_sum=Inc_sum*1000*1000
Dec_sum=Dec_sum*1000*1000
Zec_sum=Zec_sum*1000*1000


plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_delcar_sum_3phases" )          ; send graphics to PNG file
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
res@cnFillPalette        = "cmocean_haline"
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
res@cnMaxLevelValF         =     0.005
res@cnMinLevelValF         =     0.
res@cnLevelSpacingF        =      0.0005
res@gsnCenterString="Positive emissions"
plot(0)=gsn_csm_contour_map(wks,Inc_sum,res)
res@gsnCenterString="Negative emissions"
plot(1)=gsn_csm_contour_map(wks,Dec_sum,res)
res@gsnCenterString="Zero emissions"
plot(2)=gsn_csm_contour_map(wks,Zec_sum,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@gsnMaximize        =       False
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@lbLabelFontHeightF  = 0.023
pres@pmLabelBarHeightF=0.7
pres@gsnPanelLeft=0.1
pres@lbLabelStride     =   2
pres@lbOrientation        = "vertical"

txres1               = True
txres1@txFontHeightF = 0.018

gsn_text_ndc(wks,"[m mol m-2]",0.88,0.13,txres1)
gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
