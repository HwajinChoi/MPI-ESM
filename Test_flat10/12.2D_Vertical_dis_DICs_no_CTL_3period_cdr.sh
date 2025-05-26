#!/bin/bash

for S in "flat10_cdr" ; do
C=2149
D=$(($C-1850))
 for P in "Atlantic" "Pacific" "Indian" ;do

 if [ $P = "Atlantic" ];then
  A=340
 elif [ $P = "Pacific" ];then
  A=190
 else
  A=70
 fi

cat <<EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------------------------------------------------------
f=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissic_18500101_${C}1231_lon_${A}.nc","r")
tot_flt=f->dissic(:,:,:,0) ; time x depth x lat
g=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicnat_18500101_${C}1231_lon_${A}.nc","r")
nat_flt=g->dissicnat(:,:,:,0)
h=addfile(dir0+"test_${S}_001_cfcs_ideal_r192x96_dissicant_18500101_${C}1231_lon_${A}.nc","r")
ant_flt=h->dissic(:,:,:,0)
;------------------------------------------------------
flt_tot_an=month_to_annual(tot_flt,1)
flt_nat_an=month_to_annual(nat_flt,1)
flt_ant_an=month_to_annual(ant_flt,1)
;------------------------------------------------------
dim=dimsizes(tot_flt)
First=new((/3,dim(1),dim(2)/),typeof(flt_tot_an))
First(0,:,:)=dim_avg_n_Wrap(flt_tot_an(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(flt_nat_an(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(flt_ant_an(0:29,:,:),0)
First!0="scenarios"

Middle=new((/3,dim(1),dim(2)/),typeof(flt_tot_an))
Middle(0,:,:)=dim_avg_n_Wrap(flt_tot_an(135:164,:,:),0)
Middle(1,:,:)=dim_avg_n_Wrap(flt_nat_an(135:164,:,:),0)
Middle(2,:,:)=dim_avg_n_Wrap(flt_ant_an(135:164,:,:),0)
Middle!0="scenarios"

Last=new((/3,dim(1),dim(2)/),typeof(flt_tot_an))
Last(0,:,:)=dim_avg_n_Wrap(flt_tot_an(270:$D,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(flt_nat_an(270:$D,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(flt_ant_an(270:$D,:,:),0)
Last!0="scenarios"

Last_First=Last-First
Last_Middle=Last-Middle
Middle_First=Middle-First
copy_VarCoords(Last,Last_First)
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)

levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do
;------------------------------------------------------
plot=new(9,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_vertical_${S}_DICs_${P}_3periods_ano" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     0.25
res@cnMinLevelValF         =     -0.25
res@cnLevelSpacingF        =      0.025
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "temp_diff_18lev"
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@tmYLLabels =(..)
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@gsnCenterStringFontHeightF= 0.040
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.03
res@tmYLLabelFontHeightF=0.03
res@tiYAxisFontHeightF=0.03

res@gsnCenterString="(a) Middle - First"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
plot(0)  = gsn_csm_contour(wks, Middle_First(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(3)  = gsn_csm_contour(wks, Middle_First(1,:,:), res )   ; plaace holder
plot(6)  = gsn_csm_contour(wks, Middle_First(2,:,:), res )   ; plaace holder
res@tiYAxisString=""
res@tmYLLabelsOn	= False
res@gsnCenterString="(b) Last - First"
plot(1)  = gsn_csm_contour(wks, Last_First(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(4)  = gsn_csm_contour(wks, Last_First(1,:,:), res )   ; plaace holder
plot(7)  = gsn_csm_contour(wks, Last_First(2,:,:), res )   ; plaace holder
res@gsnCenterString="(c) Last - Middle"
plot(2)  = gsn_csm_contour(wks, Last_Middle(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(5)  = gsn_csm_contour(wks, Last_Middle(1,:,:), res )   ; plaace holder
plot(8)  = gsn_csm_contour(wks, Last_Middle(2,:,:), res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelMainFontHeightF=0.02
pres@lbLabelFontHeightF  = 0.013
pres@lbLabelStride     =   4
pres@gsnPanelMainString="${S} anomaly (${P})"
pres@gsnPanelLeft=0.1
pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"DIC~B~tot~N~",0.05,0.73,txres1)
gsn_text_ndc(wks,"DIC~B~nat~N~",0.05,0.50,txres1)
gsn_text_ndc(wks,"DIC~B~ant~N~",0.05,0.26,txres1)
txres1@txFontHeightF = 0.014

gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.92,0.13,txres1)

gsn_panel(wks,plot,(/3,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
 done
done
