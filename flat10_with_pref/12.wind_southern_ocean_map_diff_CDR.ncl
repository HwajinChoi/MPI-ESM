begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"


f=addfile(dir1+"flat10_cdr_001_echam6_u10_1850-2299.nc","r")
u10=f->u10

First=u10(:29,:,:)
First_an=dim_avg_n_Wrap(First,0)
Middle=u10(135:164,:,:)
Middle_an=dim_avg_n_Wrap(Middle,0)
diff1=Middle_an-First_an
Last=u10(285:314,:,:)
Last_an=dim_avg_n_Wrap(Last,0)
diff2=Last_an-Middle_an
copy_VarCoords(First_an,diff1)
copy_VarCoords(First_an,diff2)

plot=new(6,graphic)

 wks=gsn_open_wks("png",dir2+"Southern_U10_map_First_Middle_30yrs_diff")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@gsnMaximize           = False
 res@gsnPaperOrientation   = "portrait"
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@gsnCenterStringFontHeightF= 0.040
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.15
 res@cnLineLabelsOn         =       False
 res@gsnCenterString=""
 res@vpWidthF = 0.8
 res@vpHeightF = 0.8
 res@mpGridLonSpacingF=60
 resw=res
 res@mpMinLatF=-90
 res@mpMaxLatF=-30
; res@mpMinLonF=-90
; res@mpMaxLonF=60
 res@mpLabelFontHeightF =0.03
 res@tmXBLabelFontHeightF=0.025
 res@tmYLLabelFontHeightF=0.025
 res@mpLandFillColor    =   "black"
 ;res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@lbLabelFontHeightF  = 0.026
 res@gsnCenterString="First 30 years"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res2=res
 res@cnMaxLevelValF         =     10.
 res@cnMinLevelValF         =     -10.
 res@cnLevelSpacingF        =      1.
 res@cnFillPalette          =       "BlueDarkOrange18"
 res@lbLabelBarOn           =      True
 res@gsnMajorLonSpacing   =  60             ;-- change major lon tickmark spacing
 res@pmLabelBarOrthogonalPosF=0.7
 plot(0)=gsn_csm_contour_map(wks,First_an,res)
 res@gsnCenterString="Middle 30 years"
 plot(1)=gsn_csm_contour_map(wks,Middle_an,res)
 plot(4)=gsn_csm_contour_map(wks,Middle_an,res)
 res@gsnCenterString="Last 30 years"
 plot(3)=gsn_csm_contour_map(wks,Last_an,res)
 res@cnMaxLevelValF         =     2.
 res@cnMinLevelValF         =     -2.
 res@cnLevelSpacingF        =      0.2
 res@cnFillPalette          =       "BlueDarkRed18"
 res@gsnCenterString="Diff (Mid - Fir)"
 plot(2)=gsn_csm_contour_map(wks,diff1,res)
 res@gsnCenterString="Diff (Last - Mid)"
 plot(5)=gsn_csm_contour_map(wks,diff2,res)
 
 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 6
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString=""
 gsn_panel(wks,plot,(/2,3/),pres)
 frame(wks)

end
