#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data/advection/new
dir2=/data/hjchoi/CMI/OBA/image
dir3=/data/hjchoi/CMI/data/corr
dir4=/data/hjchoi/CMI/OBA/data

cat << EOF > ./imsi.ncl
begin
latMax=20
latMin=-20
lonMin=150
lonMax=270
aaa=addfile("${dir3}/MI-Temp_corr_diff_for_area_line.nc","r")
diff1=aaa->diff1(1,{latMin:latMax},{lonMin:lonMax})

g=addfile("${dir4}/CORR_map_spilt_O_advections_COBALT_LEADs.nc","r")
CORR_LEAD1_o=g->CORR_LEAD1
CORR_LEAD2_o=g->CORR_LEAD2
yt_ocean=g->yt_ocean
xt_ocean=g->xt_ocean

h=addfile("${dir4}/CORR_map_spilt_T_advections_COBALT_LEADs.nc","r")
CORR_LEAD1_t=h->CORR_LEAD1
CORR_LEAD2_t=h->CORR_LEAD2

CORR_LEAD1=CORR_LEAD1_o-CORR_LEAD1_t
CORR_LEAD2=CORR_LEAD2_o-CORR_LEAD2_t
copy_VarCoords(CORR_LEAD1_o,CORR_LEAD1)
copy_VarCoords(CORR_LEAD2_o,CORR_LEAD2)
CORR_LEAD1&yt_ocean=yt_ocean
CORR_LEAD1&xt_ocean=xt_ocean
CORR_LEAD2&yt_ocean=yt_ocean
CORR_LEAD2&xt_ocean=xt_ocean

var_name=new(8,"string")
var_name(0:1)=":F21:-:F21:u:H6::V10::F18:s:F21:C:H-40::V-1::F21:__:H-35::V-30::F18:s:F10:x"
var_name(2:3)=":F21:-:F21:v:H6::V10::F18:s:F21:C:H-40::V-1::F21:__:H-35::V-30::F18:s:F10:y"
var_name(4:5)=":F21:-:F21:w:H6::V10::F18:s:F21:C:H-40::V-1::F21:__:H-35::V-30::F18:s:F10:z"
var_name(6)=":H6::V10::F18:s:F21:C:H-40::V-1::F21:__:H-35::V-30::F18:s:F10:t"
var_name(7)="Residual"

do n = 0,3
plot=new(4,graphic)
plot1=new(4,graphic)
wks=gsn_open_wks("png","${dir2}/DIFF_O-T_Map_budget_advections_COBALT_lead_correlation_"+n)
res                        =   True
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnFillOn               =       True
res@cnInfoLabelOn          =   False
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
res@mpCenterLonF       =       180
res@mpLandFillColor    =   "white"
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     1.0 
res@cnMinLevelValF         =      -1.0
;res@cnMaxLevelValF         =     0.1 
;res@cnMinLevelValF         =      -0.5
res@cnLevelSpacingF        =      0.1
res@cnFillPalette          =       "temp_19lev"
;res@cnFillPalette          =       "matlab_jet"
res@gsnRightString        =   ""
res@gsnLeftString        =   ""
res@gsnCenterString        =   "LT=1"
plot(0)=gsn_csm_contour_map(wks,CORR_LEAD1(2*n,:,:),res)
res@gsnCenterString        =   "LT=2"
plot(1)=gsn_csm_contour_map(wks,CORR_LEAD2(2*n,:,:),res)
res@gsnCenterString        =   ""
plot(2)=gsn_csm_contour_map(wks,CORR_LEAD1(2*n+1,:,:),res)
plot(3)=gsn_csm_contour_map(wks,CORR_LEAD2(2*n+1,:,:),res)
;------------for masking area outlines-----------------------------
resw                    = True               ; plot mods desired
resw@gsnDraw        = False
resw@gsnFrame       = False
resw@cnFillOn               = False
resw@cnInfoLabelOn          = False
resw@cnLineLabelsOn         = False
resw@cnLevelSelectionMode   = "ExplicitLevels"     ; manual contour levels
resw@cnLineThicknessF       = 4.0 
resw@cnLineLabelInterval  = 1.0 
resw@cnLineDashSegLenF  = 0.18
resw@gsnLeftString=""
resw@gsnRightString=""
resw@cnLineColor    =   "green"
;resw@cnLineDashPattern  =   0
resw@cnMonoLineDashPattern=1
resw@cnLevels       =  0.25 

do j=0,3
plot1(j)=gsn_csm_contour(wks,diff1,resw); e0=0.7m, 100-300m
overlay(plot(j),plot1(j))
end do
;------------For equator area outlines-------------------------------------------------------
ypts=(/-20,-20, 20,20,-20/)
xpts=(/150,270,270,150,150/)
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "grey20"                     ; color of lines
resp@gsLineThicknessF = 3.0                       ; thickness of lines
resp@gsLineDashPattern= 0
resp@tfPolyDrawOrder   =   "PostDraw"
dum1 = new(7,graphic)
do j = 0 ,3
 dum1(j)=gsn_add_polyline(wks,plot(j),xpts,ypts,resp)
end do
;----------------------------------------------------------------------------------
pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 5
pres@lbLabelFontHeightF  = 0.010
pres@lbLabelStride     =   2
pres@gsnPanelTop       = 0.9
pres@gsnPanelBottom       = 0.05
pres@gsnPanelLeft     = 0.10
pres@gsnPanelMainString     = "Diff_Corr_Oxygen-Temp"

gsn_panel(wks,plot,(/2,2/),pres)

txres               = True                      ; text mods desired
txres@txJust        = "CenterLeft"
txres@txFuncCode    = ":"
txres@txFontHeightF = 0.02

if ( n .eq. 3) then
txres@txFontHeightF = 0.015
    gsn_text_ndc(wks,var_name(2*n),0.026,0.65,txres)
    gsn_text_ndc(wks,var_name(2*n+1),0.016,0.35,txres)
    gsn_text_ndc(wks,":F18:'",0.06,.67,txres)
  else
    gsn_text_ndc(wks,var_name(2*n),0.016,0.65,txres)
    gsn_text_ndc(wks,var_name(2*n+1),0.016,0.35,txres)
    gsn_text_ndc(wks,":F18:-",0.019,.665,txres)
    gsn_text_ndc(wks,":F18:-",0.065,.38,txres)
    gsn_text_ndc(wks,":F18:'",0.083,.675,txres)
    gsn_text_ndc(wks,":F18:'",0.035,.365,txres)
end if
frame(wks)
end do

end
EOF

ncl ./imsi.ncl
rm -f ./imsi.ncl
