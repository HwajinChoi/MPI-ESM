#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data/advection/new
dir2=/data/hjchoi/CMI/OBA/image
dir3=/data/hjchoi/CMI/data/corr
dir4=/data/hjchoi/CMI/OBA/data

for v in "O" "T" ;do

cat << EOF > ./imsi.ncl
begin
latMax=20
latMin=-20
lonMin=150
lonMax=270
aaa=addfile("${dir3}/MI-Temp_corr_diff_for_area_line.nc","r")
diff1=aaa->diff1(1,{latMin:latMax},{lonMin:lonMax})

bbb=addfile("${dir1}/raw/ECDA-COBALT_dT_dz_3213.20581054688m_advection_199001-201712.nc","r")
yt_ocean=bbb->yt_ocean
xt_ocean=bbb->xt_ocean

g=addfile("${dir1}/ECDA-COBALT_d${v}_dx_100-300m_advection_199001-201712.nc","r")
u_bar_${v}_prime=g->u_bar_${v}_prime
u_prime_${v}_bar=g->u_prime_${v}_bar

h=addfile("${dir1}/ECDA-COBALT_d${v}_dy_100-300m_advection_199001-201712.nc","r")
v_bar_${v}_prime=h->v_bar_${v}_prime
v_prime_${v}_bar=h->v_prime_${v}_bar

k=addfile("${dir1}/ECDA-COBALT_d${v}_dz_100-300m_advection_199001-201712.nc","r")
w_bar_${v}_prime=k->w_bar_${v}_prime
w_prime_${v}_bar=k->w_prime_${v}_bar

m=addfile("${dir1}/ECDA-COBALT_d${v}_dt_100-300m_advection_199001-201712.nc","r")
${v}t_prime=m->${v}t_prime ; time*yt_ocean*xt_ocean

dim1=dimsizes(u_bar_${v}_prime)

${v}_seperated=new((/7,dim1(0),dim1(1),dim1(2)/),"float")
${v}_seperated(0,:,:,:)=u_bar_${v}_prime
${v}_seperated(1,:,:,:)=u_prime_${v}_bar
${v}_seperated(2,:,:,:)=v_bar_${v}_prime
${v}_seperated(3,:,:,:)=v_prime_${v}_bar
${v}_seperated(4,:,:,:)=w_bar_${v}_prime
${v}_seperated(5,:,:,:)=w_prime_${v}_bar
${v}_seperated(6,:,:,:)=${v}t_prime
copy_VarCoords(u_bar_${v}_prime,${v}_seperated(0,:,:,:))
${v}_seperated!0="variables"
${v}_seperated=${v}_seperated*60*60*24*30
${v}_seperated := ${v}_seperated(time|:,variables|:,yt_ocean|:,xt_ocean|:)
${v}_seperated2 = month_to_annual(${v}_seperated,1)
${v}_seperated2 := ${v}_seperated2(variables|:,year|:,yt_ocean|:,xt_ocean|:)

dim2=dimsizes(${v}_seperated2)
${v}_test=new((/dim2(0)-1,dim2(1),dim2(2),dim2(3)/),"float")
${v}_test=${v}_seperated2(0:dim2(0)-2,:,:,:)
${v}_test2=dim_sum_n_Wrap(${v}_test,0); Sum
${v}_bio=${v}_seperated2(6,:,:,:)-${v}_test2; year*yt_ocean*xt_ocean
copy_VarCoords(${v}_seperated2(0,:,:,:),${v}_bio)
;--------------------------------------------------------------------------
g1=addfile("${dir1}/LT_1_d${v}_dx_100-300m_advection_199101-201712.nc","r")
u_bar_${v}_prime1=g1->u_bar_${v}_prime
u_prime_${v}_bar1=g1->u_prime_${v}_bar

h1=addfile("${dir1}/LT_1_d${v}_dy_100-300m_advection_199101-201712.nc","r")
v_bar_${v}_prime1=h1->v_bar_${v}_prime
v_prime_${v}_bar1=h1->v_prime_${v}_bar

k1=addfile("${dir1}/LT_1_d${v}_dz_100-300m_advection_199101-201712.nc","r")
w_bar_${v}_prime1=k1->w_bar_${v}_prime
w_prime_${v}_bar1=k1->w_prime_${v}_bar

m1=addfile("${dir1}/LT_1_d${v}_dt_100-300m_advection_199101-201712.nc","r")
${v}t_prime1=m1->${v}t_prime
${v}t_prime1!0="time"

dim1_LT1=dimsizes(u_bar_${v}_prime1)
${v}_seperated_LT1=new((/7,dim1_LT1(0),dim1_LT1(1),dim1_LT1(2)/),"float")
${v}_seperated_LT1(0,:,:,:)=u_bar_${v}_prime1
${v}_seperated_LT1(1,:,:,:)=u_prime_${v}_bar1
${v}_seperated_LT1(2,:,:,:)=v_bar_${v}_prime1
${v}_seperated_LT1(3,:,:,:)=v_prime_${v}_bar1
${v}_seperated_LT1(4,:,:,:)=w_bar_${v}_prime1
${v}_seperated_LT1(5,:,:,:)=w_prime_${v}_bar1
${v}_seperated_LT1(6,:,:,:)=${v}t_prime1
copy_VarCoords(u_bar_${v}_prime1,${v}_seperated_LT1(0,:,:,:))
${v}_seperated_LT1!0="variables"
${v}_seperated_LT1=${v}_seperated_LT1*60*60*24*30
${v}_seperated_LT1 := ${v}_seperated_LT1(time|:,variables|:,yt_ocean|:,xt_ocean|:)
${v}_seperated2_LT1=month_to_annual(${v}_seperated_LT1,1)
${v}_seperated2_LT1 := ${v}_seperated2_LT1(variables|:,year|:,yt_ocean|:,xt_ocean|:)

dim2_LT1=dimsizes(${v}_seperated2_LT1)
${v}_test_LT1=new((/dim2_LT1(0)-1,dim2_LT1(1),dim2_LT1(2),dim2_LT1(3)/),"float")
${v}_test_LT1=${v}_seperated2_LT1(0:dim2_LT1(0)-2,:,:,:)
${v}_test2_LT1=dim_sum_n_Wrap(${v}_test_LT1,0); Sum
${v}_bio_LT1=${v}_seperated2_LT1(6,:,:,:)-${v}_test2_LT1
copy_VarCoords(${v}_seperated2_LT1(0,:,:,:),${v}_bio_LT1)
;--------------------------------------------------------------------------
g2=addfile("${dir1}/LT_2_d${v}_dx_100-300m_advection_199201-201712.nc","r")
u_bar_${v}_prime2=g2->u_bar_${v}_prime
u_prime_${v}_bar2=g2->u_prime_${v}_bar

h2=addfile("${dir1}/LT_2_d${v}_dy_100-300m_advection_199201-201712.nc","r")
v_bar_${v}_prime2=h2->v_bar_${v}_prime
v_prime_${v}_bar2=h2->v_prime_${v}_bar

k2=addfile("${dir1}/LT_2_d${v}_dz_100-300m_advection_199201-201712.nc","r")
w_bar_${v}_prime2=k2->w_bar_${v}_prime
w_prime_${v}_bar2=k2->w_prime_${v}_bar

m2=addfile("${dir1}/LT_2_d${v}_dt_100-300m_advection_199201-201712.nc","r")
${v}t_prime2=m2->${v}t_prime
${v}t_prime2!0="time"

dim1_LT2=dimsizes(u_bar_${v}_prime2)
${v}_seperated_LT2=new((/7,dim1_LT2(0),dim1_LT2(1),dim1_LT2(2)/),"float")
${v}_seperated_LT2(0,:,:,:)=u_bar_${v}_prime2
${v}_seperated_LT2(1,:,:,:)=u_prime_${v}_bar2
${v}_seperated_LT2(2,:,:,:)=v_bar_${v}_prime2
${v}_seperated_LT2(3,:,:,:)=v_prime_${v}_bar2
${v}_seperated_LT2(4,:,:,:)=w_bar_${v}_prime2
${v}_seperated_LT2(5,:,:,:)=w_prime_${v}_bar2
${v}_seperated_LT2(6,:,:,:)=${v}t_prime2
copy_VarCoords(u_bar_${v}_prime2,${v}_seperated_LT2(0,:,:,:))
${v}_seperated_LT2!0="variables"
${v}_seperated_LT2=${v}_seperated_LT2*60*60*24*30
${v}_seperated_LT2 := ${v}_seperated_LT2(time|:,variables|:,yt_ocean|:,xt_ocean|:)
${v}_seperated2_LT2=month_to_annual(${v}_seperated_LT2,1)
${v}_seperated2_LT2 := ${v}_seperated2_LT2(variables|:,year|:,yt_ocean|:,xt_ocean|:)

dim2_LT2=dimsizes(${v}_seperated2_LT2)
${v}_test_LT2=new((/dim2_LT2(0)-1,dim2_LT2(1),dim2_LT2(2),dim2_LT2(3)/),"float")
${v}_test_LT2=${v}_seperated2_LT2(0:dim2_LT2(0)-2,:,:,:)
${v}_test2_LT2=dim_sum_n_Wrap(${v}_test_LT2,0); Sum
${v}_bio_LT2=${v}_seperated2_LT2(6,:,:,:)-${v}_test2_LT2
copy_VarCoords(${v}_seperated2_LT2(0,:,:,:),${v}_bio_LT2)
;--------------------------------------------------------------------------
${v}_seperated2 := ${v}_seperated2(variables|:,yt_ocean|:,xt_ocean|:,year|:)
${v}_seperated2_LT1 := ${v}_seperated2_LT1(variables|:,yt_ocean|:,xt_ocean|:,year|:)
${v}_seperated2_LT2 := ${v}_seperated2_LT2(variables|:,yt_ocean|:,xt_ocean|:,year|:)

corr_lead1=escorc(${v}_seperated2(:,:,:,1:27),${v}_seperated2_LT1(:,:,:,:)); variables*yt_ocean*xt_ocean
corr_lead2=escorc(${v}_seperated2(:,:,:,2:27),${v}_seperated2_LT2(:,:,:,:))
copy_VarCoords(${v}_seperated2(:,:,:,0),corr_lead1)
copy_VarCoords(${v}_seperated2(:,:,:,0),corr_lead2)

${v}_bio := ${v}_bio(yt_ocean|:,xt_ocean|:,year|:)
${v}_bio_LT1 := ${v}_bio_LT1(yt_ocean|:,xt_ocean|:,year|:)
${v}_bio_LT2 := ${v}_bio_LT2(yt_ocean|:,xt_ocean|:,year|:)

corr_bio_lead1=escorc(${v}_bio(:,:,1:27),${v}_bio_LT1)
corr_bio_lead2=escorc(${v}_bio(:,:,2:27),${v}_bio_LT2)
copy_VarCoords(${v}_bio(:,:,0),corr_bio_lead1)
copy_VarCoords(${v}_bio(:,:,0),corr_bio_lead2)

CORR_LEAD1=new((/8,180,360/),"float")
CORR_LEAD1(0:6,:,:)=corr_lead1
CORR_LEAD1(7,:,:)=corr_bio_lead1

CORR_LEAD2=new((/8,180,360/),"float")
CORR_LEAD2(0:6,:,:)=corr_lead2
CORR_LEAD2(7,:,:)=corr_bio_lead2

CORR_LEAD1&yt_ocean=yt_ocean
CORR_LEAD2&yt_ocean=yt_ocean

CORR_LEAD1&xt_ocean=xt_ocean
CORR_LEAD2&xt_ocean=xt_ocean

system("rm -f ${dir4}/CORR_map_spilt_${v}_advections_COBALT_LEADs.nc")
out=addfile( "${dir4}/CORR_map_spilt_${v}_advections_COBALT_LEADs.nc","c")
out->CORR_LEAD1=CORR_LEAD1
out->CORR_LEAD2=CORR_LEAD2
out->yt_ocean=yt_ocean
out->xt_ocean=xt_ocean
exit

var_name=new(8,"string")
var_name(0:1)=":F21:-:F21:u:H6::V10::F18:s:F21:O:B:2:N::H-40::V-1::F21:__:H-35::V-30::F18:s:F10:x"
var_name(2:3)=":F21:-:F21:v:H6::V10::F18:s:F21:O:B:2:N::H-40::V-1::F21:__:H-35::V-30::F18:s:F10:y"
var_name(4:5)=":F21:-:F21:w:H6::V10::F18:s:F21:O:B:2:N::H-40::V-1::F21:__:H-35::V-30::F18:s:F10:z"
var_name(6)=":H6::V10::F18:s:F21:O:B:2:N::H-40::V-1::F21:__:H-35::V-30::F18:s:F10:t"
var_name(7)="Residual"

do n = 0,3
plot=new(4,graphic)
plot1=new(4,graphic)
wks=gsn_open_wks("x11","${dir2}/Map_${v}_budget_advections_COBALT_lead_correlation_"+n)
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
pres@gsnPanelMainString     = "Corr_map_${v}_budget_COBALT_LTs_"+n

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

done

