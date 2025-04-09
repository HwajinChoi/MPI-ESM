#!/bin/bash

for N in "north_pacific" "north_atlantic" "atlantic_zonal" "africa_to_atlantic" "south_pacific" ; do

if [ $N = "atlantic_zonal" ];then
  A="cfc11_real_r=f->cfc11(:,:,0,:)"
  B="cfc12_real_r=f->cfc12(:,:,0,:)"
  C="cfc11_ideal_r=g->cfc11(:,:,0,:)"
  D="cfc12_ideal_r=g->cfc12(:,:,0,:)"
 else
  A="cfc11_real_r=f->cfc11(:,:,:,0)"
  B="cfc12_real_r=f->cfc12(:,:,:,0)"
  C="cfc11_ideal_r=g->cfc11(:,:,:,0)"
  D="cfc12_ideal_r=g->cfc12(:,:,:,0)"
 fi

cat << EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_CFC/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"test_pictrl_ver2_002_r192x96_cfcs_${N}_20000101_20001231.nc","r")
g=addfile(dir1+"test_pictrl_ver2_002_r192x96_cfcs_ideal_${N}_20000101_20001231.nc","r")
${A}
${B}
${C}
${D}

cfc11_real=dim_avg_n_Wrap(cfc11_real_r,0)
cfc12_real=dim_avg_n_Wrap(cfc12_real_r,0)
cfc11_ideal=dim_avg_n_Wrap(cfc11_ideal_r,0)
cfc12_ideal=dim_avg_n_Wrap(cfc12_ideal_r,0)
;----------------------------------------------------------
cfc11_real=cfc11_real*1000
cfc12_real=cfc12_real*1000
cfc11_ideal=cfc11_ideal*1000
cfc12_ideal=cfc12_ideal*1000
;----------------------------------------------------------

plot=new(4,graphic)
wks   = gsn_open_wks ("png", dir2+"2D_verti_CFCs_${N}_in_2000" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnLineLabelsOn         =       False
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "BlAqGrYeOrRe"
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
;res@tmYLLabels =(..)
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnCenterStringFontHeightF= 0.028
res@gsnCenterStringOrthogonalPosF=0.05
res@gsnCenterString="(a) realistic"
res@gsnLeftString=""
res@gsnRightString=""
res@tmXBLabelFontHeightF=0.026
res@tmYLLabelFontHeightF=0.026
res@tiYAxisFontHeightF=0.028
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@tiYAxisString="Depth (m)"

res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
res@cnLevelSpacingF      = 0.5e-9                  ; contour spacing
res@cnMinLevelValF       = 5e-10                 ; min level
res@cnMaxLevelValF       =  6.5e-9                ; max level
plot(0)  = gsn_csm_contour(wks, cfc11_real, res )   ; plaace holder
res@tiYAxisString=""
res@gsnCenterString="(b) idealized"
plot(1)  = gsn_csm_contour(wks, cfc11_ideal, res )   ; plaace holder
res@tiYAxisString="Depth (m)"
res@gsnCenterString=""
res@cnLevelSpacingF      =0.25e-9
res@cnMinLevelValF       = 2.5e-10                 ; min level
res@cnMaxLevelValF       =  3.25e-9                ; max level
plot(2)  = gsn_csm_contour(wks, cfc12_real, res )   ; plaace holder
res@tiYAxisString=""
plot(3)  = gsn_csm_contour(wks, cfc12_ideal, res )   ; plaace holder

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 ;pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.013
 pres@lbLabelStride     =   3
 pres@pmLabelBarHeightF=0.06
 pres@pmLabelBarWidthF=0.65
 pres@gsnPanelMainString=""
 pres@gsnPanelLeft=0.1
 pres2=pres
 pres@gsnPanelMainString="${N} (2000)"
 pres@gsnPanelTop=0.9
 pres@gsnPanelBottom=0.48
 pres2@gsnPanelTop=0.5
 pres2@gsnPanelBottom=0.08

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.92,0.54,txres1)
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.92,0.15,txres1)
 txres1@txFontHeightF = 0.016
 gsn_text_ndc(wks,"CFC11",0.05,0.72,txres1)
 gsn_text_ndc(wks,"CFC12",0.05,0.33,txres1)
 txres1@txFontHeightF = 0.02
 gsn_panel(wks,plot(0:1),(/1,2/),pres)
 gsn_panel(wks,plot(2:3),(/1,2/),pres2)
 frame(wks)

end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
