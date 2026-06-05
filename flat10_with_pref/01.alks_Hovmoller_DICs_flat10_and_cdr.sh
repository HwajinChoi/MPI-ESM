#!/bin/bash

region=( North_Atl South_Atl South_Oce East_Pac )

for S in "${region[@]}" ;do

cat <<EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"
;----------------flat10-------------------------------------------------------------
f1=addfile(dir1+"${S}_talk_flat10_1850-2299_mean.nc","r")
f2=addfile(dir1+"${S}_talknat_flat10_1850-2299_mean.nc","r")
alk=f1->talk(:,:,0,0)
alknat=f2->talknat(:,:,0,0)
depth=f1->depth

alk_an=month_to_annual(alk,1)
alknat_an=month_to_annual(alknat,1)
alkant_an=alk_an-alknat_an
copy_VarCoords(alk_an,alkant_an)
;----------------flat10_cdr-------------------------------------------------------------
h1=addfile(dir1+"${S}_talk_flat10_cdr_1850-2299_mean.nc","r")
h2=addfile(dir1+"${S}_talknat_flat10_cdr_1850-2299_mean.nc","r")
alk_cdr=h1->talk(:,:,0,0)
alknat_cdr=h2->talknat(:,:,0,0)

alk_cdr_an=month_to_annual(alk_cdr,1)
alknat_cdr_an=month_to_annual(alknat_cdr,1)
alkant_cdr_an=alk_cdr_an-alknat_cdr_an
copy_VarCoords(alk_cdr_an,alkant_cdr_an)
;----------     PI  ---------------------------------------------------------------
g1=addfile(dir3+"${S}_talk_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
g2=addfile(dir3+"${S}_talknat_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
alk_pi=g1->talk(:,:,0,0)
alknat_pi=g2->talknat(:,:,0,0)

alk_pi_clim=dim_avg_n_Wrap(alk_pi,0)
alknat_pi_clim=dim_avg_n_Wrap(alknat_pi,0)

dim0=dimsizes(alk_pi)

ALK_PI_CLIM=new((/450,dim0(1)/),typeof(alk_pi_clim))
ALKNAT_PI_CLIM=new((/450,dim0(1)/),typeof(alk_pi_clim))

do i=0,450-1
 ALK_PI_CLIM(i,:)=alk_pi_clim
 ALKNAT_PI_CLIM(i,:)=alknat_pi_clim
end do
;----------------------------------------------------------------------------------
alk_an_diff=alk_an-ALK_PI_CLIM
alknat_an_diff=alknat_an-ALKNAT_PI_CLIM
copy_VarCoords(alk_an,alk_an_diff)
copy_VarCoords(alknat_an,alknat_an_diff)

alk_cdr_an_diff=alk_cdr_an-ALK_PI_CLIM
alknat_cdr_an_diff=alknat_cdr_an-ALKNAT_PI_CLIM
copy_VarCoords(alk_an,alk_cdr_an_diff)
copy_VarCoords(alknat_an,alknat_cdr_an_diff)
;----------------------------------------------------------------------------------
alk_cdr_an_diff := alk_cdr_an_diff(depth|:,year|:)
alknat_cdr_an_diff := alknat_cdr_an_diff(depth|:,year|:)
alk_an_diff := alk_an_diff(depth|:,year|:)
alknat_an_diff := alknat_an_diff(depth|:,year|:)
alkant_cdr_an := alkant_cdr_an(depth|:,year|:)
alkant_an := alkant_an(depth|:,year|:)
;----------------------------------------------------------------------------------
printMinMax(alk_an_diff,0)
printMinMax(alknat_an_diff,0)

printMinMax(alk_cdr_an_diff,0)
printMinMax(alknat_cdr_an_diff,0)

printMinMax(alkant_an,0)
printMinMax(alkant_cdr_an,0)
x=ispan(1,450,1)
;----------------------------------------------------------------------------------
plot=new(6,graphic)
wks=gsn_open_wks("png",dir2+"Hovmuller_ALKs_flat10_and_cdr_${S}")
res                       = True     ; plot mods desired
; Set resources for when we turn on labelbar later
res@gsnFrame               =       False
res@gsnDraw                =       False
res@gsnMaximize          = False
res@lbLabelBarOn           = False
res@lbTitleFontHeightF         = .02                 ; make title smaller
res@lbTitleString              = ""            ; title string
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelStride              = 2
res@lbLabelFontHeightF         = 0.02
res@pmLabelBarHeightF          = 0.4
res@lbBoxEndCapStyle           = "TriangleBothEnds"
res@lbOrientation              = "Vertical"        ; orientation

res@vpWidthF = 0.6
res@vpHeightF = 0.35
;res@pmLabelBarOrthogonalPosF=0.3
res@cnLevelSelectionMode="ManualLevels"
res@cnFillOn              = True     ; turn on color fill
res@cnLinesOn             = False    ; turn of contour lines
res@cnLineLabelsOn        = False    ; turn of contour line labels
res@cnFillPalette         = "GMT_polar"
res@tmYLMode              = "Automatic"
res@gsnCenterStringFontHeightF= 0.035
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.025
res@tmYLLabelFontHeightF=0.025
res@tiYAxisFontHeightF=0.03
res@tiXAxisFontHeightF=0.03

res@trYReverse            = True     ; reverse the y (time) axis
res@gsnYAxisIrregular2Linear = True
res@cnMissingValFillColor="black"
res@tiYAxisString="Depth (m)"
res@tiXAxisString=""
res@cnInfoLabelOn          =   False

;res@gsnMaximize           = True
;res@gsnPaperOrientation   = "portrait"

res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     0.03
res@cnMinLevelValF         =     -0.03
res@cnLevelSpacingF        =      0.003

res@gsnCenterString="flat10"
plot(0)   = gsn_csm_contour(wks,alk_an_diff, res)
res@gsnCenterString="flat10-cdr"
res@tiYAxisString=""
res@lbLabelBarOn           = True
res@tiYAxisString=""
plot(1)   = gsn_csm_contour(wks,alk_cdr_an_diff, res)
res@gsnCenterString="flat10-zec"
res@lbLabelBarOn           = False
res@gsnCenterString=""
res@tiYAxisString="Depth (m)"
plot(2)   = gsn_csm_contour(wks,alknat_an_diff, res)
res@tiYAxisString=""
res@lbLabelBarOn           = True
plot(3)   = gsn_csm_contour(wks,alknat_cdr_an_diff, res)
res@tiYAxisString="Depth (m)"
res@tiXAxisString="Year"
res@lbLabelBarOn           = False
plot(4)   = gsn_csm_contour(wks,alkant_an, res)
res@tiYAxisString=""
res@tiXAxisString="Year"
res@lbLabelBarOn           = True
plot(5)   = gsn_csm_contour(wks,alkant_cdr_an, res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 0
pres@gsnPanelXWhiteSpacePercent = 0
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString="${S}"
pres@gsnPanelLeft=0.04
pres@gsnPanelRight=0.9
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"ALK~B~tot~N~",0.02,0.752,txres1)
gsn_text_ndc(wks,"ALK~B~nat~N~",0.02,0.48,txres1)
gsn_text_ndc(wks,"ALK~B~ant~N~",0.02,0.19,txres1)

gsn_panel(wks,plot,(/3,2/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
