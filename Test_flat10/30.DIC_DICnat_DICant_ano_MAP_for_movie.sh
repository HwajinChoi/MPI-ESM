#!/bin/bash

for Z in "0_1000m" "2000_3000m" "3000_6000m";do

cat << EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/MPI-ESM/image/DICs_map_for_ani/"
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
f=addfile(dir1+"DICs_3diff_depth_avg_map_ano_1850-2299.nc","r")
lon2d=f->lon
lat2d=f->lat
DIC_${Z}=f->DIC_${Z}
DICNAT_${Z}=f->DICNAT_${Z}
DICANT_${Z}=f->DICANT_${Z}

DIC_${Z}@lon2d=lon2d
DIC_${Z}@lat2d=lat2d
DICANT_${Z}@lon2d=lon2d
DICANT_${Z}@lat2d=lat2d
DICNAT_${Z}@lon2d=lon2d
DICNAT_${Z}@lat2d=lat2d

DIC_${Z}=DIC_${Z}*1000
DICANT_${Z}=DICANT_${Z}*1000
DICNAT_${Z}=DICNAT_${Z}*1000

do i = 0, 450-1
 plot=new(3,graphic)
 wks=gsn_open_wks("png",dir0+"DICs_ANO_global_map_dep_${Z}_"+i+"year")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
; res@sfXArray=lon2d
; res@sfYArray=lat2d
; res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.028
 res@gsnCenterString="(a) DIC~B~tot~N~"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =     120
 res@cnMinLevelValF         =     -120
 res@cnLevelSpacingF        =      20
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "temp_diff_18lev"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map(wks,DIC_${Z}(i,:,:),res)
 res@gsnCenterString="(a) DIC~B~ant~N~"
 plot(1)=gsn_csm_contour_map(wks,DICANT_${Z}(i,:,:),res)
 res@gsnCenterString="(a) DIC~B~nat~N~"
 plot(2)=gsn_csm_contour_map(wks,DICNAT_${Z}(i,:,:),res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@lbLabelFontHeightF  = 0.015
; pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString="Year "+i
 gsn_panel(wks,plot,(/3,1/),pres)
 frame(wks)
end do

end
EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done
