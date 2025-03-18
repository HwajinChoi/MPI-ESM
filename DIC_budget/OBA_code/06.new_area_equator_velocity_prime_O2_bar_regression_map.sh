#!/bin/sh
dir1=/data/hjchoi/CMI/data/area_avg_timese
dir2=/data/hjchoi/CMI/OBA/data/advection
dir4=/data/hjchoi/CMI/OBA/image

#for v in "dt_0-100" "dt_100-300" "dt_300-800" "dx_0-100" "dx_100-300" "dx_300-800" "dy_0-100" "dy_100-300" "dy_300-800" "dz"; do 
for v in "dx_100-300" "dy_100-300" "dz"; do 
#for v in "temp_100-300m" ; do 
 if [ $v = "dt_0-100" ] || [ $v = "dt_100-300" ] || [ $v = "dt_300-800"  ]; then
 A=${dir2}/ECDA-COBALT_dO_${v}_advection_199001-201712.nc
 C="Ot_prime=g->Ot_prime(12:335,:,:) ;time*lat*lon (monthly)"
 F="Ot_prime"
 H="dO*/dt"
 HHH="dO*_dt"
 AAA="res@cnMaxLevelValF         =     60"
 BBB="res@cnMinLevelValF         =     -60"
 CCC="res@cnLevelSpacingF        =   5"
 elif [ $v = "dx_0-100" ] || [ $v = "dx_100-300" ] || [ $v = "dx_300-800" ]; then
 A=${dir2}/ECDA-COBALT_dO_${v}_advection_199001-201712.nc
 C="u_prime_O_bar=g->u_prime_O_bar(12:335,:,:) ;time*lat*lon (monthly)"
 F="u_prime_O_bar"
 H="U* dO bar/dx"
 HHH="U*_dObar_dx"
 AAA="res@cnMaxLevelValF         =     30"
 BBB="res@cnMinLevelValF         =     -30"
 CCC="res@cnLevelSpacingF        =   3"
 elif [ $v = "dy_0-100" ] || [ $v = "dy_100-300" ] || [ $v = "dy_300-800" ]; then
 A=${dir2}/ECDA-COBALT_dO_${v}_advection_199001-201712.nc
 C="v_prime_O_bar=g->v_prime_O_bar(12:335,:,:) ;time*lat*lon (monthly)"
 F="v_prime_O_bar"
 H="V* dO bar/dy"
 HHH="V*_dObar_dy"
 AAA="res@cnMaxLevelValF         =     20" 
 BBB="res@cnMinLevelValF         =     -20"
 CCC="res@cnLevelSpacingF        =   2" 
 else
 A=${dir2}/ECDA-COBALT_dO_${v}_all_depth_advection_199001-201712.nc
 C="w_prime_O_bar=g->w_prime_O_bar(12:335,:,:,1) ;time*lat*lon (monthly)"
 F="w_prime_O_bar"
 H="W* dO bar/dz"
 HHH="W*_dObar_dz"
 AAA="res@cnMaxLevelValF         =     10"
 BBB="res@cnMinLevelValF         =     -10"
 CCC="res@cnLevelSpacingF        =   2"
 fi

#for r in "NE" "SE" "AO" ; do
 for r in "EQUATOR" ; do

  if [ $r = "NE" ]; then
  D="ypts=(/20,20, 0,0,20/)"
  E="xpts=(/120,210,210,120,120/)"
  elif [ $r = "SE" ]; then
  D="ypts=(/-20,-20, 0,0,-20/)"
  E="xpts=(/180,270,270,180,180/)"
  elif [ $r = "EQUATOR" ]; then
  D="ypts=(/-20,-20, 20,20,-20/)"
  E="xpts=(/150,270,270,150,150/)"
  else
  D="ypts=(/70,70, 90,90,70/)"
  E="xpts=(/150,240,240,150,150/)"
  fi

  #for e in "0.2" "0.7" "1.2"; do
  for e in "0.7" ; do
  cat <<EOF > ./imsi.ncl
;----------------------------------------------------------------------
; Pattern regression
;----------------------------------------------------------------------
begin
f=addfile("${dir1}/CMI_COBALT_${e}_${r}_100-300m_area_averaged_timeseries_1991-2017.nc","r")
MI=f->CMI ;depth*year
MI2=MI(0:25)
g=addfile("${A}","r")
${C}
${F}=${F}*60*60*24*30
${F}!1="lat"
${F}!2="lon"
lat=${F}&lat
lon=${F}&lon
${F}_2=${F}(12:323,:,:) ; SST data for 1991-2017 
depth=(/"0-100m","100-300m","300-800m"/)
;----------------------------------------------------------------------------
; Spatial regression => 1 year
;----------------------------------------------------------------------------
${F}_JFM1=month_to_season(${F},"JFM")
${F}_AMJ1=month_to_season(${F},"AMJ")
${F}_JAS1=month_to_season(${F},"JAS")
${F}_OND1=month_to_season(${F},"OND")

${F}_JFM1 := ${F}_JFM1(lat|:,lon|:,time|:) 
${F}_AMJ1 := ${F}_AMJ1(lat|:,lon|:,time|:)
${F}_JAS1 := ${F}_JAS1(lat|:,lon|:,time|:)
${F}_OND1 := ${F}_OND1(lat|:,lon|:,time|:)
;----------------------------------------------------------------------------
; Spatial regression => 2 year
;----------------------------------------------------------------------------
${F}2_JFM1=month_to_season(${F}_2,"JFM")
${F}2_AMJ1=month_to_season(${F}_2,"AMJ")
${F}2_JAS1=month_to_season(${F}_2,"JAS")
${F}2_OND1=month_to_season(${F}_2,"OND")

${F}2_JFM1 := ${F}2_JFM1(lat|:,lon|:,time|:) 
${F}2_AMJ1 := ${F}2_AMJ1(lat|:,lon|:,time|:)
${F}2_JAS1 := ${F}2_JAS1(lat|:,lon|:,time|:)
${F}2_OND1 := ${F}2_OND1(lat|:,lon|:,time|:)
;----------------------------------------------------------------------------
; Calculate significance of regression - 1 year
;----------------------------------------------------------------------------
siglvl=0.05
reg_JFM1=regCoef(MI,${F}_JFM1) ; depth*lat*lon
reg_JFM1!0="lat"
reg_JFM1!1="lon"
reg_JFM1&lat=lat
reg_JFM1&lon=lon
tval = onedtond(reg_JFM1@tval , dimsizes(reg_JFM1))
df   = onedtond(reg_JFM1@nptxy, dimsizes(reg_JFM1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob_JFM1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg_JFM1,prob_JFM1)
delete([/tval,df,b/])
sig_JFM1=where(prob_JFM1 .lt. siglvl,2,-1)
copy_VarCoords(reg_JFM1,sig_JFM1)
;----------------------------------------------------------------------------
reg_AMJ1=regCoef(MI,${F}_AMJ1) ; depth*lat*lon
reg_AMJ1!0="lat"
reg_AMJ1!1="lon"
reg_AMJ1&lat=lat
reg_AMJ1&lon=lon
tval = onedtond(reg_AMJ1@tval , dimsizes(reg_AMJ1))
df   = onedtond(reg_AMJ1@nptxy, dimsizes(reg_AMJ1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob_AMJ1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg_AMJ1,prob_AMJ1)
delete([/tval,df,b/])
sig_AMJ1=where(prob_AMJ1 .lt. siglvl,2,-1)
copy_VarCoords(reg_AMJ1,sig_AMJ1)
;---------------------------------------------------------------------------------
reg_JAS1=regCoef(MI,${F}_JAS1) ; depth*lat*lon
reg_JAS1!0="lat"
reg_JAS1!1="lon"
reg_JAS1&lat=lat
reg_JAS1&lon=lon
tval = onedtond(reg_JAS1@tval , dimsizes(reg_JAS1))
df   = onedtond(reg_JAS1@nptxy, dimsizes(reg_JAS1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob_JAS1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg_JAS1,prob_JAS1)
delete([/tval,df,b/])
sig_JAS1=where(prob_JAS1 .lt. siglvl,2,-1)
copy_VarCoords(reg_JAS1,sig_JAS1)
;----------------------------------------------------------------------------
reg_OND1=regCoef(MI,${F}_OND1) ; depth*lat*lon
reg_OND1!0="lat"
reg_OND1!1="lon"
reg_OND1&lat=lat
reg_OND1&lon=lon
tval = onedtond(reg_OND1@tval , dimsizes(reg_OND1))
df   = onedtond(reg_OND1@nptxy, dimsizes(reg_OND1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob_OND1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg_OND1,prob_OND1)
delete([/tval,df,b/])
sig_OND1=where(prob_OND1 .lt. siglvl,2,-1)
copy_VarCoords(reg_OND1,sig_OND1)
;----------------------------------------------------------------------------
; Calculate significance of regression - 2 years
;----------------------------------------------------------------------------
reg2_JFM1=regCoef(MI2,${F}2_JFM1) ; depth*lat*lon
reg2_JFM1!0="lat"
reg2_JFM1!1="lon"
reg2_JFM1&lat=lat
reg2_JFM1&lon=lon
tval = onedtond(reg2_JFM1@tval , dimsizes(reg2_JFM1))
df   = onedtond(reg2_JFM1@nptxy, dimsizes(reg2_JFM1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob2_JFM1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg2_JFM1,prob2_JFM1)
delete([/tval,df,b/])
sig2_JFM1=where(prob2_JFM1 .lt. siglvl,2,-1)
copy_VarCoords(reg2_JFM1,sig2_JFM1)
;----------------------------------------------------------------------------
reg2_AMJ1=regCoef(MI2,${F}2_AMJ1) ; depth*lat*lon
reg2_AMJ1!0="lat"
reg2_AMJ1!1="lon"
reg2_AMJ1&lat=lat
reg2_AMJ1&lon=lon
tval = onedtond(reg2_AMJ1@tval , dimsizes(reg2_AMJ1))
df   = onedtond(reg2_AMJ1@nptxy, dimsizes(reg2_AMJ1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob2_AMJ1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg2_AMJ1,prob2_AMJ1)
delete([/tval,df,b/])
sig2_AMJ1=where(prob2_AMJ1 .lt. siglvl,2,-1)
copy_VarCoords(reg2_AMJ1,sig2_AMJ1)
;---------------------------------------------------------------------------------
reg2_JAS1=regCoef(MI2,${F}2_JAS1) ; depth*lat*lon
reg2_JAS1!0="lat"
reg2_JAS1!1="lon"
reg2_JAS1&lat=lat
reg2_JAS1&lon=lon
tval = onedtond(reg2_JAS1@tval , dimsizes(reg2_JAS1))
df   = onedtond(reg2_JAS1@nptxy, dimsizes(reg2_JAS1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob2_JAS1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg2_JAS1,prob2_JAS1)
delete([/tval,df,b/])
sig2_JAS1=where(prob2_JAS1 .lt. siglvl,2,-1)
copy_VarCoords(reg2_JAS1,sig2_JAS1)
;----------------------------------------------------------------------------
reg2_OND1=regCoef(MI2,${F}2_OND1) ; depth*lat*lon
reg2_OND1!0="lat"
reg2_OND1!1="lon"
reg2_OND1&lat=lat
reg2_OND1&lon=lon
tval = onedtond(reg2_OND1@tval , dimsizes(reg2_OND1))
df   = onedtond(reg2_OND1@nptxy, dimsizes(reg2_OND1)) - 2
b = tval    ; b must be same size as tval (and df)
b = 0.5
prob2_OND1 = betainc(df/(df+tval^2),df/2.0,b)       ; prob(depth,lat,lon)
copy_VarCoords(reg2_OND1,prob2_OND1)
delete([/tval,df,b/])
sig2_OND1=where(prob2_OND1 .lt. siglvl,2,-1)
copy_VarCoords(reg2_OND1,sig2_OND1)
;----------------------------------------------------------------------------
 plot=new(7,graphic)
 plot1=new(7,graphic)
 wks=gsn_open_wks("png","${dir4}/${HHH}_${r}_CMI_${e}_100-300m_and_pattern_reg_${v}_1991-2017")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@lbLabelBarOn           =      False
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@lbLabelBarOn           = False
 res@tmXBLabelFontHeightF   =       0.025
 res@tmYLLabelFontHeightF   =       0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 sres                   =   res
 res@cnInfoLabelOn          =   False
 res@mpCenterLonF       =       180
 res@mpLandFillColor    =   "white"

 res@cnLevelSelectionMode   =       "ManualLevels"
 ${AAA}
 ${BBB}
 ${CCC}
 ;res@cnMaxLevelValF         =     0.0003 
 ;res@cnMinLevelValF         =     -0.0003
 ;res@cnLevelSpacingF        =   0.00005 

 ;res@cnMaxLevelValF         =    40 
 ;res@cnMinLevelValF         =     -40
 ;res@cnLevelSpacingF        =       10
 res@cnFillPalette          =       "temp_19lev"

 sres@cnConstFEnableFill    =   True
 sres@cnMonoFillColor   =   True
 sres@cnFillColor       =   "black"
 sres@cnFillOn              =       True
 sres@cnMonoFillPattern =   True
 sres@cnFillScaleF      =   1
 sres@cnFillPattern     =   17
 sres@cnLinesOn             =       False
 sres@cnLevelSelectionMode = "ExplicitLevels"
 sres@cnLevels = (/1,3/)
 sres@cnInfoLabelOn = False
 sres@tiMainOn = False
 sres@gsnCenterString   = ""
 sres@lbLabelBarOn      =   False
 sres@cnFillDotSizeF=0.0025
 sres@cnConstFLabelOn=False
 sres@trGridType="TriangularMesh"

 opt            =   True
 opt@gsnShadeHigh         = 17
 opt@gsnShadeFillType     = "pattern"
 opt@gsnShadeFillScaleF   = 0.5
 opt@gsnShadeFillDotSizeF = 0.06
;---------------------------------------------------------------------------
 ;res@gsnCenterString        =  "JFM(0)-"+depth(1)
 res@gsnCenterString        =  "JFM(0)"
 ;symMinMaxPlt(reg_JFM1(i,:,:),20,False,res) 
 plot(0)=gsn_csm_contour_map(wks,reg_JFM1,res)
 plot1(0)=gsn_csm_contour(wks,sig_JFM1,sres)
 plot1(0)=ShadeGtContour(plot1(0),2,17)
 overlay(plot(0),plot1(0))

 ;symMinMaxPlt(reg_AMJ1(i,:,:),20,False,res) 
 ;res@gsnCenterString        =  "AMJ(0)-"+depth(1)
 res@gsnCenterString        =  "AMJ(0)"
 plot(1)=gsn_csm_contour_map(wks,reg_AMJ1,res)
 plot1(1)=gsn_csm_contour(wks,sig_AMJ1,sres)
 plot1(1)=ShadeGtContour(plot1(1),2,17)
 overlay(plot(1),plot1(1))

 ;res@gsnCenterString        =  "JAS(0)-"+depth(1)
 res@gsnCenterString        =  "JAS(0)"
 plot(2)=gsn_csm_contour_map(wks,reg_JAS1,res)
 plot1(2)=gsn_csm_contour(wks,sig_JAS1,sres)
 plot1(2)=ShadeGtContour(plot1(2),2,17)
 overlay(plot(2),plot1(2))

 ;res@gsnCenterString        =  "OND(0)-"+depth(1)
 res@gsnCenterString        =  "OND(0)"
 plot(3)=gsn_csm_contour_map(wks,reg_OND1,res)
 plot1(3)=gsn_csm_contour(wks,sig_OND1,sres)
 plot1(3)=ShadeGtContour(plot1(3),2,17)
 overlay(plot(3),plot1(3))

 ;res@gsnCenterString        =  "JFM(1)-"+depth(1)
 res@gsnCenterString        =  "JFM(1)"
 plot(4)=gsn_csm_contour_map(wks,reg2_JFM1,res)
 plot1(4)=gsn_csm_contour(wks,sig2_JFM1,sres)
 plot1(4)=ShadeGtContour(plot1(4),2,17)
 overlay(plot(4),plot1(4))

 ;res@gsnCenterString        =  "AMJ(1)-"+depth(1)
 res@gsnCenterString        =  "AMJ(1)"
 plot(5)=gsn_csm_contour_map(wks,reg2_AMJ1,res)
 plot1(5)=gsn_csm_contour(wks,sig2_AMJ1,sres)
 plot1(5)=ShadeGtContour(plot1(5),2,17)
 overlay(plot(5),plot1(5))

 ;res@gsnCenterString        =  "JAS(1)-"+depth(1)
 res@gsnCenterString        =  "JAS(1)"
 plot(6)=gsn_csm_contour_map(wks,reg2_JAS1,res)
 plot1(6)=gsn_csm_contour(wks,sig2_JAS1,sres)
 plot1(6)=ShadeGtContour(plot1(6),2,17)
 overlay(plot(6),plot1(6))

 ${D}
 ${E}
 resp                  = True                      ; polyline mods desired
 resp@gsLineColor      = "grey20"                     ; color of lines
 resp@gsLineThicknessF = 3.0                       ; thickness of lines
 resp@gsLineDashPattern= 0
 resp@tfPolyDrawOrder   =   "PostDraw"
 dum1 = new(7,graphic)
 do j = 0 ,6
  dum1(j)=gsn_add_polyline(wks,plot(j),xpts,ypts,resp)
 end do

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@lbLabelFontHeightF  = 0.010
 pres@lbLabelStride     =   2
 pres@gsnPanelRowSpec = True
 pres@gsnPanelCenter = False
 pres@gsnPanelMainString = "${r}_Meta|${e}|_"+depth(1)+"_regression_${H}"

 gsn_panel(wks,plot,(/3,3,1/),pres)
 frame(wks)

end
EOF
   ncl ./imsi.ncl
rm -f ./imsi.ncl
    done
  done
 done

