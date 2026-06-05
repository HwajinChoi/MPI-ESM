begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;---------- Ocean carbon sink, pgC/year
f=addfile(dir0+"flat10_fgco2_18500101-22991231.nc","r")
g=addfile(dir0+"flat10_zec_fgco2_18500101-22991231.nc","r")
h=addfile(dir0+"flat10_cdr_fgco2_18500101-22991231.nc","r")
; ocean carbon sink
flt_ocean=f->fgco2(:,0,0,0)
flt_zec_ocean=g->fgco2(:,0,0,0)
flt_cdr_ocean=h->fgco2(:,0,0,0)
;----------------------------------------------------------------------
k=addfile(dir0+"for_figure1_variables_for_timeseries_for_450years.nc","r")
T=k->T
E=k->E ; emission
E_cum=k->E_cum ; emission
OCE=k->OCE; 3x450, cumulative ocean carbon sink

T_del=new((/3,450/),"float")
 do i=0,449
  T_del(:,i)=T(:,i)-T(:,0)
 end do
T_del!0="Scenarios"
T_del!1="time"

wks=gsn_open_wks("png",dir1+"addi_timeseries_ocean_sink")
 plot=new(5,graphic)
 plot2=new(5,graphic)
 plot3=new(5,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@gsnCenterStringOrthogonalPosF=0.06
 res@gsnXRefLine=0.
 res@gsnXRefLineDashPattern=1
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1

 res@tmYRMinorPerMajor=4
 res@gsnCenterStringFontHeightF=0.05
 res@xyLineThicknessF= 5
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyLineColor   = (/"grey40"/)
 res@xyDashPatterns    =   (/0/)
 res@trXMinF       = -4
 res@trXMaxF       =  4
 res@tiYAxisString       =       "[PgC]"
 res@tiXAxisString       =       "[PgC/yr]"
 res@trYMinF       = -15
 res@trYMaxF       =  15
 res@gsnCenterString="Air-sea exchange vs delta E"
 plot(0)=gsn_csm_xy(wks,flt_ocean,E(0,:),res)
 res@gsnCenterString=""
 res@tiXAxisString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(0)=gsn_csm_xy(wks,flt_zec_ocean,E(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(0)=gsn_csm_xy(wks,flt_cdr_ocean,E(2,:),res)
 res@tiXAxisString       =       "[PgC/yr]"
 res@trYMinF       = -1
 res@trYMaxF       =  7
 res@xyLineColor   = (/"grey40"/)
 res@tiYAxisString       =       "[~S~o~N~C]"
 res@gsnCenterString="Air-sea exchange vs delta T"
 plot(1)=gsn_csm_xy(wks,flt_ocean,T_del(0,:),res)
 res@gsnCenterString=""
 res@tiXAxisString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(1)=gsn_csm_xy(wks,flt_zec_ocean,T_del(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(1)=gsn_csm_xy(wks,flt_cdr_ocean,T_del(2,:),res)
 res@xyLineColor   = (/"grey40"/)
 res@tiYAxisString       =       "[PgC]"
 res@tiXAxisString       =       "[PgC]"
 res@trYMinF       = -15
 res@trYMaxF       =  15
 res@trXMinF       = 0
 res@trXMaxF       =  1300
 res@gsnCenterString="Ocean Carbon Sink vs delta E"
 plot(2)=gsn_csm_xy(wks,OCE(0,:),E(0,:),res)
 res@gsnCenterString=""
 res@tiXAxisString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(2)=gsn_csm_xy(wks,OCE(1,:),E(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(2)=gsn_csm_xy(wks,OCE(2,:),E(2,:),res)
 res@trYMinF       = -1
 res@trYMaxF       =  7
 res@xyLineColor   = (/"grey40"/)
 res@tiYAxisString       =       "[~S~o~N~C]"
 res@tiXAxisString       =       "[PgC]"
 res@gsnCenterString="Ocean Carbon Sink  vs delta T"
 plot(3)=gsn_csm_xy(wks,OCE(0,:),T_del(0,:),res)
 res@gsnCenterString=""
 res@tiXAxisString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(3)=gsn_csm_xy(wks,OCE(1,:),T_del(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(3)=gsn_csm_xy(wks,OCE(2,:),T_del(2,:),res)
 res@trYMinF       = 0
 res@trYMaxF       =  5000
 res@xyLineColor   = (/"grey40"/)
 res@tiYAxisString       =       "[PgC]"
 res@tiXAxisString       =       "[PgC]"
 res@gsnCenterString="Ocean Carbon Sink vs Cumulative E"
 plot(4)=gsn_csm_xy(wks,OCE(0,:),E_cum(0,:),res)
 res@gsnCenterString=""
 res@tiXAxisString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(4)=gsn_csm_xy(wks,OCE(1,:),E_cum(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(4)=gsn_csm_xy(wks,OCE(2,:),E_cum(2,:),res)

 do i=0,4
 overlay(plot(i),plot2(i))
 overlay(plot(i),plot3(i))
 end do

 gres = True
 gres@YPosPercent = 18.
 gres@XPosPercent = 55
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec","esm-flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.03,0.03,0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
 ;plot(8) = simple_legend(wks,plot(8),gres,lineres,textres)
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)

 gres@YPosPercent = 94.
 gres@XPosPercent = 4
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)
 plot(4) = simple_legend(wks,plot(4),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/3,2/),pres)

 frame(wks)

end
