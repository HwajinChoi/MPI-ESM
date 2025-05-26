begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"for_figure1_variables_for_timeseries_for_300years.nc","r")

T=f->T
npp=f->npp
AMOC=f->AMOC
dic_inv=f->dic_inv
E=f->E
E_cum=f->E_cum
co2=f->co2
sst=f->sst
OCE=f->OCE
LAND=f->LAND

T_del=new((/3,300/),"float")
 do i=0,299
  T_del(:,i)=T(:,i)-T(:,0)
 end do
T_del!0="Scenarios"
T_del!1="time"

print(T_del(2,:))
exit

dic_inv_del=new((/3,300/),"float")
 do i=0,299
  dic_inv_del(:,i)=dic_inv(:,i)-dic_inv(:,0)
 end do
dic_inv_del!0="Scenarios"
dic_inv_del!1="time"
;-------------------------------------------------------
printMinMax(T_del,0)
;printVarSummary(E_cum)
;exit

;-------------------------------------------------------

year=ispan(1,300,1)

wks=gsn_open_wks("png",dir1+"Climate_variabiles_timeseries_3scenarios_300years")
 plot=new(10,graphic)
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
 res@gsnCenterString="(a) Emissions"
 res@gsnCenterStringFontHeightF=0.05
 res@trYMinF       =  -15
 res@trYMaxF       =  15
 res@tiYAxisString       =       "[PgC/yr]"
 res@gsnCenterStringOrthogonalPosF=0.06
; res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2         ; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"      ; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"      ; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,year,E,res)
 res@gsnCenterString="(b) Cumulative emissions"
 res@trYMinF       =  -500
 res@trYMaxF       =  4000
 res@tiYAxisString       =       "[PgC]"
 plot(1)=gsn_csm_xy(wks,year,E_cum,res)
 res@gsnCenterString="(c) Atmospheric CO~B~2~N~ Concentration"
 res@trYMinF       =  200
 res@trYMaxF       =  1000
 res@tiYAxisString       =       "[ppm]"
 plot(2)=gsn_csm_xy(wks,year,co2,res)
 res@gsnCenterString="(d) SST"
 res@trYMinF       =  16
 res@trYMaxF       =  21
 res@tiYAxisString       =       "[~S~o~N~C]"
 plot(3)=gsn_csm_xy(wks,year,sst,res)
 res@gsnCenterString="(e) Ocean Carbon Sink"
 res@trYMinF       =  0
 res@trYMaxF       =900  
 res@tiYAxisString       =       "[PgC]"
 plot(4)=gsn_csm_xy(wks,year,OCE,res)
 res@gsnCenterString="(f) Land Carbon Sink"
 res@trYMinF       =  0
 res@trYMaxF       = 3100 
 res@tiYAxisString       =       "[PgC]"
 plot(5)=gsn_csm_xy(wks,year,LAND,res)
 delete([/res@trXMinF,res@trXMaxF/])
 res@gsnCenterString="(i) NPP"
 res@trXMinF             =       0
 res@trXMaxF             =       300
 res@trYMinF       = 100 
 res@trYMaxF       =  150
 res@tiYAxisString       =       "[g C m~S~-2~N~ yr~S~-1~N~]"
 plot(8)=gsn_csm_xy(wks,year,npp,res)
 res@gsnCenterString="(j) AMOC"
 res@trYMinF       =  10 
 res@trYMaxF       =  24
 res@tiYAxisString       =       "[Sv]"
 plot(9)=gsn_csm_xy(wks,year,AMOC,res)
 delete([/res@trXMinF,res@trXMaxF,res@xyLineColors,res@xyDashPatterns/])
 res@tiXAxisString       =       "Cumulative emission [PgC]"
 plot2=new(2,graphic)
 plot3=new(2,graphic)
 res@xyLineColor   = (/"grey40"/)
 res@xyDashPatterns    =   (/0/)
 res@gsnCenterString="(g) TCRE"
 delete([/res@trYMinF,res@trYMaxF/])
 res@trYMinF       = -1
 res@trYMaxF       =  5
 res@trXMinF       = 20 
 res@trXMaxF       =  3000
 res@tiYAxisString       =       "[~S~o~N~C]"
 plot(6)=gsn_csm_xy(wks,E_cum(0,:),T_del(0,:),res)
 res@gsnCenterString=""
 res@tiXAxisString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(0)=gsn_csm_xy(wks,E_cum(1,:),T_del(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(0)=gsn_csm_xy(wks,E_cum(2,:),T_del(2,:),res)
 delete([/res@trXMinF,res@trXMaxF/])
 res@xyLineColor   = (/"grey40"/)
 res@tiXAxisString       =       "Cumulative emission [PgC]"
 res@gsnCenterString="(h)Ocean DIC inventory change"
 res@trYMinF       =0  
 res@trYMaxF       =  870
 res@trXMinF       =  20 
 res@trXMaxF       =  3000
 res@tiYAxisString       =       ""
 plot(7)=gsn_csm_xy(wks,E_cum(0,:),dic_inv_del(0,:),res)
 res@tiXAxisString       =       "[PgC]"
 res@gsnCenterString       =       ""
 res@xyLineColor   = (/"darkorange"/)
 plot2(1)=gsn_csm_xy(wks,E_cum(1,:),dic_inv_del(1,:),res)
 res@xyLineColor   = (/"dodgerblue"/)
 plot3(1)=gsn_csm_xy(wks,E_cum(2,:),dic_inv_del(2,:),res)
 overlay(plot(6),plot2(0))
 overlay(plot(6),plot3(0))
 overlay(plot(7),plot2(1))
 overlay(plot(7),plot3(1))

 gres = True
 gres@YPosPercent = 18.
 gres@XPosPercent = 4
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
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(8) = simple_legend(wks,plot(8),gres,lineres,textres)
 plot(9) = simple_legend(wks,plot(9),gres,lineres,textres)

 gres@YPosPercent = 94.
 gres@XPosPercent = 4
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)
 plot(4) = simple_legend(wks,plot(4),gres,lineres,textres)
 plot(5) = simple_legend(wks,plot(5),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/5,2/),pres)

 frame(wks)

end
