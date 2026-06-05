begin
;--------------------------------------------
; EQUATOR : 150-270E, 20S-20N
;--------------------------------------------
dir1="/data/hjchoi/CMI/OBA/data/advection/"
dir2="/data/hjchoi/CMI/OBA/image/"
f=addfile(dir1+"ECDA-COBALT_Oxygern_budget_advection_199001-201712.nc","r")

Ot=f->Ot(:,{-20:20},{150:270}) ; time, yt_ocean, xt_ocean
Ox=f->Ox(:,{-20:20},{150:270})
Oy=f->Oy(:,{-20:20},{150:270})
Oz=f->Oz(:,{-20:20},{150:270})
lat=f->yt_ocean
lon=f->xt_ocean
time=f->time

Ot := clmMonTLL(Ot)
Ox := clmMonTLL(Ox)
Oy := clmMonTLL(Oy)
Oz := clmMonTLL(Oz)

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

;x=ispan(1990,2017,1)
x1=ispan(0,11,1)

 wks=gsn_open_wks("x11",dir2+"Oxygen_budget_monthly_climatology_1990-2017")
 plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@gsnPaperOrientation =       "portrait"
 res@gsnYRefLine         =       0
 res@gsnYRefLineThicknessF       =       3.0
 res@gsnYRefLineDashPattern      =       2

 res@vpWidthF       = 0.5            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.4            ; make plot as large as possible.
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trYMinF       =  -1.5 
 res@trYMaxF       =   1.5
 res@tmXBMode         = "Explicit"
 res@tmXBValues       = ispan(0,11,1)
 res@tmXBLabels       = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
 res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=0.5
 res@tmYLTickStartF=1.0
 res@xyLineColors   =   (/"black","red","blue","green","purple"/)
 res@xyLineThicknessF= 5
 res@tiYAxisString       =       "~F8~m~F~"+" mol kg -1 / mon"
 res@tiXAxisString       =       "Month"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainString       =   "Oxygen Advection Budget (100-300m)"
 res@xyDashPatterns    =   (/0,0,0,0,0/)
 ;res@trXMinF             =       1990
 ;res@trXMaxF             =       2017
 res@tmXBTickStartF=1
 res@tmXBTickSpacingF=1
 ;res@tmXBPrecision = 2		; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"	; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"	; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,x1,O,res)
 
 gres = True
 gres@YPosPercent = 95.
 gres@XPosPercent = 2
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors = (/"black","red","blue","green"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0,0/)
 textres = True
 textres@lgLabels = (/"dO2/dt","-u*(dO2/dx)","-v*(dO2/dy)","-w*(dO2/dz)"/)
 textres@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 gres1 = True
 gres1@YPosPercent = 95. 
 gres1@XPosPercent = 23 
 gres1@ItemSpacePercent          = 5
 lineres1 = True
 lineres1@lgLineColors = (/"purple"/)
 lineres1@lgLineThicknesses = 4 
 lineres1@LineLengthPercent = 4.
 lineres1@lgDashIndexes            = (/0/)
 textres1 = True
 textres1@lgLabels = (/"Residual"/)
 textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)

 draw(plot)
 frame(wks)

end
