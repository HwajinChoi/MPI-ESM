#!/bin/bash

region=( North_Atl South_Atl South_Oce East_Pac )

for S in "${region[@]}" ;do

cat <<EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"
;----------------flat10-------------------------------------------------------------
f1=addfile(dir1+"${S}_thetao_flat10_1850-2299_mean.nc","r")
f2=addfile(dir1+"${S}_dissicnat_flat10_1850-2299_mean.nc","r")
temp=f1->thetao(:,:,0,0)
dicnat=f2->dissicnat(:,:,0,0)
depth=f1->depth

temp_an=month_to_annual(temp,1)
dicnat_an=month_to_annual(dicnat,1)

;----------------flat10_cdr-------------------------------------------------------------
h1=addfile(dir1+"${S}_thetao_flat10_cdr_1850-2299_mean.nc","r")
h2=addfile(dir1+"${S}_dissicnat_flat10_cdr_1850-2299_mean.nc","r")
dic_cdr=h1->dissic(:,:,0,0)
dicnat_cdr=h2->dissicnat(:,:,0,0)

dic_cdr_an=month_to_annual(dic_cdr,1)
dicnat_cdr_an=month_to_annual(dicnat_cdr,1)
dicant_cdr_an=dic_cdr_an-dicnat_cdr_an
copy_VarCoords(dic_cdr_an,dicant_cdr_an)
;----------     PI  ---------------------------------------------------------------
g1=addfile(dir3+"${S}_thetao_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
g2=addfile(dir3+"${S}_dissicnat_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
dic_pi=g1->dissic(:,:,0,0)
dicnat_pi=g2->dissicnat(:,:,0,0)

dic_pi_clim=dim_avg_n_Wrap(dic_pi,0)
dicnat_pi_clim=dim_avg_n_Wrap(dicnat_pi,0)

dim0=dimsizes(dic_pi)

DIC_PI_CLIM=new((/450,dim0(1)/),typeof(dic_pi_clim))
DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(dic_pi_clim))

do i=0,450-1
 DIC_PI_CLIM(i,:)=dic_pi_clim
 DICNAT_PI_CLIM(i,:)=dicnat_pi_clim
end do
;----------------------------------------------------------------------------------
dic_an_diff=dic_an-DIC_PI_CLIM
dicnat_an_diff=dicnat_an-DICNAT_PI_CLIM
copy_VarCoords(dic_an,dic_an_diff)
copy_VarCoords(dicnat_an,dicnat_an_diff)

dic_cdr_an_diff=dic_cdr_an-DIC_PI_CLIM
dicnat_cdr_an_diff=dicnat_cdr_an-DICNAT_PI_CLIM
copy_VarCoords(dic_an,dic_cdr_an_diff)
copy_VarCoords(dicnat_an,dicnat_cdr_an_diff)
;----------------------------------------------------------------------------------
dic_cdr_an_diff := dic_cdr_an_diff(depth|:,year|:)
dicnat_cdr_an_diff := dicnat_cdr_an_diff(depth|:,year|:)
dic_an_diff := dic_an_diff(depth|:,year|:)
dicnat_an_diff := dicnat_an_diff(depth|:,year|:)
dicant_cdr_an := dicant_cdr_an(depth|:,year|:)
dicant_an := dicant_an(depth|:,year|:)
;----------------------------------------------------------------------------------
;printMinMax(dic_an_diff,0)
;printMinMax(dicnat_an_diff,0)

;printMinMax(dic_cdr_an_diff,0)
;printMinMax(dicnat_cdr_an_diff,0)

;printMinMax(dicant_an,0)
;printMinMax(dicant_cdr_an,0)
x=ispan(1,450,1)
;----------------------------------------------------------------------------------
plot=new(9,graphic)
wks=gsn_open_wks("png",dir2+"Hovmuller_DICs_flat10_and_cdr")
res                       = True     ; plot mods desired
; Set resources for when we turn on labelbar later
res@gsnFrame               =       False
res@gsnDraw                =       False
res@lbLabelBarOn           = False
res@lbTitleFontHeightF         = .02                 ; make title smaller
res@lbTitleString              = ""            ; title string
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelStride              = 2
res@lbLabelFontHeightF         = 0.04
res@pmLabelBarHeightF          = 0.6
res@lbBoxEndCapStyle           = "TriangleBothEnds"
res@lbOrientation              = "Vertical"        ; orientation

res@vpWidthF = 0.8
res@vpHeightF = 0.4
;res@pmLabelBarOrthogonalPosF=0.3
res@cnLevelSelectionMode="ManualLevels"
res@cnFillOn              = True     ; turn on color fill
res@cnLinesOn             = False    ; turn of contour lines
res@cnLineLabelsOn        = False    ; turn of contour line labels
res@cnFillPalette         = "GMT_polar"
res@tmYLMode              = "Automatic"
res@gsnCenterStringFontHeightF= 0.043
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.03
res@tmYLLabelFontHeightF=0.03
res@tiYAxisFontHeightF=0.04
res@tiXAxisFontHeightF=0.04

res@trYReverse            = True     ; reverse the y (time) axis
res@gsnYAxisIrregular2Linear = True
res@cnMissingValFillColor="black"
res@tiYAxisString="Depth (m)"
res@tiXAxisString=""
res@cnInfoLabelOn          =   False

res@gsnMaximize           = True
res@gsnPaperOrientation   = "portrait"

res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     0.18
res@cnMinLevelValF         =     -0.18
res@cnLevelSpacingF        =      0.02

res@gsnCenterString="flat10"
plot(0)   = gsn_csm_contour(wks,dic_an_diff, res)
res@gsnCenterString="flat10-cdr"
res@tiYAxisString=""
plot(1)   = gsn_csm_contour(wks,dic_cdr_an_diff, res)
res@gsnCenterString="flat10-zec"

res@lbLabelBarOn           = False
res@gsnCenterString=""
res@tiYAxisString="Depth (m)"
plot(3)   = gsn_csm_contour(wks,dicnat_an_diff, res)
res@tiYAxisString=""
plot(4)   = gsn_csm_contour(wks,dicnat_cdr_an_diff, res)

res@tiYAxisString="Depth (m)"
res@tiXAxisString="Year"
plot(6)   = gsn_csm_contour(wks,dicant_an, res)
res@tiYAxisString=""
res@tiXAxisString="Year"
plot(7)   = gsn_csm_contour(wks,dicant_cdr_an, res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 0
pres@gsnPanelXWhiteSpacePercent = 0
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString="${S}"
pres@gsnPanelLeft=0.04
pres@gsnPanelRight=0.95
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"DIC~B~tot~N~",0.02,0.66,txres1)
gsn_text_ndc(wks,"DIC~B~nat~N~",0.02,0.48,txres1)
gsn_text_ndc(wks,"DIC~B~ant~N~",0.02,0.29,txres1)

gsn_panel(wks,plot,(/3,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
exit
done
