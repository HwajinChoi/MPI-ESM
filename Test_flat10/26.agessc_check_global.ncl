begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"agessc_r192x96_86070101_86071231.nc","r")
age=f->agessc(11,:,:,:) ; last month -> Dec

age1=dim_max_n_Wrap(age,0)

wks   = gsn_open_wks ("png", dir2+"agessc_check_year_8607" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnLineLabelsOn       = False                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@lbLabelBarOn           = True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnFillPalette        = "BlAqGrYeOrReVi200"
res@lbLabelFontHeightF  = 0.012
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@gsnCenterStringFontHeightF= 0.025
res@gsnCenterString="(a) agessc"
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterStringOrthogonalPosF=0.05
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"
res@cnMaxLevelValF         =     4000
res@cnMinLevelValF         =     0
res@cnLevelSpacingF        =      200
plot=gsn_csm_contour_map(wks,age1,res)

draw(plot)
frame(wks)

end
