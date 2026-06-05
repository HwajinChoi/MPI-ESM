begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

g=addfile(dir0+"spco2_global_mean.nc","r")
h=addfile(dir0+"atco2_global_mean.nc","r")

spco2=g->spco2(:,0,0,0)
atco2=h->spco2(:,0,0,0)

fgco2_2=new((/2,450/),typeof(spco2))
fgco2_2(0,:)=spco2
fgco2_2(1,:)=atco2

year=ispan(1,450,1)
wks=gsn_open_wks("png",dir1+"CDR_spco2_atco2_global_total_flux")
plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trXMinF             =       0
 res@trXMaxF             =       450

 res@trYMinF             =       20
 res@trYMaxF             =       60
 res@tiXAxisString       =       "Simulation years"
 res@tiYAxisString       =       "[ Pa ]"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.04
 res@tiMainString       =   "Global mean pCO~B~2~N~"
 res@tmYRMinorPerMajor=4
 res@xyLineColors   = (/"navy","orange"/)
 res@xyDashPatterns   =   (/0,0/)

 res@gsnLeftStringFontHeightF=0.05
 res@gsnLeftStringOrthogonalPosF=0.06
 res@tmXBLabelFontHeightF = 0.03
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@gsnXRefLine=150.
 res@gsnXRefLineDashPattern=1
 res@gsnYRefLineThicknessF=4
 res@gsnXRefLineThicknessF=4
 res@tmYLLabelFontHeightF = 0.03
 plot=gsn_csm_xy(wks,year,fgco2_2,res)

 gres = True
 gres@YPosPercent = 94.
 gres@XPosPercent = 58
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColors =(/"navy","orange"/)
 lineres@lgLineThicknesses = (/6,6/)
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"Oceanic pCO2","Atmos. pCO2"/)
 textres@lgLabelFontHeights   =(/0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4

 plot = simple_legend(wks,plot,gres,lineres,textres)
 draw(plot)
 frame(wks)

end
