begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f_sur=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_dep6_18500101_20001231.nc","r")
dis_sur=f_sur->dissicnat(:,0,:,:)

f_200m=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_dep182.5_18500101_20001231.nc","r")
dis_200m=f_200m->dissicnat(:,0,:,:)

dis_sur_an=month_to_annual(dis_sur,1)
dis_200m_an=month_to_annual(dis_200m,1)
year=ispan(1850,2000,1)
year!0="year"

rc_sur = regCoef(year,dis_sur_an(lat|:,lon|:,year|:))            
rc_200m = regCoef(year,dis_200m_an(lat|:,lon|:,year|:))            
rc_sur@long_name = "Trend"
rc_sur@units     = dis_sur_an@units+"/year"
rc_200m@long_name = "Trend"
rc_200m@units     = dis_200m_an@units+"/year"
copy_VarCoords(dis_sur_an(0,:,:), rc_sur)                ; copy lat,lon coords
copy_VarCoords(dis_200m_an(0,:,:), rc_200m)                ; copy lat,lon coords
rc_200m=rc_200m*151
rc_sur=rc_sur*151
printMinMax(rc_sur,1)
printMinMax(rc_200m,1)
;exit


plot=new(2,graphic)
 wks=gsn_open_wks("png",dir2+"Flat10_DIC_nat_trend_surface_200m_global_map")
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
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.020
 res@gsnCenterString="(a) Surface"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@lbLabelBarOn           = False
; res@tmXBLabelFontHeightF  =       0.025
; res@tmYLLabelFontHeightF  =       0.025
; res@tmXBLabelStride     =       2
; res@tmYLLabelStride     =       2
 sres                   =   res
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.18
 res@cnMinLevelValF         =      -0.18
 res@cnLevelSpacingF        =      0.02
 res@cnFillPalette          =       "GMT_polar"
 plot(0)=gsn_csm_contour_map(wks,rc_sur,res)
 res@gsnCenterString="(b) 200m"
 plot(1)=gsn_csm_contour_map(wks,rc_200m,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.015
 pres@lbLabelStride     =   3

 txres1               = True
 txres1@txFontHeightF = 0.016
 gsn_text_ndc(wks,"[mol m~S~-3~N~/151 years]",0.85,0.35,txres1)
 txres1@txFontHeightF = 0.02
 gsn_text_ndc(wks,"DIC~B~nat~N~ ",0.5,0.75,txres1)

 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
 gsn_panel(wks,plot,(/1,2/),pres)
 frame(wks)


end
