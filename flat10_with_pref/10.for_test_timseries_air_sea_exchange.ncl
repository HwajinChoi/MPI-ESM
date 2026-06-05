begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;---------- Ocean carbon sink, pgC/year
f=addfile(dir0+"flat10_fgco2_18500101-22991231.nc","r")
g=addfile(dir0+"flat10_zec_fgco2_18500101-22991231.nc","r")
h=addfile(dir0+"flat10_cdr_fgco2_18500101-22991231.nc","r")
; ocean carbon sink
flt_ocean=f->fgco2(:,0,0,0)
flt_zec_ocean=g->fgco2(:,0,0,0)
flt_cdr_ocean=h->fgco2(:,0,0,0)
Ex=new((/3,450/),typeof(flt_ocean))
Ex(0,:)=flt_ocean
Ex(1,:)=flt_zec_ocean
Ex(2,:)=flt_cdr_ocean
Ex!0="Scenario"

 year=ispan(1,450,1)
 wks=gsn_open_wks("png",dir1+"air_sea_exchage_timeseries")
 plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@xyLineThicknessF= 6
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyLineColors   = (/"grey40","darkorange","dodgerblue"/)
 res@xyDashPatterns    =   (/0,0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@gsnCenterString="air-sea exchange"
 res@gsnCenterStringFontHeightF=0.05
 res@trYMinF       =  -4
 res@trYMaxF       =  4
 res@tiYAxisString       =       "[PgC/yr]"
 res@gsnCenterStringOrthogonalPosF=0.06
 plot=gsn_csm_xy(wks,year,Ex,res)

 gres = True
 gres@YPosPercent = 20.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec","esm-flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.03,0.03,0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 plot = simple_legend(wks,plot,gres,lineres,textres)
 draw(plot)
 frame(wks)

end
