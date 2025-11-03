begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"for_figure1_variables_for_timeseries_for_300years.nc","r")

AMOC=f->AMOC
E_cum=f->E_cum

year=ispan(1,300,1)

wks=gsn_open_wks("png",dir1+"2plots_flat10_cdr_for_retreat")
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
 res@xyLineColor   = (/"dodgerblue"/)
 res@xyDashPattern    =   (/0/)
 res@trXMinF             =       0
 res@trXMaxF             =       300
 res@gsnCenterString="Cumulative emissions"
 res@gsnCenterStringFontHeightF=0.04
 res@gsnCenterStringOrthogonalPosF=0.06
 res@trYMinF       =  -300
 res@trYMaxF       =  1500
 res@tiYAxisString       =       "[PgC]"
 res@gsnXRefLine=150.
 res@gsnXRefLineDashPattern=1
 plot(0)=gsn_csm_xy(wks,year,E_cum(2,:),res)
 res@gsnCenterString="AMOC"
 res@trYMinF       =  12 
 res@trYMaxF       =  24
 res@tiYAxisString       =       "[Sv]"
 plot(1)=gsn_csm_xy(wks,year,AMOC(2,:),res)

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
 gsn_panel(wks,plot,(/2,1/),pres)

 frame(wks)

end
