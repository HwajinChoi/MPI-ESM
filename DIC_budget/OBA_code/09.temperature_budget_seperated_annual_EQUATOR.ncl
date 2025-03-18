begin
;--------------------------------------------
; EQUATOR : 150E-90E (270), 20S-20N
; SP region : 160W-110W, 15S-10S
;--------------------------------------------
dir1="/data/hjchoi/CMI/OBA/data/advection/"
dir2="/data/hjchoi/CMI/OBA/image/"
lat_s=-20
lat_f=20
lon_s=150
lon_f=270

g=addfile(dir1+"ECDA-COBALT_dT_dx_100-300_advection_199001-201712.nc","r")
u_bar_T_prime=g->u_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_T_bar=g->u_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h=addfile(dir1+"ECDA-COBALT_dT_dy_100-300_advection_199001-201712.nc","r")
v_bar_T_prime=h->v_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_T_bar=h->v_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k=addfile(dir1+"ECDA-COBALT_dT_dz_all_depth_advection_199001-201712.nc","r")
w_bar_T_prime=k->w_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f},1)
w_prime_T_bar=k->w_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f},1)

m=addfile(dir1+"ECDA-COBALT_dT_dt_100-300_advection_199001-201712.nc","r")
Tt_prime=m->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f})

dim1=dimsizes(u_bar_T_prime)
T_seperated=new((/7,dim1(0),dim1(1),dim1(2)/),"float")
T_seperated(0,:,:,:)=u_bar_T_prime
T_seperated(1,:,:,:)=u_prime_T_bar
T_seperated(2,:,:,:)=v_bar_T_prime
T_seperated(3,:,:,:)=v_prime_T_bar
T_seperated(4,:,:,:)=w_bar_T_prime
T_seperated(5,:,:,:)=w_prime_T_bar
T_seperated(6,:,:,:)=Tt_prime
copy_VarCoords(u_bar_T_prime,T_seperated(0,:,:,:))
T_seperated!0="variables"
T_seperated1=dim_avg_n_Wrap(T_seperated,2)
T_seperated2=dim_avg_n_Wrap(T_seperated1,2)
T_seperated2=T_seperated2*60*60*24*30
T_seperated2 := T_seperated2(time|:,variables|:)
T_seperated3=month_to_annual(T_seperated2,1)
T_seperated3 := T_seperated3(variables|:,year|:)
;-----------------------------------------------------------------------------
dim2=dimsizes(T_seperated3)
T_test=new((/dim2(0)-1,dim2(1)/),"float")
T_test=T_seperated3(0:dim2(0)-2,:)
T_test2=dim_sum_n_Wrap(T_test,0); Sum 

T_bio=T_seperated3(6,:)-T_test2
T_bio!0="year"
;-----------------------------------------------------------------------------
T_plot=new((/9,dim2(1)/),"float")
T_plot(0:6,:)=T_seperated3
T_plot(7,:)=T_test2
T_plot(8,:)=T_bio

x=ispan(1990,2017,1)

 wks=gsn_open_wks("x11",dir2+"Temperature_budget_seperated_annual_timeseries_1990-2017")
 plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@gsnPaperOrientation =       "portrait"
 res@gsnYRefLine         =       0
 res@gsnYRefLineThicknessF       =       3.0
 res@gsnYRefLineDashPattern      =       2

 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.4            ; make plot as large as possible.
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 ;res@trYMinF       =  -1 
 ;res@trYMaxF       =   1
 ;res@trYMinF       =  -1.5 
 ;res@trYMaxF       =   1.5
; res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=0.5
 res@tmYLTickStartF=1.0
 res@xyLineColors   =   (/"red","magenta","blue","cyan","green","gold","black","purple","gray50"/)
 ;res@xyLineColors   =   (/"red","magenta","blue","cyan","green","gold","purple","black"/)
 res@xyLineThicknessF= 5
 res@tiYAxisString       =       "~S~o~N~C / mon"
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 res@xyDashPatterns    =   (/0,0,0,0,0,0,0,0,0/)
 res@trXMinF             =       1990
 res@trXMaxF             =       2017
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2		; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"	; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"	; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,x,T_plot,res)
 
 gres = True
 gres@YPosPercent = 25.
 gres@XPosPercent = 30
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors =(/"red","magenta","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"-Ubar dT*/dx","-U* dTbar/dx","-Vbar dT*/dy"/)
; textres@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 gres1 = True
 gres1@YPosPercent = 25. 
 gres1@XPosPercent = 55 
 gres1@ItemSpacePercent          = 5
 lineres1 = True
 lineres1@lgLineColors =(/"cyan","green","gold","black","purple"/) 
 ;lineres1@lgLineColors = (/"purple"/)
 lineres1@lgLineThicknesses = 4 
 lineres1@LineLengthPercent = 4.
 lineres1@lgDashIndexes            = (/0,0,0,0,0/)
 textres1 = True
 ;textres1@lgLabels = (/"Residual"/)
 textres1@lgLabels = (/"-V* dTbar/dy","-Wbar dT*/dz","-W* dTbar/dz","dT*/dt","Sum"/)
 ;textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)

 gres2 = True
 gres2@YPosPercent = 25. 
 gres2@XPosPercent = 80 
 gres2@ItemSpacePercent          = 5
 lineres2 = True
 lineres2@lgLineColors =(/"gray50"/) 
 ;lineres1@lgLineColors = (/"purple"/)
 lineres2@lgLineThicknesses = 4 
 lineres2@LineLengthPercent = 4.
 lineres2@lgDashIndexes            = (/0/)
 textres2 = True
 textres2@lgLabels = (/"Residual"/)
 ;textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres2@lgPerimOn                = False
 textres2@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres2,lineres2,textres2)

 draw(plot)
 frame(wks)

end
