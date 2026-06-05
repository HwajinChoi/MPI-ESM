begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

u2=addfile(dir0+"flat10_cdr_atlantic_moc_18500101-22991231.nc","r")
amoc=u2->atlantic_moc(:,{1000},{26},0); time*depth*lat
smoc=u2->atlantic_moc(:,{1000},{-35},0);
amoc_an=month_to_annual(amoc,1)
smoc_an=month_to_annual(smoc,1)

f=addfile(dir0+"flat10_cdr_001_indopacific_moc_mm_18500101-22991231.nc","r")
aabw=f->indopacific_moc(:,{4000},{-30},0)
aabw_an=month_to_annual(aabw,1)

;g=addfile(dir0+"flat10_cdr_001_global_moc_moc_mm_18500101-22991231.nc","r")
;glo_moc=g->global_moc(:,:,:,0)
;glo_moc_clim=dim_avg_n_Wrap(glo_moc,0)

amoc_an_sv=amoc_an/(1025*10^(6))
smoc_an_sv=smoc_an/(1025*10^(6))
aabw_an_sv=aabw_an/(1025*10^(6))

copy_VarCoords(amoc_an,amoc_an_sv)
copy_VarCoords(smoc_an,smoc_an_sv)
copy_VarCoords(aabw_an,aabw_an_sv)

year=ispan(1,450,1)

wks=gsn_open_wks("png",dir1+"MOCs_timeseries")
plot=new(3,graphic)
 res                =   True
 res@gsnMaximize    =   False
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.04
 res@tiYAxisFontHeightF =0.04
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@tmYRMinorPerMajor=4
 res@xyLineColor   = (/"black"/)
 res@gsnLeftStringFontHeightF=0.05
 res@gsnLeftStringOrthogonalPosF=0.06
 res@tmXBLabelFontHeightF = 0.04
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@gsnXRefLine=(/150.,300./)
 res@gsnXRefLineDashPattern=1
 res@tmYLLabelFontHeightF = 0.04
 res@gsnLeftString="AMOC (26N,1000m)"
 res@trYMinF       = 12
 res@trYMaxF       =  24
 res@trXMinF       = 0
 res@trXMaxF       =  450
 res@xyLineThicknessF=6
 res@tiYAxisString       =       " [Sv]"
 plot(0)=gsn_csm_xy(wks,year,amoc_an_sv,res)
 res@gsnLeftString="SMOC (35S,1000m)"
 plot(1)=gsn_csm_xy(wks,year,smoc_an_sv,res)
 res@trYMinF       = -10
 res@trYMaxF       =  5
 res@gsnLeftString="AABW (30S,4000m)"
 plot(2)=gsn_csm_xy(wks,year,aabw_an_sv,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/3,1/),pres)

 frame(wks)

end
