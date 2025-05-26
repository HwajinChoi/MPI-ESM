begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"fldmean_test_flat10_001_cfcs_ideal_tos_18500101_21491231.nc","r")
g=addfile(dir0+"fldmean_test_flat10_zec_001_cfcs_ideal_tos_18500101_21491231.nc","r")
h=addfile(dir0+"fldmean_test_flat10_cdr_001_cfcs_ideal_tos_18500101_21491231.nc","r")

f10=f->tos(:,0,0,0)
f10_zec=g->tos(:,0,0,0)
f10_cdr=h->tos(:,0,0,0)

f10_2=month_to_annual(f10,1)
f10_zec_2=month_to_annual(f10_zec,1)
f10_cdr_2=month_to_annual(f10_cdr,1)

E=new((/3,300/),typeof(f10))
E(0,:)=f10_2
E(1,:)=f10_zec_2
E(2,:)=f10_cdr_2
E!0="Scenarios"
printMinMax(E,0)

year=ispan(1,300,1)

wks=gsn_open_wks("png",dir1+"SST_timeseries_300_years")
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
 res@gsnCenterString="(b) SST"
 res@gsnCenterStringFontHeightF=0.03
 res@trYMinF       = 16 
 res@trYMaxF       = 21 
 res@tiYAxisString       =       "[~S~o~N~C]"
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
