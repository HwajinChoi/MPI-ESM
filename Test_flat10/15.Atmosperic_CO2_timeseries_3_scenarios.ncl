begin
dir0="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_001_cfcs_ideal/echam6/plots/"
dir1="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_zec_001_cfcs_ideal/echam6/plots/"
dir2="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_cdr_001_cfcs_ideal/echam6/plots/"
dir3="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"test_flat10_001_cfcs_ideal_echam6_tracer_gym.nc","r")
g=addfile(dir1+"test_flat10_zec_001_cfcs_ideal_echam6_tracer_gym.nc","r")
h=addfile(dir2+"test_flat10_cdr_001_cfcs_ideal_echam6_tracer_gym.nc","r")

f10=f->CO2(:,0,0,0)
f10_zec=g->CO2(:,0,0,0)
f10_cdr=h->CO2(:,0,0,0)

E=new((/3,300/),typeof(f10))
E(0,:)=f10
E(1,:)=f10_zec
E(2,:)=f10_cdr
E!0="Scenarios"

year=ispan(1,300,1)

wks=gsn_open_wks("png",dir3+"Atmospheric_CO2_conc_300_years")
 plot=new(1,graphic)
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
 res@xyLineColors   = (/"grey40","darkorange","dodgerblue"/)
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.025
 res@tiYAxisFontHeightF =0.025
 res@tiMainFontHeightF =0.025
 res@tiMainString       =   ""
 res@xyDashPatterns    =   (/0,0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       300
 res@gsnCenterString="(a) Atmospheric CO~B~2~N~ Concentration"
 res@gsnCenterStringFontHeightF=0.03
 res@trYMinF       = 200 
 res@trYMaxF       =  1000
 res@tiYAxisString       =       "[ppm]"
 res@gsnCenterStringOrthogonalPosF=0.06
; res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2         ; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"      ; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"      ; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,year,E,res)

 gres = True
 gres@YPosPercent = 95.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec","esm-flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.025,0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 draw(plot)
 frame(wks)

end
