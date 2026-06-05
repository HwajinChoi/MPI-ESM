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
f1=addfile(dir0+"dissic_flat10_r192x96_1850-2299_lon_${A}.nc","r")
tot_flt=f1->dissic(:,:,:,0) ; time x depth x lat
g1=addfile(dir0+"preformed_DIC_flat10_r192x96_1850-2299_lon_${A}.nc","r")
pre_flt=g1->preformed_DIC(:,:,:,0)
pre_flt=1000*pre_flt
reg_flt=tot_flt-pre_flt
copy_VarCoords(tot_flt,reg_flt)
k1=addfile(dir0+"preformed_PO4_flat10_r192x96_1850-2299_lon_${A}.nc","r")
pre_po4_flt=k1->preformed_PO4(:,:,:,0)
pre_po4_flt=pre_po4_flt*1000
h1=addfile(dir0+"po4_flat10_r192x96_1850-2299_lon_${A}.nc","r")
po4_flt_an=h1->po4(:,:,:,0)
po4_flt_an=po4_flt_an
;------------------------------------------------------
f2=addfile(dir0+"dissic_flat10_zec_r192x96_1850-2299_lon_${A}.nc","r")
tot_flt_zec=f2->dissic(:,:,:,0) ; time x depth x lat
g2=addfile(dir0+"preformed_DIC_flat10_zec_r192x96_1850-2299_lon_${A}.nc","r")
pre_flt_zec=g2->preformed_DIC(:,:,:,0)
pre_flt_zec=pre_flt_zec*1000
reg_flt_zec=tot_flt_zec-pre_flt_zec
copy_VarCoords(tot_flt_zec,reg_flt_zec)
k2=addfile(dir0+"preformed_PO4_flat10_zec_r192x96_1850-2299_lon_${A}.nc","r")
pre_po4_flt_zec=k2->preformed_PO4(:,:,:,0)
pre_po4_flt_zec=pre_po4_flt_zec*1000
h2=addfile(dir0+"po4_flat10_zec_r192x96_1850-2299_lon_${A}.nc","r")
po4_flt_zec_an=h2->po4(:,:,:,0)
po4_flt_zec_an=po4_flt_zec_an
;------------------------------------------------------
f3=addfile(dir0+"dissic_flat10_cdr_r192x96_1850-2299_lon_${A}.nc","r")
tot_flt_cdr=f3->dissic(:,:,:,0) ; time x depth x lat
g3=addfile(dir0+"preformed_DIC_flat10_cdr_r192x96_1850-2299_lon_${A}.nc","r")
pre_flt_cdr=g3->preformed_DIC(:,:,:,0)
pre_flt_cdr=pre_flt_cdr*1000
reg_flt_cdr=tot_flt_cdr-pre_flt_cdr
copy_VarCoords(tot_flt_cdr,reg_flt_cdr)
k3=addfile(dir0+"preformed_PO4_flat10_cdr_r192x96_1850-2299_lon_${A}.nc","r")
pre_po4_flt_cdr=k3->preformed_PO4(:,:,:,0)
pre_po4_flt_cdr=pre_po4_flt_cdr*1000
h3=addfile(dir0+"po4_flat10_cdr_r192x96_1850-2299_lon_${A}.nc","r")
po4_flt_cdr_an=h3->po4(:,:,:,0)
po4_flt_cdr_an=po4_flt_cdr_an
;------------------------------------------------------
flt_pre_po4_an=month_to_annual(pre_po4_flt,1)
flt_zec_pre_po4_an=month_to_annual(pre_po4_flt_zec,1)
flt_cdr_pre_po4_an=month_to_annual(pre_po4_flt_cdr,1)

flt_reg_an=month_to_annual(reg_flt,1)
flt_zec_reg_an=month_to_annual(reg_flt_zec,1)
flt_cdr_reg_an=month_to_annual(reg_flt_cdr,1)

flt_reg_om=(po4_flt_an-flt_pre_po4_an)*122
flt_zec_reg_om=(po4_flt_zec_an-flt_zec_pre_po4_an)*122
flt_cdr_reg_om=(po4_flt_cdr_an-flt_cdr_pre_po4_an)*122
copy_VarCoords(po4_flt_an,flt_reg_om)
copy_VarCoords(po4_flt_an,flt_zec_reg_om)
copy_VarCoords(po4_flt_an,flt_cdr_reg_om)

flt_caco3_an=flt_reg_an-flt_reg_om
copy_VarCoords(flt_reg_an,flt_caco3_an)

flt_zec_caco3_an=flt_zec_reg_an-flt_zec_reg_om
copy_VarCoords(flt_reg_an,flt_zec_caco3_an)

flt_cdr_caco3_an=flt_cdr_reg_an-flt_cdr_reg_om
copy_VarCoords(flt_reg_an,flt_cdr_caco3_an)
;------------------------------------------------------
dim=dimsizes(tot_flt)
First=new((/3,dim(1),dim(2)/),typeof(pre_po4_flt_cdr))
First(0,:,:)=dim_avg_n_Wrap(flt_reg_an(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(flt_reg_om(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(flt_caco3_an(0:29,:,:),0)
First!0="scenarios"

Middle=new((/3,dim(1),dim(2)/),typeof(pre_po4_flt_cdr))
Middle(0,:,:)=dim_avg_n_Wrap(flt_reg_an(135:164,:,:),0)
Middle(1,:,:)=dim_avg_n_Wrap(flt_reg_om(135:164,:,:),0)
Middle(2,:,:)=dim_avg_n_Wrap(flt_caco3_an(135:164,:,:),0)
Middle!0="scenarios"

Middle_First_flt=Middle-First
copy_VarCoords(Middle,Middle_First_flt)
First_flt_zec=new((/3,dim(1),dim(2)/),typeof(pre_po4_flt_cdr))
First_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_reg_an(0:29,:,:),0)
First_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_reg_om(0:29,:,:),0)
First_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_caco3_an(0:29,:,:),0)
First_flt_zec!0="scenarios"

Middle_flt_zec=new((/3,dim(1),dim(2)/),typeof(pre_po4_flt_cdr))
Middle_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_reg_an(135:164,:,:),0)
Middle_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_reg_om(135:164,:,:),0)
Middle_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_caco3_an(135:164,:,:),0)
Middle_flt_zec!0="scenarios"

First_flt_cdr=new((/3,dim(1),dim(2)/),typeof(pre_po4_flt_cdr))
First_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_reg_an(0:29,:,:),0)
First_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_reg_om(0:29,:,:),0)
First_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_caco3_an(0:29,:,:),0)
First_flt_cdr!0="scenarios"

Middle_flt_cdr=new((/3,dim(1),dim(2)/),typeof(pre_po4_flt_cdr))
Middle_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_reg_an(135:164,:,:),0)
Middle_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_reg_om(135:164,:,:),0)
Middle_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_caco3_an(135:164,:,:),0)
Middle_flt_cdr!0="scenarios"

Middle_First_flt_zec=Middle_flt_zec-First_flt_zec
copy_VarCoords(Middle_flt_zec,Middle_First_flt_zec)
Middle_First_flt_cdr=Middle_flt_cdr-First_flt_cdr
copy_VarCoords(Middle_flt_cdr,Middle_First_flt_cdr)

levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do

;------------------------------------------------------
plot=new(9,graphic)
plot2=new(9,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_vertical_flat10mip_Reg_prePO4_Caco3_${P}_Middle_First_ano_with_AMOC_for_450years" )          ; send graphics to PNG file
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

plot(0)  = gsn_csm_contour(wks, Middle_First_flt(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(3)  = gsn_csm_contour(wks, Middle_First_flt(1,:,:),res )   ; plaace holder
plot(6)  = gsn_csm_contour(wks, Middle_First_flt(2,:,:), res )   ; plaace holder
res@tiYAxisString=""
res@tmYLLabelsOn	= False
res@gsnCenterString="(b) flat10-zec"
plot(1)  = gsn_csm_contour(wks, Middle_First_flt_zec(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(4)  = gsn_csm_contour(wks, Middle_First_flt_zec(1,:,:), res )   ; plaace holder
plot(7)  = gsn_csm_contour(wks, Middle_First_flt_zec(2,:,:), res )   ; plaace holder
res@gsnCenterString="(c) flat10-cdr"
plot(2)  = gsn_csm_contour(wks, Middle_First_flt_cdr(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(5)  = gsn_csm_contour(wks, Middle_First_flt_cdr(1,:,:), res )   ; plaace holder
plot(8)  = gsn_csm_contour(wks, Middle_First_flt_cdr(2,:,:), res )   ; plaace holder

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

txres1               = True
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"DIC~B~reg~N~",0.05,0.73,txres1)
gsn_text_ndc(wks,"DIC~B~reg_soft~N~",0.05,0.50,txres1)
gsn_text_ndc(wks,"DIC~B~reg_carb~N~",0.05,0.26,txres1)
txres1@txFontHeightF = 0.014

gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.92,0.13,txres1)

gsn_panel(wks,plot,(/3,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
