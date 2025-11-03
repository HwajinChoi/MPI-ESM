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
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------------------------------------------------------
f1=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_thetao_1850-2149_lon_${A}.nc","r")
t_flt=f1->thetao(:,:,:,0) ; time x depth x lat
g1=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_so_1850-2149_lon_${A}.nc","r")
so_flt=g1->so(:,:,:,0)
h1=addfile(dir0+"phosy_flat10_r192x96_1850-2149_lon_${A}.nc","r")
phosy_flt=h1->phosy(:,:,:,0)
;------------------------------------------------------
f2=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_thetao_1850-2149_lon_${A}.nc","r")
t_flt_zec=f2->thetao(:,:,:,0) ; time x depth x lat
g2=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_so_1850-2149_lon_${A}.nc","r")
so_flt_zec=g2->so(:,:,:,0)
h2=addfile(dir0+"phosy_flat10_zec_r192x96_1850-2149_lon_${A}.nc","r")
phosy_flt_zec=h2->phosy(:,:,:,0)
;------------------------------------------------------
f3=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_thetao_1850-2149_lon_${A}.nc","r")
t_flt_cdr=f3->thetao(:,:,:,0) ; time x depth x lat
g3=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_so_1850-2149_lon_${A}.nc","r")
so_flt_cdr=g3->so(:,:,:,0)
h3=addfile(dir0+"phosy_flat10_cdr_r192x96_1850-2149_lon_${A}.nc","r")
phosy_flt_cdr=h3->phosy(:,:,:,0)
;------------------------------------------------------
dim=dimsizes(t_flt)
First=new((/3,3,dim(1),dim(2)/),typeof(t_flt))
First(0,0,:,:)=dim_avg_n_Wrap(t_flt(0:29,:,:),0)
First(1,0,:,:)=dim_avg_n_Wrap(t_flt_zec(0:29,:,:),0)
First(2,0,:,:)=dim_avg_n_Wrap(t_flt_cdr(0:29,:,:),0)

First(0,1,:,:)=dim_avg_n_Wrap(so_flt(0:29,:,:),0)
First(1,1,:,:)=dim_avg_n_Wrap(so_flt_zec(0:29,:,:),0)
First(2,1,:,:)=dim_avg_n_Wrap(so_flt_cdr(0:29,:,:),0)

First(0,2,:,:)=dim_avg_n_Wrap(phosy_flt(0:29,:,:),0)
First(1,2,:,:)=dim_avg_n_Wrap(phosy_flt_zec(0:29,:,:),0)
First(2,2,:,:)=dim_avg_n_Wrap(phosy_flt_cdr(0:29,:,:),0)
First!0="scenarios"
First!1="variables"

Last=new((/3,3,dim(1),dim(2)/),typeof(t_flt))
Last(0,0,:,:)=dim_avg_n_Wrap(t_flt(270:299,:,:),0)
Last(1,0,:,:)=dim_avg_n_Wrap(t_flt_zec(270:299,:,:),0)
Last(2,0,:,:)=dim_avg_n_Wrap(t_flt_cdr(270:299,:,:),0)

Last(0,1,:,:)=dim_avg_n_Wrap(so_flt(270:299,:,:),0)
Last(1,1,:,:)=dim_avg_n_Wrap(so_flt_zec(270:299,:,:),0)
Last(2,1,:,:)=dim_avg_n_Wrap(so_flt_cdr(270:299,:,:),0)

Last(0,2,:,:)=dim_avg_n_Wrap(phosy_flt(270:299,:,:),0)
Last(1,2,:,:)=dim_avg_n_Wrap(phosy_flt_zec(270:299,:,:),0)
Last(2,2,:,:)=dim_avg_n_Wrap(phosy_flt_cdr(270:299,:,:),0)
Last!0="scenarios"
Last!1="variable"

Last_First=Last-First
copy_VarCoords(Last,Last_First)
;------------------------------------------------------

Middle_flt_cdr=new((/3,dim(1),dim(2)/),typeof(phosy_flt))
Middle_flt_cdr(0,:,:)=dim_avg_n_Wrap(t_flt_cdr(135:164,:,:),0)
Middle_flt_cdr(1,:,:)=dim_avg_n_Wrap(so_flt_cdr(135:164,:,:),0)
Middle_flt_cdr(2,:,:)=dim_avg_n_Wrap(phosy_flt_cdr(135:164,:,:),0)
Middle_flt_cdr!0="variable"

Middle_First_flt_cdr=Middle_flt_cdr-First(2,:,:,:)
Last_Middle_flt_cdr=Last(2,:,:,:)-Middle_flt_cdr
copy_VarCoords(Last(2,:,:,:),Middle_First_flt_cdr)
copy_VarCoords(Last(2,:,:,:),Last_Middle_flt_cdr)

levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do
;------------------------------------------------------
plot=new(15,graphic)
wks   = gsn_open_wks ("png", dir1+"temp_sal_photo_2D_vertical_DICs_${P}_Last_First_ano" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired

; Set resources for when we turn on labelbar later
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

res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@cnMissingValFillColor="black"
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@tmYLLabels =(..)
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.03
res@tmYLLabelFontHeightF=0.03
res@tiYAxisFontHeightF=0.03

res@gsnCenterString="(a) flat10"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"

res2=res
res3=res

res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     2.5
res@cnMinLevelValF         =     -2.5
res@cnLevelSpacingF        =      0.5
plot(0)  = gsn_csm_contour(wks, Last_First(0,0,:,:), res )
res@tiYAxisOn=False
res@gsnCenterString="(b) flat10-zec"
res@tmYLLabelsOn	= False
plot(1)  = gsn_csm_contour(wks, Last_First(1,0,:,:), res )
res@gsnCenterString="(c) flat10-cdr"
plot(2)  = gsn_csm_contour(wks, Last_First(2,0,:,:), res )
res@gsnCenterString="(d) flat10-cdr (Mid-Fir)"
plot(3)  = gsn_csm_contour(wks, Middle_First_flt_cdr(0,:,:), res )
res@gsnCenterString="(e) flat10-cdr (Last-Mid)"
res@lbLabelBarOn           = True
plot(4)  = gsn_csm_contour(wks, Last_Middle_flt_cdr(0,:,:), res )

res2@gsnCenterString=""
res2@cnLevelSelectionMode   =       "ManualLevels"
res2@cnMaxLevelValF         =     0.5
res2@cnMinLevelValF         =     -0.5
res2@cnLevelSpacingF        =      0.1
plot(5)  = gsn_csm_contour(wks, Last_First(0,1,:,:), res2 )   
res2@tiYAxisOn=False
res2@tmYLLabelsOn	= False
plot(6)  = gsn_csm_contour(wks, Last_First(1,1,:,:), res2 )  
plot(7)  = gsn_csm_contour(wks, Last_First(2,1,:,:), res2 )  
plot(8)  = gsn_csm_contour(wks, Middle_First_flt_cdr(1,:,:), res2 )  
res2@lbLabelBarOn           = True
plot(9)  = gsn_csm_contour(wks, Last_Middle_flt_cdr(1,:,:), res2 )  

res3@gsnCenterString=""
res3@cnLevelSelectionMode   =       "ManualLevels"
res3@cnMaxLevelValF         =      0.000000001
res3@cnMinLevelValF         =     -0.000000001
res3@cnLevelSpacingF        =      0.0000000002
plot(10)  = gsn_csm_contour(wks, Last_First(0,2,{0:200},:), res3 )  
res3@tiYAxisOn=False
res3@tmYLLabelsOn	= False
plot(11)  = gsn_csm_contour(wks, Last_First(1,2,{0:200},:), res3 ) 
plot(12)  = gsn_csm_contour(wks, Last_First(2,2,{0:200},:), res3 )
plot(13)  = gsn_csm_contour(wks, Middle_First_flt_cdr(2,{0:200},:), res3 )
res3@lbLabelBarOn           = True
plot(14)  = gsn_csm_contour(wks, Last_Middle_flt_cdr(2,{0:200},:), res3 )

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = False
pres@gsnMaximize        =       False
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 0
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString="${P}"
pres@gsnPanelLeft=0.04
pres@gsnPanelRight=0.95
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txFontHeightF = 0.012
txres1@txAngleF=90
gsn_text_ndc(wks,"Temperature",0.03,0.62,txres1)
gsn_text_ndc(wks,"Salinity",0.03,0.47,txres1)
gsn_text_ndc(wks,"Photosynthesis",0.03,0.32,txres1)
txres2	= True
txres2@txFontHeightF = 0.01
gsn_text_ndc(wks,"~S~o~N~C",0.96,0.68,txres2)
gsn_text_ndc(wks,"psu",0.96,0.535,txres2)
gsn_text_ndc(wks,"mol C m-3 s-1",0.957,0.39,txres2)

;gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.94,0.25,txres1)

gsn_panel(wks,plot,(/3,5/),pres)
frame(wks)
end

EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
