begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
f1=addfile(dir0+"wo_flat10_r192x96_200m_1850-1879.nc","r")
f2=addfile(dir0+"wo_flat10_zec_r192x96_200m_1850-1879.nc","r")
f3=addfile(dir0+"wo_flat10_cdr_r192x96_200m_1850-1879.nc","r")
wo_flt_p1=f1->wo(:,0,:,:)
wo_flt_zec_p1=f2->wo(:,0,:,:)
wo_flt_cdr_p1=f3->wo(:,0,:,:)
lon=f1->lon
lat=f1->lat

;wo_flt_p1@lat2d=lat
;wo_flt_p1@lon2d=lon
;wo_flt_zec_p1@lat2d=lat
;wo_flt_zec_p1@lon2d=lon
;wo_flt_cdr_p1@lat2d=lat
;wo_flt_cdr_p1@lon2d=lon

dim=dimsizes(wo_flt_p1)
First=new((/3,dim(0),dim(1),dim(2)/),typeof(wo_flt_p1))
First(0,:,:,:)=wo_flt_p1
First(1,:,:,:)=wo_flt_zec_p1
First(2,:,:,:)=wo_flt_cdr_p1

g1=addfile(dir0+"wo_flat10_r192x96_200m_2270-2299.nc","r")
g2=addfile(dir0+"wo_flat10_zec_r192x96_200m_2270-2299.nc","r")
g3=addfile(dir0+"wo_flat10_cdr_r192x96_200m_2270-2299.nc","r")
wo_flt_p2=g1->wo(:,0,:,:)
wo_flt_zec_p2=g2->wo(:,0,:,:)
wo_flt_cdr_p2=g3->wo(:,0,:,:)

;wo_flt_p2@lat2d=lat
;wo_flt_p2@lon2d=lon
;wo_flt_zec_p2@lat2d=lat
;wo_flt_zec_p2@lon2d=lon
;wo_flt_cdr_p2@lat2d=lat
;wo_flt_cdr_p2@lon2d=lon

Last=new((/3,dim(0),dim(1),dim(2)/),typeof(wo_flt_p1))
Last(0,:,:,:)=wo_flt_p2
Last(1,:,:,:)=wo_flt_zec_p2
Last(2,:,:,:)=wo_flt_cdr_p2

First_av=dim_avg_n_Wrap(First,1)
Last_av=dim_avg_n_Wrap(Last,1)
First_av!0="scenario"
Last_av!0="scenario"

Diff=Last_av-First_av
;Diff@lat2d=lat
;Diff@lon2d=lon
copy_VarCoords(First_av,Diff)

 plot=new(3,graphic)
 wks=gsn_open_wks("png",dir1+"wo_DIFF_map_First_Last_30yrs")
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
 res@gsnCenterString=" "
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@lbLabelFontHeightF  = 0.024
 res@lbLabelBarOn           =      True
 res@cnFillPalette          =       "temp_diff_18lev"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.000003
 res@cnMinLevelValF         =     -0.000003
 res@cnLevelSpacingF        =      0.0000005


 plot(0)=gsn_csm_contour_map(wks,Diff(0,:,:),res)
 plot(1)=gsn_csm_contour_map(wks,Diff(1,:,:),res)
 plot(2)=gsn_csm_contour_map(wks,Diff(2,:,:),res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 8
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString=""

 txres               = True                      ; text mods desired
 txres@txFontHeightF = 0.020                     ; text font height
 gsn_text_ndc(wks,"flat10",0.25,0.86,txres)
 gsn_text_ndc(wks,"flat10-zec",0.25,0.52,txres)
 gsn_text_ndc(wks,"flat10-cdr",0.25,0.2,txres)

 gsn_panel(wks,plot,(/3,1/),pres)
 frame(wks)

end
