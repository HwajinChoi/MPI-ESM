begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/agessc/"
f=addfile(dir1+"agessc_r192x96_18500101-22991231.nc","r")

do i=0,449
j=i+1
age=f->agessc(12*i+11,:,:,:)
age1=dim_max_n_Wrap(age,0)

wks   = gsn_open_wks ("png", dir2+"agessc_check_year_"+j )          ; send graphics to PNG file
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
res@gsnCenterString="(a) agessc, year "+j
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterStringOrthogonalPosF=0.05
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"
res@cnMaxLevelValF         =     450
res@cnMinLevelValF         =     0
res@cnLevelSpacingF        =      30
plot=gsn_csm_contour_map(wks,age1,res)

draw(plot)
frame(wks)
print("year "+j)

end do

end
