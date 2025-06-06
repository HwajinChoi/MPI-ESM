begin
;--------------------------------------------
; EQUATOR : 150E-90E (270), 20S-20N
; SP region : 160W-110W, 15S-10S
;--------------------------------------------
dir1="/data/hjchoi/CMI/OBA/data/advection/"
dir2="/data/hjchoi/CMI/OBA/image/"
f=addfile(dir1+"ECDA-COBALT_Oxygern_budget_advection_199001-201712.nc","r")
lat_s=-20
lat_f=20
lon_s=150
lon_f=270

Ot=f->Ot(:,{lat_s:lat_f},{lon_s:lon_f}) ; time, yt_ocean, xt_ocean
Ox=f->Ox(:,{lat_s:lat_f},{lon_s:lon_f})
Oy=f->Oy(:,{lat_s:lat_f},{lon_s:lon_f})
Oz=f->Oz(:,{lat_s:lat_f},{lon_s:lon_f})
lat=f->yt_ocean
lon=f->xt_ocean
Ot := month_to_annual(Ot,1)
Ox := month_to_annual(Ox,1)
Oy := month_to_annual(Oy,1)
Oz := month_to_annual(Oz,1)

Ot1=dim_avg_n_Wrap(Ot,1)
Ot2=dim_avg_n_Wrap(Ot1,1)
Ox1=dim_avg_n_Wrap(Ox,1)
Ox2=dim_avg_n_Wrap(Ox1,1)
Oy1=dim_avg_n_Wrap(Oy,1)
Oy2=dim_avg_n_Wrap(Oy1,1)
Oz1=dim_avg_n_Wrap(Oz,1)
Oz2=dim_avg_n_Wrap(Oz1,1)

dim=dimsizes(Ot1)
O=new((/5,dim(0)/),"float")
O(0,:)=Ot2
O(1,:)=Ox2
O(2,:)=Oy2
O(3,:)=Oz2
O(4,:)=Ot2-(Oz2+Ox2+Oy2)
O!0="variables"
O=O*60*60*24*30

g=addfile(dir1+"ECDA-COBALT_dO_dx_100-300_advection_199001-201712.nc","r")
u_bar_O_prime=g->u_bar_O_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_O_bar=g->u_prime_O_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h=addfile(dir1+"ECDA-COBALT_dO_dy_100-300_advection_199001-201712.nc","r")
v_bar_O_prime=h->v_bar_O_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_O_bar=h->v_prime_O_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k=addfile(dir1+"ECDA-COBALT_dO_dz_all_depth_advection_199001-201712.nc","r")
w_bar_O_prime=k->w_bar_O_prime(:,{lat_s:lat_f},{lon_s:lon_f},1)
w_prime_O_bar=k->w_prime_O_bar(:,{lat_s:lat_f},{lon_s:lon_f},1)

m=addfile(dir1+"ECDA-COBALT_dO_dt_100-300_advection_199001-201712.nc","r")
Ot_prime=m->Ot_prime(:,{lat_s:lat_f},{lon_s:lon_f})

dim1=dimsizes(u_bar_O_prime)
O_seperated=new((/7,dim1(0),dim1(1),dim1(2)/),"float")
O_seperated(0,:,:,:)=u_bar_O_prime
O_seperated(1,:,:,:)=u_prime_O_bar
O_seperated(2,:,:,:)=v_bar_O_prime
O_seperated(3,:,:,:)=v_prime_O_bar
O_seperated(4,:,:,:)=w_bar_O_prime
O_seperated(5,:,:,:)=w_prime_O_bar
O_seperated(6,:,:,:)=Ot_prime
copy_VarCoords(u_bar_O_prime,O_seperated(0,:,:,:))
O_seperated!0="variables"
O_seperated1=dim_avg_n_Wrap(O_seperated,2)
O_seperated2=dim_avg_n_Wrap(O_seperated1,2)
O_seperated2=O_seperated2*60*60*24*30
O_seperated2 := O_seperated2(time|:,variables|:)
O_seperated3=month_to_annual(O_seperated2,1)
O_seperated3 := O_seperated3(variables|:,year|:)
;-----------------------------------------------------------------------------
dim2=dimsizes(O_seperated3)
O_test=new((/dim2(0)-1,dim2(1)/),"float")
O_test=O_seperated3(0:dim2(0)-2,:)
O_test2=dim_sum_n_Wrap(O_test,0); Sum 
O_bio=O_seperated3(6,:)-O_test2
;-----------------------------------------------------------------------------
O_plot=new((/9,dim2(1)/),"float")
O_plot(0:6,:)=O_seperated3
O_plot(7,:)=O_test2
O_plot(8,:)=O_bio

corr=new(8,"float")
corr(0:5)=escorc(O_plot(6,:),O_plot(0:5,:))
corr(6)=escorc(O_plot(6,:),O_plot(7,:))
corr(7)=escorc(O_plot(6,:),O_plot(8,:))

;corr_test=escorc(O_plot(0,:),O_plot(1,:))
print(corr)    
    exit

x=ispan(1990,2017,1)

 wks=gsn_open_wks("png",dir2+"Oxygen_budget_seperated_annual_timeseries_1990-2017")
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
 res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=0.5
 res@tmYLTickStartF=1.0
 res@xyLineColors   =   (/"red","magenta","blue","cyan","green","gold","black","purple"/)
 ;res@xyLineColors   =   (/"red","magenta","blue","cyan","green","gold","purple","black"/)
 res@xyLineThicknessF= 5
 res@tiYAxisString       =       "~F8~m~F~"+" mol kg -1 / mon"
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   "Oxygen Advection Budget(100-300m | 150E-90W, 20S-20N)"
 res@xyDashPatterns    =   (/0,0,0,0,0,0,0,0/)
 res@trXMinF             =       1990
 res@trXMaxF             =       2017
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2		; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"	; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"	; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,x,O_plot,res)
 
 gres = True
 gres@YPosPercent = 95.
 gres@XPosPercent = 2
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors =(/"red","magenta","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"Ubar dO*/dx","U* dObar/dx","Vbar dO*/dy"/)
; textres@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 gres1 = True
 gres1@YPosPercent = 95. 
 gres1@XPosPercent = 26 
 gres1@ItemSpacePercent          = 5
 lineres1 = True
 lineres1@lgLineColors =(/"cyan","green","gold","black","purple"/) 
 ;lineres1@lgLineColors = (/"purple"/)
 lineres1@lgLineThicknesses = 4 
 lineres1@LineLengthPercent = 4.
 lineres1@lgDashIndexes            = (/0,0,0,0,0/)
 textres1 = True
 ;textres1@lgLabels = (/"Residual"/)
 textres1@lgLabels = (/"V* dObar/dy","Wbar dO*/dz","W* dObar/dz","dO*/dt","Sum"/)
 ;textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)

 draw(plot)
 frame(wks)

end
