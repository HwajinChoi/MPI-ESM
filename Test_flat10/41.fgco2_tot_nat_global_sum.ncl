begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_fgco2_global_sum_PgCyr_185001_229912.nc","r")
g=addfile(dir0+"flat10_cdr_fgco2nat_global_sum_PgCyr_185001_229912.nc","r")

fgco2=f->fgco2(:,0,0,0)
fgco2nat=g->fgco2nat(:,0,0,0)
fgco2ant=fgco2-fgco2nat
copy_VarCoords(fgco2,fgco2ant)

fgco2_2=new((/3,450/),typeof(fgco2))
fgco2_2(0,:)=fgco2
fgco2_2(1,:)=fgco2nat
fgco2_2(2,:)=fgco2ant

year=ispan(1,450,1)
wks=gsn_open_wks("png",dir1+"CDR_fgco2_tot_nat_ant_global_total_flux")
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

 res@trYMinF             =       -6
 res@trYMaxF             =       8
 res@tiXAxisString       =       "Simulation years"
 res@tiYAxisString       =       "[ PgC/yr ]"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.04
 res@tiMainString       =   "Global total flux"
 res@tmYRMinorPerMajor=4
 res@xyLineColors   = (/"green","blue","red"/)
 res@xyDashPatterns   =   (/0,0,0/)

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
 gres@XPosPercent = 68
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColors =(/"green","blue","red"/)
 lineres@lgLineThicknesses = (/6,6,6/)
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"fgco2","fgco2nat","fgco2ant"/)
 textres@lgLabelFontHeights   =(/0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4

 plot = simple_legend(wks,plot,gres,lineres,textres)
 draw(plot)
 frame(wks)

end
