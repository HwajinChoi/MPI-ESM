begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"


f=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissic_dep6_18500101_21491231.nc","r")
flt_tot=f->dissic(0,0,:,:)
flt_tot(0,:)=0.1
flt_tot(1:95,:)=0
tot=lonFlip(flt_tot)

 plot=new(1,graphic)
 wks=gsn_open_wks("png",dir2+"POLAR_Beaufort_map")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@mpPerimOn = False
 res@gsnPolar   = "NH"
 ;res@mpCenterLonF =0
 res@vpWidthF       = 0.3            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.8  
res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =     0.1
 res@cnMinLevelValF         =     -0.1
 res@cnLevelSpacingF        =      0.005
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "temp_diff_18lev"
 res@cnLineLabelsOn         =       False
 res@lbLabelBarOn           =      False
 res@gsnLeftString=""
 res@gsnRightString=""
 res@tmXBLabelFontHeightF  =       0.022
 res@tmYLLabelFontHeightF  =       0.022
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpGreatCircleLinesOn = True
 res@mpLandFillColor    =   "grey"
 res@mpFillDrawOrder="PostDraw"
 res@mpMinLatF= 60
 res@mpCenterLonF=0
 plot(0)=gsn_csm_contour_map_polar(wks,tot,res)

 pres1                  = True           ; polyline mods desired
 pres1@gsLineThicknessF = 3.0            ; line thickness   
 pres1@gsLineColor      = "black"         ; color of lines

;---Attach the polyline
 dum1 = gsn_add_polyline(wks,plot(0), (/-180, -180/) , (/70, 90/) ,pres1)
 dum2 = gsn_add_polyline(wks,plot(0), (/-90, -90/) , (/70, 90/) ,pres1)
 ;dum3 = gsn_add_polyline(wks,plot(0), (/-180, -90/) , (/70, 70/) ,pres1)
 ;dum1 = gsn_add_polygon(wks,plot(0), (/-180, -90,-90,-180,-180/) , (/60,60, 90,90,60/) ,pres1)
 ;dum2 = gsn_add_polyline(wks,plot(0), (/-180, -90/) , (/60, 90/) ,pres1)

 draw(plot)
 frame(wks)

end
