begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_r192x96_intpp_185001_229912.nc","r")
intpp=f->intpp(:,0,:,:)
intpp_an=month_to_annual(intpp,1)

first=intpp_an(0:29,:,:)
middle=intpp_an(135:164,:,:)
last=intpp_an(270:299,:,:)
last1=intpp_an(285:314,:,:)
last2=intpp_an(420:449,:,:)

first_clim=dim_avg_n_Wrap(first,0)
middle_clim=dim_avg_n_Wrap(middle,0)
last_clim=dim_avg_n_Wrap(last,0)
last2_clim=dim_avg_n_Wrap(last2,0)
last1_clim=dim_avg_n_Wrap(last1,0)

last_middle=last_clim-middle_clim
middle_first=middle_clim-first_clim
last2_last1=last2_clim-last1_clim
copy_VarCoords(last_clim,last_middle)
copy_VarCoords(last_clim,middle_first)
copy_VarCoords(last_clim,last2_last1)

;--- Unit convertion---
last_middle=last_middle*1000*1000
middle_first=middle_first*1000*1000
last2_last1=last2_last1*1000*1000

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"NPP_map_3phases_anomaly" )          ; send graphics to PNG file
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
res@cnMaxLevelValF         =     0.2
res@cnMinLevelValF         =     -0.2
res@cnLevelSpacingF        =      0.04
res@gsnCenterString="Positive emissions"
plot(0)=gsn_csm_contour_map(wks,middle_first,res)
res@gsnCenterString="Negative emissions"
plot(1)=gsn_csm_contour_map(wks,last_middle,res)
res@gsnCenterString="Zero emissions"
plot(2)=gsn_csm_contour_map(wks,last2_last1,res)

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

gsn_text_ndc(wks,"[micro mol m-2 s-1]",0.88,0.13,txres1)
gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
