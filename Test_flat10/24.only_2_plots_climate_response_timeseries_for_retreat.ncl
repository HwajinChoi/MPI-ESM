begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"for_figure1_variables_for_timeseries_for_300years.nc","r")

co2=f->co2
OCE=f->OCE

year=ispan(1,300,1)

wks=gsn_open_wks("png",dir1+"2_plots_Climate_variabiles_timeseries_3scenarios_300years")
 plot=new(2,graphic)
 res                =   True
 res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF		=0.6
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
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyLineColors   = (/"grey40","darkorange","dodgerblue"/)
 res@xyDashPatterns    =   (/0,0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       300
 res@gsnCenterStringFontHeightF=0.04
 res@gsnCenterStringOrthogonalPosF=0.06
 res@gsnXRefLine=150.
 res@gsnXRefLineDashPattern=1
 res@gsnCenterString="(b) Atmospheric CO~B~2~N~ Concentration"
 res@trYMinF       =  200
 res@trYMaxF       =  1000
 res@tiYAxisString       =       "[ppm]"
 plot(1)=gsn_csm_xy(wks,year,co2,res)
 res@gsnCenterString="(a) Ocean Carbon Sink"
 res@trYMinF       =  0
 res@trYMaxF       =900  
 res@tiYAxisString       =       "[PgC]"
 plot(0)=gsn_csm_xy(wks,year,OCE,res)
 delete([/res@trXMinF,res@trXMaxF,res@xyLineColors,res@xyDashPatterns/])

 gres = True
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"flat10","flat10-zec","flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.03,0.03,0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 gres@YPosPercent = 94.
 gres@XPosPercent = 4

 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/1,2/),pres)

 frame(wks)

end
