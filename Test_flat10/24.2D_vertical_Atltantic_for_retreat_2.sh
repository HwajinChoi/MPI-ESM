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
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------------------------------------------------------
f1=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_${A}.nc","r")
tot_flt=f1->dissic(:,:,:,0) ; time x depth x lat
g1=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_${A}.nc","r")
nat_flt=g1->dissicnat(:,:,:,0)
h1=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_${A}.nc","r")
ant_flt=h1->dissic(:,:,:,0)
;------------------------------------------------------
f2=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_${A}.nc","r")
tot_flt_zec=f2->dissic(:,:,:,0) ; time x depth x lat
g2=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_${A}.nc","r")
nat_flt_zec=g2->dissicnat(:,:,:,0)
h2=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_${A}.nc","r")
ant_flt_zec=h2->dissic(:,:,:,0)
;------------------------------------------------------
f3=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissic_18500101_21491231_lon_${A}.nc","r")
tot_flt_cdr=f3->dissic(:,:,:,0) ; time x depth x lat
g3=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissicnat_18500101_21491231_lon_${A}.nc","r")
nat_flt_cdr=g3->dissicnat(:,:,:,0)
h3=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissicant_18500101_21491231_lon_${A}.nc","r")
ant_flt_cdr=h3->dissic(:,:,:,0)
;------------------------------------------------------
flt_tot_an=month_to_annual(tot_flt,1)
flt_nat_an=month_to_annual(nat_flt,1)
flt_ant_an=month_to_annual(ant_flt,1)
;------------------------------------------------------
flt_zec_tot_an=month_to_annual(tot_flt_zec,1)
flt_zec_nat_an=month_to_annual(nat_flt_zec,1)
flt_zec_ant_an=month_to_annual(ant_flt_zec,1)
;------------------------------------------------------
flt_cdr_tot_an=month_to_annual(tot_flt_cdr,1)
flt_cdr_nat_an=month_to_annual(nat_flt_cdr,1)
flt_cdr_ant_an=month_to_annual(ant_flt_cdr,1)
;------------------------------------------------------
dim=dimsizes(tot_flt)
First=new((/3,dim(1),dim(2)/),typeof(flt_tot_an))
First(0,:,:)=dim_avg_n_Wrap(flt_tot_an(0:29,:,:),0)
First(1,:,:)=dim_avg_n_Wrap(flt_nat_an(0:29,:,:),0)
First(2,:,:)=dim_avg_n_Wrap(flt_ant_an(0:29,:,:),0)
First!0="scenarios"

Last=new((/3,dim(1),dim(2)/),typeof(flt_tot_an))
Last(0,:,:)=dim_avg_n_Wrap(flt_tot_an(270:299,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(flt_nat_an(270:299,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(flt_ant_an(270:299,:,:),0)
Last!0="scenarios"

Last_First_flt=Last-First
copy_VarCoords(Last,Last_First_flt)
First_flt_zec=new((/3,dim(1),dim(2)/),typeof(flt_zec_tot_an))
First_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_tot_an(0:29,:,:),0)
First_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_nat_an(0:29,:,:),0)
First_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_ant_an(0:29,:,:),0)
First_flt_zec!0="scenarios"

Last_flt_zec=new((/3,dim(1),dim(2)/),typeof(flt_zec_tot_an))
Last_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_tot_an(270:299,:,:),0)
Last_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_nat_an(270:299,:,:),0)
Last_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_ant_an(270:299,:,:),0)
Last_flt_zec!0="scenarios"

First_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot_an))
First_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(0:29,:,:),0)
First_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(0:29,:,:),0)
First_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(0:29,:,:),0)
First_flt_cdr!0="scenarios"

Last_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot_an))
Last_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(270:299,:,:),0)
Last_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(270:299,:,:),0)
Last_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(270:299,:,:),0)
Last_flt_cdr!0="scenarios"
;------------------------------------------------------
Middle_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot_an))
Middle_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(135:164,:,:),0)
Middle_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(135:164,:,:),0)
Middle_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(135:164,:,:),0)
Middle_flt_cdr!0="scenarios"

Last_First_flt_zec=Last_flt_zec-First_flt_zec
copy_VarCoords(Last_flt_zec,Last_First_flt_zec)
Last_First_flt_cdr=Last_flt_cdr-First_flt_cdr
copy_VarCoords(Last_flt_cdr,Last_First_flt_cdr)

Middle_First_flt_cdr=Middle_flt_cdr-First_flt_cdr
Last_Middle_flt_cdr=Last_flt_cdr-Middle_flt_cdr
copy_VarCoords(Last_flt_cdr,Middle_First_flt_cdr)
copy_VarCoords(Last_flt_cdr,Last_Middle_flt_cdr)

levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do
;------------------------------------------------------
u=addfile(dir0+"AMOC_simulations_First_Last_diff_300years.nc","r")
cdr_diff_amoc=u->flat10_cdr(2,:,:)
zec_diff_amoc=u->flat10_zec(2,:,:)
diff_amoc=u->flat10(2,:,:)
lat=u->lat
dep=u->depth_2

u2=addfile(dir0+"AMOC_simulations_CDR_First_Middle_Last_diff_300years.nc","r")
CDR_moc=u2->CDR_moc
Middle_First_cdr_moc=CDR_moc(0,:,:)
Last_Middle_cdr_moc=CDR_moc(1,:,:)

;------------------------------------------------------
plot=new(3,graphic)
plot2=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"RETREAT_LAST_FIRST_2D_vertical_flat10mip_DICs_${P}" )          ; send graphics to PNG file
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
res@gsnCenterStringFontHeightF= 0.05
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
res@cnMaxLevelValF         =     0.20
res@cnMinLevelValF         =     -0.20
res@cnLevelSpacingF        =      0.020
res@gsnCenterString="(a) DIC~B~tot~N~"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
;-----------------------------------------------
;Last_Middle_flt_cdr, Last_First_flt_cdr
;-----------------------------------------------
plot(0)  = gsn_csm_contour(wks, Last_First_flt_cdr(0,:,:), res )   ; plaace holder
res@gsnCenterString="(b) DIC~B~nat~N~"
res@tiYAxisString=""
res@tmYLLabelsOn	= False
plot(1)  = gsn_csm_contour(wks, Last_First_flt_cdr(1,:,:),res )   ; plaace holder
res@gsnCenterString="(c) DIC~B~ant~N~"
plot(2)  = gsn_csm_contour(wks, Last_First_flt_cdr(2,:,:), res )   ; plaace holder
res@gsnCenterString=""

;-----------------------------------------------
;Last_Middle_cdr_moc, Last_First_cdr_moc
;-----------------------------------------------
plot2(0)= gsn_csm_contour(wks, cdr_diff_amoc, res1 )
plot2(1)= gsn_csm_contour(wks, cdr_diff_amoc, res1 )
plot2(2)= gsn_csm_contour(wks, cdr_diff_amoc, res1 )

do i=0,2
overlay(plot(i),plot2(i))
end do

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 0
pres@gsnPanelMainFontHeightF=0.02
pres@lbLabelFontHeightF  = 0.013
pres@lbLabelStride     =   4
pres@gsnPanelMainString="${P}"
pres@gsnPanelLeft=0.10
pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

gsn_panel(wks,plot,(/1,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
