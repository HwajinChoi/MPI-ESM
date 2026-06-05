begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

;f=addfile(dir1+"flat10_cdr_001_mpiom_map_r192x96_18500101_18501231.nc","r")
f=addfile(dir1+"flat10_cdr_001_mpiom_map_18500101_18501231.nc","r")
rbek=f->rbek(0,0,:,:)
lon=f->lon
lat=f->lat
rbek@lon2d=lon
rbek@lat2d=lat

;printVarSummary(rbek)
;exit

levels=ispan(1,8,1)
colors=(/"chartreuse","gray50","lightblue","gold","pink","orange","darkviolet","green","yellow","violet","lightblue"/)

wks = gsn_open_wks("png",dir2+"map_mask")
res                       = True
res@gsnMaximize           = True                ; blow up plot
res@mpCenterLonF=180
res@cnConstFEnableFill=True
res@mpFillOn              = True                ; turn on map fill
res@mpPerimOn             = False               ; don't draw box around map
res@cnLinesOn            = False          ; turn off contour lines
;res@cnFillMode             =   "RasterFill"
res@cnFillMode             =   "CellFill"
res@mpLandFillColor    =   "black"
res@cnFillOn          = True              ; color plot desired
res@cnFillPalette= "Cat12"
res@cnLineLabelsOn       = False          ; turn off contour labels
res@lbLabelBarOn         = True          ; turn off labelbar
res@gsnRightString       = ""             ; turn off special titles
res@gsnLeftString        = ""
res@cnRasterSmoothingOn = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF  = 1			; set the minimum contour level
res@cnMaxLevelValF  = 9			; set the maximum contour level
res@cnLevelSpacingF = 1			; set the interval between contours

plot=gsn_csm_contour_map(wks,rbek,res)

end
