begin
;--------------------------------------------
; EQUATOR : 150E-90E (270), 20S-20N
; SP region : 160W-110W, 15S-10S
;--------------------------------------------
dir0="/data/hjchoi/CMI/OBA/data/jeon_advections/"
dir2="/data/hjchoi/CMI/OBA/image/"
lat_s=-10
lat_f=10
lon_s=180
lon_f=210

g=addfile(dir0+"o2_madv_100-300m_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
madv=dble2flt(g->madv(:,{lat_s:lat_f},{lon_s:lon_f}))
;    print(madv)
;    exit
;madv=g->madv(:,{lat_s:lat_f},{lon_s:lon_f})
madv2=where(madv .lt. -0.01 .or. madv .gt. 0.01,madv@_FillValue,madv)

h=addfile(dir0+"o2_vadv_100-300m_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
vadv=dble2flt(h->vadv(:,{lat_s:lat_f},{lon_s:lon_f}))
;vadv=h->vadv(:,{lat_s:lat_f},{lon_s:lon_f})
vadv2=where(vadv .gt. 100,vadv@_FillValue,vadv)

k=addfile(dir0+"o2_zadv_100-300m_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
zadv=dble2flt(k->zadv(:,{lat_s:lat_f},{lon_s:lon_f}))
;zadv=k->zadv(:,{lat_s:lat_f},{lon_s:lon_f})

m=addfile(dir0+"o2_ten_100-300m_ATMassim_10NS_100err_WOA_0.1_2nd.199001-201712.nc","r")
Ot=dble2flt(m->ten(:,{lat_s:lat_f},{lon_s:lon_f}))
;Ot=m->ten(:,{lat_s:lat_f},{lon_s:lon_f})
;    printMinMax(madv2,0)
;    exit
;    print(vadv)
;    printMinMax(zadv,0)
;    printMinMax(Ot,0)
;    exit

dim1=dimsizes(madv)
O_seperated=new((/4,dim1(0),dim1(1),dim1(2)/),"float")
;O_seperated=new((/4,dim1(0),dim1(1),dim1(2)/),"double")
O_seperated(0,:,:,:)=madv2
O_seperated(1,:,:,:)=zadv
O_seperated(2,:,:,:)=vadv2
O_seperated(3,:,:,:)=Ot
copy_VarCoords(madv,O_seperated(0,:,:,:))
O_seperated!0="variables"
O_seperated1=dim_avg_n_Wrap(O_seperated,2)
O_seperated2=dim_avg_n_Wrap(O_seperated1,2)
O_seperated2=O_seperated2*60*60*24*30
;print(O_seperated1(2,:,:))
;printVarSummary(O_seperated1)
O_seperated2 := O_seperated2(time|:,variables|:)
O_seperated3=month_to_annual(O_seperated2,1)
O_seperated3 := O_seperated3(variables|:,year|:)
;O_seperated3=O_seperated3*10^6

;-----------------------------------------------------------------------------
dim2=dimsizes(O_seperated3)
O_test=new((/dim2(0)-1,dim2(1)/),"float")
O_test=O_seperated3(0:dim2(0)-2,:)
O_test2=dim_sum_n_Wrap(O_test,0); Sum 
O_bio=O_seperated3(3,:)-O_test2
O_bio!0="year"
;-----------------------------------------------------------------------------

O_plot=new((/6,dim2(1)/),"float")
O_plot(0:3,:)=O_seperated3
O_plot(4,:)=O_test2
O_plot(5,:)=O_bio
;O_plot=O_plot*60*60*24*30

x=ispan(1990,2017,1)

 wks=gsn_open_wks("png","./Jeon_3COMPONENTS_New_Oxygen_budget_seperated_annual_timeseries_1990-2017")
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
 ;res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=0.5
 res@tmYLTickStartF=1.0
 res@xyLineColors   =   (/"red","blue","green","black","purple","gray50"/)
 ;res@xyLineColors   =   (/"red","magenta","blue","cyan","green","gold","purple","black"/)
 res@xyLineThicknessF= 5
 res@tiYAxisString       =       ""
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   "Oxygen Advection Budget(Jeon, 100-300m | 180-90W, 10S-10N)"
 res@xyDashPatterns    =   (/0,0,0,0,0,0/)
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
 lineres@lgLineColors =(/"red","blue","green"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"Madv","Zadv","Vadv"/)
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
 lineres1@lgLineColors =(/"black","purple","gray50"/) 
 ;lineres1@lgLineColors = (/"purple"/)
 lineres1@lgLineThicknesses = 4 
 lineres1@LineLengthPercent = 4.
 lineres1@lgDashIndexes            = (/0,0,0/)
 textres1 = True
 ;textres1@lgLabels = (/"Residual"/)
 textres1@lgLabels = (/"dO/dt","Sum","Residual"/)
 ;textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)

 draw(plot)
 frame(wks)

end
