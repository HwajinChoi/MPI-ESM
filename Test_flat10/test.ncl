begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_dissic_19900101-19931231.nc","r")
dic=f->dissic(:,0,:,:)
dic_jja=month_to_season(dic,"JJA")
dic_jja_clim=dim_avg_n_Wrap(dic_jja,0)

dic_djf=month_to_season(dic,"DJF")
dic_djf_clim=dim_avg_n_Wrap(dic_djf,0)


plot=new(2,graphic)
 wks=gsn_open_wks("png",dir1+"Flat10_DIC_seaice_test")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@mpMinLatF                  =60
 ;res@mpProjection ="Robinson"
 ;res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnPolar   = "NH" 
 res@gsnCenterStringFontHeightF= 0.040
 res@gsnCenterString="(a) JJA "
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "gray"
 res@tmXBLabelFontHeightF=       0.026
 res@gsnPolarLabelFontHeightF=0.02
 res@tmXBLabelFontThicknessF=    2
 res@tmXBMajorLengthF    =       0.02
 res@tmXBMinorLengthF    =       0.01
 res@tmXBLabelStride     =       2
 res@tmYLLabelFontHeightF=       0.016
 res@tmYLMajorLengthF   =       0.02
 res@tmYLMinorLengthF   =       0.01
 res@tmYLLabelFontThicknessF=    2
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "cmocean_haline"
 res@lbLabelBarOn           =      True
 plot(0)=gsn_csm_contour_map_polar(wks,dic_jja_clim,res)
 res@gsnCenterString="(b) DJF"
 plot(1)=gsn_csm_contour_map_polar(wks,dic_djf_clim,res)
 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString="Flat10-seaice-test"

 gsn_panel(wks,plot,(/1,2/),pres)
 frame(wks)

end
