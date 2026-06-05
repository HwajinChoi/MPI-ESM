#!/bin/bash

for P in "Atlantic" ;do

 if [ $P = "Atlantic" ];then
  A=340
 elif [ $P = "Pacific" ];then
  A=190
 else
  A=70
 fi

cat <<EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------------------------------------------------------
g1=addfile(dir0+"preformed_PO4_flat10_r192x96_1850-2299_lon_${A}.nc","r")
pre_flt=g1->preformed_PO4(:,:,:,0)
pre_flt=1000*pre_flt*122
;------------------------------------------------------
g2=addfile(dir0+"preformed_PO4_flat10_zec_r192x96_1850-2299_lon_${A}.nc","r")
pre_flt_zec=g2->preformed_PO4(:,:,:,0)
pre_flt_zec=1000*pre_flt_zec*122
;------------------------------------------------------
g3=addfile(dir0+"preformed_PO4_flat10_cdr_r192x96_1850-2299_lon_${A}.nc","r")
pre_flt_cdr=g3->preformed_PO4(:,:,:,0)
pre_flt_cdr=pre_flt_cdr*1000*122
;------------------------------------------------------
flt_pre_an=month_to_annual(pre_flt,1)
flt_zec_pre_an=month_to_annual(pre_flt_zec,1)
flt_cdr_pre_an=month_to_annual(pre_flt_cdr,1)
;------------------------------------------------------
dim=dimsizes(pre_flt)
First=new((/3,dim(1),dim(2)/),typeof(pre_flt))
First(0,:,:)=dim_avg_n_Wrap(flt_pre_an(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(flt_zec_pre_an(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(flt_cdr_pre_an(0:29,:,:),0)
First!0="scenarios"

Last=new((/3,dim(1),dim(2)/),typeof(pre_flt))
Last(0,:,:)=dim_avg_n_Wrap(flt_pre_an(420:449,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(flt_zec_pre_an(420:449,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(flt_cdr_pre_an(420:449,:,:),0)
Last!0="scenarios"

Last_First_flt=Last-First
copy_VarCoords(Last,Last_First_flt)

levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_vertical_flat10mip_prePO4_${P}_Last2_First_ano_with_AMOC_for_450years" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLevelSelectionMode   =       "ManualLevels"
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@gsnDraw                =       False
res@gsnFrame               =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res1=res
res@gsnCenterStringFontHeightF= 0.043
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.03
res@tmYLLabelFontHeightF=0.03
res@tiYAxisFontHeightF=0.03

res1@cnLineLabelsOn       = True
res1@gsnContourZeroLineThicknessF = 2. 	; doubles thickness of zero contour
res1@gsnContourNegLineDashPattern = 1 	; sets negative contours to dash pattern 1
res1@cnMaxLevelValF         =     4
res1@cnMinLevelValF         =     -4
res1@cnLevelSpacingF        =      1.0
res1@cnInfoLabelOn          =   False
res1@gsnLeftString=""
res1@gsnRightString=""
res1@gsnCenterString=""
res1@cnLineLabelsOn         =       False

res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@cnMaxLevelValF         =     0.25
res@cnMinLevelValF         =     -0.25
res@cnLevelSpacingF        =      0.025
res@gsnCenterString="(a) flat10"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"

plot(0)  = gsn_csm_contour(wks, Last_First_flt(0,:,:), res )   ; plaace holder
res@tiYAxisString=""
res@gsnCenterString="(b) flat10-zec"
plot(1)  = gsn_csm_contour(wks, Last_First_flt(1,:,:),res )   ; plaace holder
res@gsnCenterString="(c) flat10-cdr"
plot(2)  = gsn_csm_contour(wks, Last_First_flt(2,:,:), res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelMainFontHeightF=0.02
pres@lbLabelFontHeightF  = 0.013
pres@lbLabelStride     =   4
pres@gsnPanelMainString="${P}"
pres@gsnPanelLeft=0.1
pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

;gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.92,0.13,txres1)

gsn_panel(wks,plot,(/1,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
