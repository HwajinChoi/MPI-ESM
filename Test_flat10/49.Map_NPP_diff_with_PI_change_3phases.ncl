begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_r192x96_intpp_1850_2299.nc","r")
intpp=f->intpp(:,0,:,:)

Inc=intpp(0:149,:,:)
Dec=intpp(150:299,:,:)
Zec=intpp(300:449,:,:)

Inc_sum=dim_sum_n_Wrap(Inc,0)
Dec_sum=dim_sum_n_Wrap(Dec,0)
Zec_sum=dim_sum_n_Wrap(Zec,0)

g=addfile(dir0+"test_pictrl_preform_001_spinup_r192x96_intpp_8800_8949.nc","r")
intpp_PI=g->intpp(:,0,:,:)

PI=dim_sum_n_Wrap(intpp_PI,0)

;--- Unit convertion---
Inc_sum=Inc_sum*1000
Dec_sum=Dec_sum*1000
Zec_sum=Zec_sum*1000
PI=PI*1000
printMinMax(PI,0)
printMinMax(Inc_sum,0)

Inc_diff=Inc_sum-PI
Dec_diff=Dec_sum-PI
Zec_diff=Zec_sum-PI
copy_VarCoords(Inc_sum,Inc_diff)
copy_VarCoords(Inc_sum,Dec_diff)
copy_VarCoords(Inc_sum,Zec_diff)

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_NPP_change_diff_with_PI_3phases" )          ; send graphics to PNG file
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
res@cnFillPalette        = "GMT_polar"
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
res@cnMaxLevelValF         =     0.03
res@cnMinLevelValF         =     -0.03
res@cnLevelSpacingF        =      0.005
res@gsnCenterString="Positive phase"
plot(0)=gsn_csm_contour_map(wks,Inc_diff,res)
res@gsnCenterString="Negative phase"
plot(1)=gsn_csm_contour_map(wks,Dec_diff,res)
res@gsnCenterString="Zero phase"
plot(2)=gsn_csm_contour_map(wks,Zec_diff,res)

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

gsn_text_ndc(wks,"[m mol m-2 ]",0.88,0.13,txres1)
gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
