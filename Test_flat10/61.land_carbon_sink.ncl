begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"flat10_cdr_land_carbon_flux_PgCyr_1850-2299.nc","r")
Cflux=f->Cflux(:,0,0)

cflux_cumsum=dim_cumsum_Wrap(Cflux,2)
year=ispan(1,450,1)

wks=gsn_open_wks("png",dir2+"flat10_cdr_land_carbon_sink_for_450years")
 plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 ;res@trYMinF       =  -1.5 
 ;res@trYMaxF       =   1.5
 ;res@tmYLMode = "Mannual"
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@xyLineColor   = (/"dodgerblue"/)
 res@xyLineThicknessF= 8
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyDashPattern    =   (/0/)
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@gsnCenterString="(a) Land Carbon Sink"
 res@gsnCenterStringFontHeightF=0.04
 res@trYMinF       =  -50
 res@trYMaxF       =  500
 res@tiYAxisString       =       "[PgC]"
 res@gsnCenterStringOrthogonalPosF=0.06
 plot(0)=gsn_csm_xy(wks,year,cflux_cumsum,res)

 gres = True
 gres@YPosPercent = 18.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0/)
 textres = True
 textres@lgLabels = (/"flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
 ;plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 draw(plot)
 frame(wks)
end
