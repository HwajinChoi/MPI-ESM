#!/bin/bash

for P in "Pacific" ;do

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
depth=f1->depth
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
First!0="components"

Last=new((/3,dim(1),dim(2)/),typeof(flt_tot_an))
Last(0,:,:)=dim_avg_n_Wrap(flt_tot_an(270:299,:,:),0)
Last(1,:,:)=dim_avg_n_Wrap(flt_nat_an(270:299,:,:),0)
Last(2,:,:)=dim_avg_n_Wrap(flt_ant_an(270:299,:,:),0)
Last!0="components"

Last_First_flt=Last-First
copy_VarCoords(Last,Last_First_flt)
First_flt_zec=new((/3,dim(1),dim(2)/),typeof(flt_zec_tot_an))
First_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_tot_an(0:29,:,:),0)
First_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_nat_an(0:29,:,:),0)
First_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_ant_an(0:29,:,:),0)
First_flt_zec!0="components"

Last_flt_zec=new((/3,dim(1),dim(2)/),typeof(flt_zec_tot_an))
Last_flt_zec(0,:,:)=dim_avg_n_Wrap(flt_zec_tot_an(270:299,:,:),0)
Last_flt_zec(1,:,:)=dim_avg_n_Wrap(flt_zec_nat_an(270:299,:,:),0)
Last_flt_zec(2,:,:)=dim_avg_n_Wrap(flt_zec_ant_an(270:299,:,:),0)
Last_flt_zec!0="components"

First_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot_an))
First_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(0:29,:,:),0)
First_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(0:29,:,:),0)
First_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(0:29,:,:),0)
First_flt_cdr!0="components"

Last_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot_an))
Last_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(270:299,:,:),0)
Last_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(270:299,:,:),0)
Last_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(270:299,:,:),0)
Last_flt_cdr!0="components"

Middle_flt_cdr=new((/3,dim(1),dim(2)/),typeof(flt_cdr_tot_an))
Middle_flt_cdr(0,:,:)=dim_avg_n_Wrap(flt_cdr_tot_an(135:164,:,:),0)
Middle_flt_cdr(1,:,:)=dim_avg_n_Wrap(flt_cdr_nat_an(135:164,:,:),0)
Middle_flt_cdr(2,:,:)=dim_avg_n_Wrap(flt_cdr_ant_an(135:164,:,:),0)
Middle_flt_cdr!0="components"

Last_First_flt_zec=Last_flt_zec-First_flt_zec
copy_VarCoords(Last_flt_zec,Last_First_flt_zec)
Last_First_flt_cdr=Last_flt_cdr-First_flt_cdr
copy_VarCoords(Last_flt_cdr,Last_First_flt_cdr)

Middle_First_flt_cdr=Middle_flt_cdr-First_flt_cdr
Last_Middle_flt_cdr=Last_flt_cdr-Middle_flt_cdr
copy_VarCoords(Last_flt_cdr,Middle_First_flt_cdr)
copy_VarCoords(Last_flt_cdr,Last_Middle_flt_cdr)

Last_First_flt_zec=Last_flt_zec-First_flt_zec
copy_VarCoords(Last_flt_zec,Last_First_flt_zec)
Last_First_flt_cdr=Last_flt_cdr-First_flt_cdr
copy_VarCoords(Last_flt_cdr,Last_First_flt_cdr)

Last_First_flt_cdr_merid_avg=dim_avg_n_Wrap(Last_First_flt_cdr,2)
Last_Middle_flt_cdr_merid_avg=dim_avg_n_Wrap(Last_Middle_flt_cdr,2)
Middle_First_flt_cdr_merid_avg=dim_avg_n_Wrap(Middle_First_flt_cdr,2)

levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"RETREAT_flat-CDR_vertical_avg_DICs_${P}" )          ; send graphics to PNG file
res                   = True                       ; plot mods desired
res@gsnFrame               =       False
res@gsnDraw                =       False
res@tiMainString      = ""             ; add title
res@trYReverse        = True                       ; reverse Y-axis
res@tmXUseBottom=False
res@tmXBOn=False
res@tmXTOn=True
res@vpWidthF       = 0.4            ; Change the aspect ratio, but 
res@vpHeightF      = 0.7
res@tmYLLabelFontHeightF=0.02
res@tmXTLabelFontHeightF=0.02
res@gsnXRefLine=0.
res@gsnXRefLineDashPattern=1
res@tmXBOn            = False
res@tmXBLabelsOn      = False
res@tmXBMinorOn       = False
res@tmXBBorderOn      = False

res@tmXTOn            = True
res@tmXTLabelsOn      = True
res@tmXTMinorOn       = True
res@tmXTMajorLengthF  = 0.02
res@tmXTMinorLengthF  = 0.012
res@tmXTBorderOn      = True

res@tmXTMode          = "Manual"
res@trXMinF           = -0.02
res@trXMaxF           = 0.08
res@tmXTTickStartF    = -0.02
res@tmXTTickEndF      = 0.08
res@tmXTTickSpacingF  = 0.04
res@tiXAxisString=""

res@tiYAxisString="Depth [m]"
res@gsnCenterStringFontHeightF=0.025
res@xyLineColors=(/"green","blue","red"/)
res@xyDashPatterns    = (/0,0,0/)
res@xyLineThicknesses=(/4,4,4/)


;------------------------------------
; Last_Middle_flt_cdr, Last_First_flt_cdr  
;------------------------------------
res@gsnCenterString="(a) Middle - First"
plot(0)  = gsn_csm_xy(wks, Middle_First_flt_cdr_merid_avg,depth, res )   ; plaace holder
res@gsnCenterString="(b) Last - Middle"
res@trXMinF           = -0.12
res@trXMaxF           = 0.06
res@tmXTTickStartF    = -0.12
res@tmXTTickEndF      = 0.06
res@tmXTTickSpacingF  = 0.04
plot(1)  = gsn_csm_xy(wks, Last_Middle_flt_cdr_merid_avg,depth,res )   ; plaace holder
res@gsnCenterString="(c) Last - First"
res@trXMinF           = -0.06
res@trXMaxF           = 0.12
res@tmXTTickStartF    = -0.06
res@tmXTTickEndF      = 0.12
res@tmXTTickSpacingF  = 0.04
plot(2)  = gsn_csm_xy(wks, Last_First_flt_cdr_merid_avg,depth, res )   ; plaace holder

gres = True
gres@YPosPercent = 30
gres@XPosPercent = 4
lineres1 = True
lineres1@lgLineColors =(/"green","blue","red"/)
lineres1@lgLineThicknesses = 6
lineres1@LineLengthPercent = 8.
lineres1@lgDashIndexes            = (/0,0,0/)
textres1 = True
textres1@lgLabels = (/"DIC~B~tot~N~","DIC~B~nat~N~","DIC~B~ant~N~"/)
textres1@lgLabelFontHeights   =(/0.02,0.02,0.02/)
textres1@lgPerimOn                = False
textres1@lgItemCount              = 4
;plot(1) = simple_legend(wks,plot(1),gres,lineres1,textres1)
gres@YPosPercent = 30
gres@XPosPercent = 70
;plot(0) = simple_legend(wks,plot(0),gres,lineres1,textres1)
;plot(2) = simple_legend(wks,plot(2),gres,lineres1,textres1)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       True
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 0
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString="${P}"
pres@gsnPanelLeft=0.02

gsn_panel(wks,plot,(/1,3/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
