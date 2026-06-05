begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
f=addfile(dir1+"DICs_3diff_depth_avg_map_ano_1850-2299.nc","r")
lon=f->lon
lat=f->lat
DIC_0_1000m=f->DIC_0_1000m
DIC_2000_3000m=f->DIC_2000_3000m
DIC_3000_6000m=f->DIC_3000_6000m

DICNAT_0_1000m=f->DICNAT_0_1000m
DICNAT_2000_3000m=f->DICNAT_2000_3000m
DICNAT_3000_6000m=f->DICNAT_3000_6000m

DICANT_0_1000m=f->DICANT_0_1000m
DICANT_2000_3000m=f->DICANT_2000_3000m
DICANT_3000_6000m=f->DICANT_3000_6000m

plot=new(3,graphic)
 wks=gsn_open_wks("png",dir1+"Flat10_zec_DICs_ANO_global_map_3periods_dep_${dep}")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.028
 res@gsnCenterString="(a) First 30 years"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =     0.25
 res@cnMinLevelValF         =     -0.25
 res@cnLevelSpacingF        =      0.025
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "temp_diff_18lev"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map(wks,First(0,:,:),res)
 res@gsnCenterString=""

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString="Flat10 anomaly (${A})"
 gsn_panel(wks,plot,(/3,1/),pres)
 frame(wks)

end

