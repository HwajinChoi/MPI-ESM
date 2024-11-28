begin
dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"","r")

wks=gsn_open_wks("x11",dir2+"air_sea_CO2_flux_timeseries_1850-2300")
 plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@gsnPaperOrientation =       "portrait"
 res@gsnYRefLine         =       0
 res@gsnYRefLineThicknessF       =       3.0
 res@gsnYRefLineDashPattern      =       2
 res@gsnLeftString="Air-Sea CO2 flux "

 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.4            ; make plot as large as possible.
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trYMinF       =  -2
 res@trYMaxF       =   7
 ;res@trYMinF       =  -1.5 
 ;res@trYMaxF       =   1.5
 ;res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@xyLineColors   = (/"red","blue","black","purple","orange"/)
 res@xyLineThicknessF= 5
 res@tiYAxisString       =       "CO2 fluxes into the ocean [PgC/yr]"
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
; res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 res@tiMainString       =   ""
 res@xyDashPatterns    =   (/0,0,0,0,0/)
 res@trXMinF             =       1850
 res@trXMaxF             =       2300
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2         ; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"      ; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"      ; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,x,T_plot,res)

 gres = True
 gres@YPosPercent = 12.
 gres@XPosPercent = 60
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors =(/"red","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"Lateral","Vertical"/)
; textres@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 gres1 = True
 gres1@YPosPercent = 15.
 gres1@XPosPercent = 80
 gres1@ItemSpacePercent          = 5
 lineres1 = True
 lineres1@lgLineColors =(/"black","purple","orange"/)
 ;lineres1@lgLineColors = (/"purple"/)
 lineres1@lgLineThicknesses = 4
 lineres1@LineLengthPercent = 4.
 lineres1@lgDashIndexes            = (/0,0,0/)
 textres1 = True
 ;textres1@lgLabels = (/"Residual"/)
 textres1@lgLabels = (/"dT*/dt","Sum","Residual"/)
 ;textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)

 draw(plot)
 frame(wks)

end
