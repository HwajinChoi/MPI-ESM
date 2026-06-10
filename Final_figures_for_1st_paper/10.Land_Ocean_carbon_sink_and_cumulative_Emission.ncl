begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/Final_figures/"
f=addfile(dir1+"flat10_cdr_land_carbon_flux_PgCyr_1850-2299.nc","r")
Cflux=f->Cflux(:,0,0)

g=addfile(dir1+"for_figure1_variables_for_timeseries_for_450years.nc","r")
E_cum=g->E_cum
OCE=g->OCE

cflux_cumsum=dim_cumsum_Wrap(Cflux,2)
year=ispan(1,450,1)

wks=gsn_open_wks("png",dir2+"flat10_cdr_ocean_land_carbon_sink_and_cumulative_E_for_450years")
 plot=new(3,graphic)
 plot1=new(2,graphic)
 res                =   True
 res@gsnMaximize    =   False
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
 res@xyLineThicknessF= 6
 res@tmXBLabelFontHeightF = 0.04
 res@tmYLLabelFontHeightF = 0.04
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.04
 res@tiYAxisFontHeightF =0.04
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyDashPattern    =   (/0/)
 res@gsnCenterStringFontHeightF=0.045
 res@gsnLeftStringFontHeightF=0.045
 res@trYMinF       =  0
 res@trYMaxF       =  500
 res@tiYAxisString       =       "[PgC]"
 res@gsnCenterStringOrthogonalPosF=0.06
 res@gsnLeftStringOrthogonalPosF=0.06
 res@gsnCenterString="(a) Ocean Carbon Sink"
 res@gsnLeftString=""
 plot(0)=gsn_csm_xy(wks,year,OCE(2,:),res)
 res@trYMinF       =  -100
 res@trYMaxF       =  500
 res@gsnCenterString="(b) Land Carbon Sink"
 plot(1)=gsn_csm_xy(wks,year,cflux_cumsum,res)
 delete([/res@trYMinF,res@trYMaxF,res@trXMinF,res@trXMaxF/])
 res@gsnCenterString=""
 res@gsnXRefLine=0.
 res@gsnXRefLineDashPattern=1
 res@gsnLeftString="(c) "
 res@trYMinF       = 0
 res@trYMaxF       =  1500
 res@trXMinF       = -100
 res@trXMaxF       =  500
 res@xyLineColor="red"
 res@xyLineThicknessF=5
 res@tiYAxisString       =       "Cumulative E [PgC]"
 res@tiXAxisString       =       "Land Carbon Sink [PgC]"
 res@xyDashPattern    =   (/16/)
 plot(2)=gsn_csm_xy(wks,cflux_cumsum(0:149),E_cum(2,0:149),res)
 res@gsnLeftString=""
 res@xyDashPattern    =   (/14/)
 res@xyLineOpacityF=0.5
 plot1(0)=gsn_csm_xy(wks,cflux_cumsum(150:299),E_cum(2,150:299),res)
 res@xyLineOpacityF=1.0
 res@xyDashPattern    =   (/0/)
 plot1(1)=gsn_csm_xy(wks,cflux_cumsum(300:449),E_cum(2,300:449),res)
 overlay(plot(2),plot1(0))
 overlay(plot(2),plot1(1))

 gres = True
 gres@YPosPercent = 19
 gres@XPosPercent = 50
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"red","tomato","red"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 20.
 lineres@lgDashIndexes            = (/16,14,0/)
 textres = True
 textres@lgLabels = (/"ramp-up","ramp-down","net-zero"/)
 textres@lgLabelFontHeights   =(/0.03,0.03,0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 textres@lgLabelOffsetF=0.1
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/1,3/),pres)
 frame(wks)

end
