begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"
dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

 plot=new(3,graphic)
 wks=gsn_open_wks("png",dir2+"Lines_global_map")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 ;res@cnFillMode                =   "AreaFill"
 ;res@mpProjection ="Robinson"
 res@mpPerimOn = False
 ;res@mpCenterLonF =0
 res@vpWidthF       = 0.3            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.8  
 res@gsnLeftString=""
 res@gsnRightString=""
 res@tmXBLabelFontHeightF  =       0.022
 res@tmYLLabelFontHeightF  =       0.022
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpGreatCircleLinesOn = True
 res@mpLandFillColor    =   "grey"
 res@mpFillDrawOrder="PostDraw"
 res@mpMinLatF= -90
 res@mpMaxLatF=90

 res@mpMinLonF=-70
 res@mpMaxLonF=30
 res@mpCenterLonF=0
 plot(0)=gsn_csm_map_ce(wks,res)
 res@mpCenterLonF=180
 res@mpMinLonF=140
 res@mpMaxLonF=220
 plot(1)=gsn_csm_map_ce(wks,res)
 res@mpMinLonF=30
 res@mpMaxLonF=110
 plot(2)=gsn_csm_map_ce(wks,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       False
 pres@gsnPanelXWhiteSpacePercent = 5

 pres1                  = True           ; polyline mods desired
 pres1@gsLineThicknessF = 3.0            ; line thickness   
 pres1@gsLineColor      = "black"         ; color of lines

;---Attach the polyline
 dum1 = gsn_add_polyline(wks,plot(0), (/-20, -20/) , (/-89, 89/) ,pres1)
 dum2 = gsn_add_polyline(wks,plot(1), (/190, 190/) , (/-89, 89/) ,pres1)
 dum3 = gsn_add_polyline(wks,plot(2), (/70, 70/) , (/-89, 89/) ,pres1)

 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
 gsn_panel(wks,plot,(/1,3/),pres)
 frame(wks)

end
