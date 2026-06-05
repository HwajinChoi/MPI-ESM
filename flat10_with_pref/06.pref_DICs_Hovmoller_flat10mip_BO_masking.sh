#!/bin/bash

region=( atl pac ind arc ) 

for S in "${region[@]}" ;do

cat <<EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"
;----------------flat10-------------------------------------------------------------
f01=addfile(dir1+"${S}_mean_dissic_flat10_1850-2299.nc","r")
f02=addfile(dir1+"${S}_mean_dissicnat_flat10_1850-2299.nc","r")
dic=f01->dissic(:,:,0,0)
dicnat=f02->dissicnat(:,:,0,0)

f1=addfile(dir1+"${S}_mean_preformed_DIC_flat10_1850-2299.nc","r")
f2=addfile(dir1+"${S}_mean_preformed_DICnat_flat10_1850-2299.nc","r")
pre_dic=f1->preformed_DIC(:,:,0,0)
pre_dicnat=f2->preformed_DICnat(:,:,0,0)
depth=f1->depth
pre_dic=pre_dic*1000
pre_dicnat=pre_dicnat*1000

reg_dic=dic-pre_dic
reg_dicnat=dicnat-pre_dicnat
copy_VarCoords(pre_dic,reg_dic)
copy_VarCoords(pre_dicnat,reg_dicnat)

reg_dic_an=month_to_annual(reg_dic,1)
reg_dicnat_an=month_to_annual(reg_dicnat,1)
pre_dic_an=month_to_annual(pre_dic,1)
pre_dicnat_an=month_to_annual(pre_dicnat,1)
;----------------flat10_zec-------------------------------------------------------------
k01=addfile(dir1+"${S}_mean_dissic_flat10_zec_1850-2299.nc","r")
k02=addfile(dir1+"${S}_mean_dissicnat_flat10_zec_1850-2299.nc","r")
dic_zec=k01->dissic(:,:,0,0)
dicnat_zec=k02->dissicnat(:,:,0,0)

k1=addfile(dir1+"${S}_mean_preformed_DIC_flat10_zec_1850-2299.nc","r")
k2=addfile(dir1+"${S}_mean_preformed_DICnat_flat10_zec_1850-2299.nc","r")
pre_dic_zec=k1->preformed_DIC(:,:,0,0)
pre_dicnat_zec=k2->preformed_DICnat(:,:,0,0)
pre_dic_zec=pre_dic_zec*1000
pre_dicnat_zec=pre_dicnat_zec*1000

reg_dic_zec=dic_zec-pre_dic_zec
reg_dicnat_zec=dicnat_zec-pre_dicnat_zec
copy_VarCoords(pre_dic_zec,reg_dic_zec)
copy_VarCoords(pre_dicnat_zec,reg_dicnat_zec)

reg_dic_zec_an=month_to_annual(reg_dic_zec,1)
reg_dicnat_zec_an=month_to_annual(reg_dicnat_zec,1)
pre_dic_zec_an=month_to_annual(pre_dic_zec,1)
pre_dicnat_zec_an=month_to_annual(pre_dicnat_zec,1)
;----------------flat10_cdr-------------------------------------------------------------
h01=addfile(dir1+"${S}_mean_dissic_flat10_cdr_1850-2299.nc","r")
h02=addfile(dir1+"${S}_mean_dissicnat_flat10_cdr_1850-2299.nc","r")
dic_cdr=h01->dissic(:,:,0,0)
dicnat_cdr=h02->dissicnat(:,:,0,0)

h1=addfile(dir1+"${S}_mean_preformed_DIC_flat10_cdr_1850-2299.nc","r")
h2=addfile(dir1+"${S}_mean_preformed_DICnat_flat10_cdr_1850-2299.nc","r")
pre_dic_cdr=h1->preformed_DIC(:,:,0,0)
pre_dicnat_cdr=h2->preformed_DICnat(:,:,0,0)
pre_dic_cdr=pre_dic_cdr*1000
pre_dicnat_cdr=pre_dicnat_cdr*1000

reg_dic_cdr=dic_cdr-pre_dic_cdr
reg_dicnat_cdr=dicnat_cdr-pre_dicnat_cdr
copy_VarCoords(pre_dic_cdr,reg_dic_cdr)
copy_VarCoords(pre_dicnat_cdr,reg_dicnat_cdr)

reg_dic_cdr_an=month_to_annual(reg_dic_cdr,1)
reg_dicnat_cdr_an=month_to_annual(reg_dicnat_cdr,1)
pre_dic_cdr_an=month_to_annual(pre_dic_cdr,1)
pre_dicnat_cdr_an=month_to_annual(pre_dicnat_cdr,1)

;----------     PI  ---------------------------------------------------------------
g01=addfile(dir3+"${S}_mean_dissic_test_pictrl_preform_001_spinup_8920-8949.nc","r")
g02=addfile(dir3+"${S}_mean_dissicnat_test_pictrl_preform_001_spinup_8920-8949.nc","r")
dic_pi=g01->dissic(:,:,0,0)
dicnat_pi=g02->dissicnat(:,:,0,0)

g1=addfile(dir3+"${S}_mean_preformed_DIC_test_pictrl_preform_001_spinup_8920-8949.nc","r")
g2=addfile(dir3+"${S}_mean_preformed_DICnat_test_pictrl_preform_001_spinup_8920-8949.nc","r")
pre_dic_pi=g1->preformed_DIC(:,:,0,0)
pre_dicnat_pi=g2->preformed_DICnat(:,:,0,0)
pre_dic_pi=pre_dic_pi*1000
pre_dicnat_pi=pre_dicnat_pi*1000

reg_dic_pi=dic_pi-pre_dic_pi
reg_dicnat_pi=dicnat_pi-pre_dicnat_pi
copy_VarCoords(dic_pi,reg_dic_pi)
copy_VarCoords(dicnat_pi,reg_dicnat_pi)

pre_dic_pi_clim=dim_avg_n_Wrap(pre_dic_pi,0)
pre_dicnat_pi_clim=dim_avg_n_Wrap(pre_dicnat_pi,0)
reg_dic_pi_clim=dim_avg_n_Wrap(reg_dic_pi,0)
reg_dicnat_pi_clim=dim_avg_n_Wrap(reg_dicnat_pi,0)

dim0=dimsizes(pre_dic_pi)

DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pre_dic_pi_clim))
DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(pre_dic_pi_clim))

REG_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pre_dic_pi_clim))
REG_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(pre_dic_pi_clim))

do i=0,450-1
 DIC_PI_CLIM(i,:)=pre_dic_pi_clim
 DICNAT_PI_CLIM(i,:)=pre_dicnat_pi_clim
 REG_DIC_PI_CLIM(i,:)=reg_dic_pi_clim
 REG_DICNAT_PI_CLIM(i,:)=reg_dicnat_pi_clim
end do
;----------------------------------------------------------------------------------
pre_dic_an_diff=pre_dic_an-DIC_PI_CLIM
pre_dicnat_an_diff=pre_dicnat_an-DICNAT_PI_CLIM
copy_VarCoords(pre_dic_an,pre_dic_an_diff)
copy_VarCoords(pre_dicnat_an,pre_dicnat_an_diff)

reg_dic_an_diff=reg_dic_an-REG_DIC_PI_CLIM
reg_dicnat_an_diff=reg_dicnat_an-REG_DICNAT_PI_CLIM
copy_VarCoords(reg_dic_an,reg_dic_an_diff)
copy_VarCoords(reg_dicnat_an,reg_dicnat_an_diff)

pre_dic_cdr_an_diff=pre_dic_cdr_an-DIC_PI_CLIM
pre_dicnat_cdr_an_diff=pre_dicnat_cdr_an-DICNAT_PI_CLIM
copy_VarCoords(pre_dic_an,pre_dic_cdr_an_diff)
copy_VarCoords(pre_dicnat_an,pre_dicnat_cdr_an_diff)

reg_dic_cdr_an_diff=reg_dic_cdr_an-REG_DIC_PI_CLIM
reg_dicnat_cdr_an_diff=reg_dicnat_cdr_an-REG_DICNAT_PI_CLIM
copy_VarCoords(reg_dic_an,reg_dic_cdr_an_diff)
copy_VarCoords(reg_dicnat_an,reg_dicnat_cdr_an_diff)

pre_dic_zec_an_diff=pre_dic_zec_an-DIC_PI_CLIM
pre_dicnat_zec_an_diff=pre_dicnat_zec_an-DICNAT_PI_CLIM
copy_VarCoords(pre_dic_an,pre_dic_zec_an_diff)
copy_VarCoords(pre_dicnat_an,pre_dicnat_zec_an_diff)

reg_dic_zec_an_diff=reg_dic_zec_an-REG_DIC_PI_CLIM
reg_dicnat_zec_an_diff=reg_dicnat_zec_an-REG_DICNAT_PI_CLIM
copy_VarCoords(reg_dic_an,reg_dic_zec_an_diff)
copy_VarCoords(reg_dicnat_an,reg_dicnat_zec_an_diff)
;----------------------------------------------------------------------------------
pre_dic_cdr_an_diff := pre_dic_cdr_an_diff(depth|:,year|:)
pre_dicnat_cdr_an_diff := pre_dicnat_cdr_an_diff(depth|:,year|:)
pre_dic_an_diff := pre_dic_an_diff(depth|:,year|:)
pre_dicnat_an_diff := pre_dicnat_an_diff(depth|:,year|:)
pre_dic_zec_an_diff := pre_dic_zec_an_diff(depth|:,year|:)
pre_dicnat_zec_an_diff := pre_dicnat_zec_an_diff(depth|:,year|:)

reg_dic_cdr_an_diff := reg_dic_cdr_an_diff(depth|:,year|:)
reg_dicnat_cdr_an_diff := reg_dicnat_cdr_an_diff(depth|:,year|:)
reg_dic_an_diff := reg_dic_an_diff(depth|:,year|:)
reg_dicnat_an_diff := reg_dicnat_an_diff(depth|:,year|:)
reg_dic_zec_an_diff := reg_dic_zec_an_diff(depth|:,year|:)
reg_dicnat_zec_an_diff := reg_dicnat_zec_an_diff(depth|:,year|:)
;----------------------------------------------------------------------------------
;printMinMax(dic_an_diff,0)
;printMinMax(dicnat_an_diff,0)

;printMinMax(dic_cdr_an_diff,0)
;printMinMax(dicnat_cdr_an_diff,0)

;printMinMax(dicant_an,0)
;printMinMax(dicant_cdr_an,0)
x=ispan(1,450,1)
;----------------------------------------------------------------------------------
plot=new(12,graphic)
wks=gsn_open_wks("png",dir2+"Hovmuller_pre_DICs_reg_DICs_flat10mip_${S}_mean_with_BOmasking")
res                       = True     ; plot mods desired
; Set resources for when we turn on labelbar later
res@gsnFrame               =       False
res@gsnDraw                =       False
res@lbLabelBarOn           = False
res@gsnMaximize          = False
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
res@cnMaxLevelValF         =     0.12
res@cnMinLevelValF         =     -0.12
res@cnLevelSpacingF        =      0.02

res@gsnCenterString="flat10"
plot(0)   = gsn_csm_contour(wks,pre_dic_an_diff, res)
res@gsnCenterString="flat10-zec"
res@tiYAxisString=""
plot(1)   = gsn_csm_contour(wks,pre_dic_zec_an_diff, res)
res@gsnCenterString="flat10-cdr"
res@lbLabelBarOn           = True
plot(2)   = gsn_csm_contour(wks,pre_dic_cdr_an_diff, res)
res@lbLabelBarOn           = False
res@gsnCenterString=""
res@tiYAxisString="Depth (m)"
plot(3)   = gsn_csm_contour(wks,reg_dic_an_diff, res)
res@tiYAxisString=""
plot(4)   = gsn_csm_contour(wks,reg_dic_zec_an_diff, res)
res@lbLabelBarOn           = True
plot(5)   = gsn_csm_contour(wks,reg_dic_cdr_an_diff, res)
res@tiYAxisString="Depth (m)"
res@lbLabelBarOn           = False
plot(6)   = gsn_csm_contour(wks,pre_dicnat_an_diff, res)
res@tiYAxisString=""
plot(7)   = gsn_csm_contour(wks,pre_dicnat_zec_an_diff, res)
res@lbLabelBarOn           = True
plot(8)   = gsn_csm_contour(wks,pre_dicnat_cdr_an_diff, res)
res@lbLabelBarOn           = False
res@tiXAxisString="Year"
res@tiYAxisString="Depth (m)"
plot(9)   = gsn_csm_contour(wks,reg_dicnat_an_diff, res)
res@tiYAxisString=""
plot(10)   = gsn_csm_contour(wks,reg_dicnat_zec_an_diff, res)
res@lbLabelBarOn           = True
plot(11)   = gsn_csm_contour(wks,reg_dicnat_cdr_an_diff, res)

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
gsn_text_ndc(wks,"DIC~B~pre~N~",0.02,0.77,txres1)
gsn_text_ndc(wks,"DIC~B~reg~N~",0.02,0.58,txres1)
gsn_text_ndc(wks,"DIC~B~nat|pre~N~",0.02,0.38,txres1)
gsn_text_ndc(wks,"DIC~B~nat|reg~N~",0.02,0.19,txres1)

gsn_panel(wks,plot,(/4,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
