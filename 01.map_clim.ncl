begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"

dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

 plot=new(9,graphic)
 wks=gsn_open_wks("x11",dir1+"DIFF_corr_COBALT_Temp_1991-2017_leadtime_"+l(i))
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 ;res@cnFillMode                =   "AreaFill"
 res@lbLabelBarOn           =      False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
; res@gsnLeftStringFontHeightF= 0.035
; res@gsnLeftString
; res@gsnLeftStringOrthogonalPosF=0.1
 res@lbLabelBarOn           = False
; res@tmXBLabelFontHeightF  =       0.025
; res@tmYLLabelFontHeightF  =       0.025
; res@tmXBLabelStride     =       2
; res@tmYLLabelStride     =       2
 sres                   =   res
 res@mpCenterLonF       =       180
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.4
 res@cnMinLevelValF         =      -0.4
 res@cnLevelSpacingF        =       0.05
 res@cnFillPalette          =       "temp_19lev"

 j=0
 plot(3*j)=gsn_csm_contour_map(wks,diff0(j,:,:),res)
 plot(3*j+1)=gsn_csm_contour_map(wks,diff1(j,:,:),res)
 plot(3*j+2)=gsn_csm_contour_map(wks,diff2(j,:,:),res)

 do j=1,2

 plot(3*j)=gsn_csm_contour_map(wks,diff0(j,:,:),res)
 plot(3*j+1)=gsn_csm_contour_map(wks,diff1(j,:,:),res)
 plot(3*j+2)=gsn_csm_contour_map(wks,diff2(j,:,:),res)

 end do

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.015
 pres@lbLabelStride     =   2
 txres1               = True
 txres1@txFontHeightF = 0.016
 txres1@txAngleF=90
 gsn_text_ndc(wks,"0 - 100m",0.05,0.69,txres1)
 gsn_text_ndc(wks,"100 - 300m",0.05,0.52,txres1)
 gsn_text_ndc(wks,"300 - 800m",0.05,0.34,txres1)

 txres2               = True
 txres2@txFontHeightF = 0.018
 gsn_text_ndc(wks,"Meta|0.2|",0.24,0.8,txres2)
 gsn_text_ndc(wks,"Meta|0.7|",0.55,0.8,txres2)
 gsn_text_ndc(wks,"Meta|1.2|",0.85,0.8,txres2)

 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
 gsn_panel(wks,plot,(/3,3/),pres)
 frame(wks)

end
