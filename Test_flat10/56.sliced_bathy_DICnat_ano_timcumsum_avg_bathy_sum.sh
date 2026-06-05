#!/bin/bash

for V in "tsco212nat";do
 for j in $(seq 0 44);do

 S1=$((1850+10*j))
 S2=$((1859+10*j))

 R1=$((1+10*j))
 R2=$((9+10*j))

 D=flat10_cdr_budget_terms_${V}_${S1}_${S2}_ano_timcumsum_avg_bathy_sum.nc

cat << EOF > ./imsi.ncl
begin
i=4

dir1="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/data/budget_slice/"
f=addfile(dir3+"${D}","r")

avg_bathy=f->avg_bathy ; variable(tend ,adv, dif , gm, sosi, surf) * depth * lat * lon 
avg_bathy=avg_bathy*365.25*86400
lon=f->lon
lat=f->lat
avg_bathy@lat2d=lat
avg_bathy@lon2d=lon

avg_bathy=avg_bathy*1000

plot=new(6,graphic)
plot3=new(6,graphic)
plot2=new(6,graphic)

;do i =4,1

H1=500*(12-(3*i)+1)
H2=500*(12-(3*i)+2)
H3=500*(12-(3*i)+3)
h1=tostring(H1)
h2=tostring(H2)
h3=tostring(H3)

wks   = gsn_open_wks ("png", dir2+"Map_CDR_${V}_${S1}_${S2}_ano_timcumsum_avg_bathy_sum_"+i )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@vpWidthF       = 0.9            ; Change the aspect ratio, but 
res@lbLabelFontHeightF  = 0.023
res@vpHeightF      = 0.8
res@gsnDraw                =       False
res@gsnFrame               =       False
res@cnLineLabelsOn         =       False
res@cnFillOn             = True                 ; turn on color fill
res@cnInfoLabelOn          =   False
res@sfYArray = lat
res@sfXArray=lon
res@gsnMajorLonSpacing = 60

res@cnLinesOn=False
res@cnFillPalette        = "GMT_polar"
res@cnLevelSelectionMode   =       "ManualLevels"
;res@mpProjection ="Robinson"
res@mpMaxLatF=30
res@mpMinLatF=-90
res@mpPerimOn = False
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"

res@cnFillPalette        = "GMT_polar"
res@lbLabelBarOn           = True
res@gsnCenterString="Change"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     240
res@cnMinLevelValF         =     -240
res@cnLevelSpacingF        =      60
plot(0)  = gsn_csm_contour_map(wks, avg_bathy(0,3*i-1,:,:), res )   ; plaace holder
plot2(0)  = gsn_csm_contour_map(wks, avg_bathy(0,3*i-2,:,:), res )   ; plaace holder
plot3(0)  = gsn_csm_contour_map(wks, avg_bathy(0,3*i-3,:,:), res )   ; plaace holder
res@gsnCenterString="Advection"
plot(1)  = gsn_csm_contour_map(wks, avg_bathy(1,3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot(2)  = gsn_csm_contour_map(wks, avg_bathy(2,3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="GM"
plot(3)  = gsn_csm_contour_map(wks, avg_bathy(3,3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sinik"
plot(4)  = gsn_csm_contour_map(wks, avg_bathy(4,3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="Surf"
plot(5)  = gsn_csm_contour_map(wks, avg_bathy(5,3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="Advection"
plot2(1)  = gsn_csm_contour_map(wks, avg_bathy(1,3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot2(2)  = gsn_csm_contour_map(wks, avg_bathy(2,3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="GM"
plot2(3)  = gsn_csm_contour_map(wks, avg_bathy(3,3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sinik"
plot2(4)  = gsn_csm_contour_map(wks, avg_bathy(4,3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="Surf"
plot2(5)  = gsn_csm_contour_map(wks, avg_bathy(5,3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="Advection"
plot3(1)  = gsn_csm_contour_map(wks, avg_bathy(1,3*i-3,:,:),res )   ; plaace holder
res@gsnCenterString="Diffusion"
plot3(2)  = gsn_csm_contour_map(wks, avg_bathy(2,3*i-3,:,:),res )   ; plaace holder
res@gsnCenterString="GM"
plot3(3)  = gsn_csm_contour_map(wks, avg_bathy(3,3*i-3,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sinik"
plot3(4)  = gsn_csm_contour_map(wks, avg_bathy(4,3*i-3,:,:),res )   ; plaace holder
res@gsnCenterString="Surf"
plot3(5)  = gsn_csm_contour_map(wks, avg_bathy(5,3*i-3,:,:),res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 2
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.95
pres@gsnPanelLabelBar      = False
pres2=pres
pres3=pres
pres@gsnPanelTop=1.
pres@gsnPanelBottom=0.52
pres2@gsnPanelTop=0.76
pres2@gsnPanelBottom=0.32

pres3@gsnPanelTop=0.66
pres3@gsnPanelBottom=0.0
pres3@gsnPanelLeft=0.11
pres3@gsnPanelRight=0.94
pres3@gsnPanelLabelBar      = False
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.017

gsn_text_ndc(wks,"H - "+h1+"m",0.06,0.75,txres1)
gsn_text_ndc(wks,"H - "+h2+"m",0.06,0.54,txres1)
gsn_text_ndc(wks,"H - "+h3+"m",0.06,0.34,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.84,0.23,txres2)
txres2@txFontHeightF = 0.017
gsn_text_ndc(wks,"H : water column depth",0.84,0.88,txres2)
txres2@txFontHeightF = 0.02
gsn_text_ndc(wks,"Years ${R1}_${R2}",0.5,0.92,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)
end

EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl

 echo "${D}"
 done
exit
done
      
