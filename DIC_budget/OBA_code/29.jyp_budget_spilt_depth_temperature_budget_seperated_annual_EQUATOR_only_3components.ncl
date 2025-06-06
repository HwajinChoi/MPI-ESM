begin
;--------------------------------------------
; EQUATOR : 150E-90E (270), 20S-20N
; SP region : 160W-110W, 15S-10S
;--------------------------------------------
dir0="/data/hjchoi/CMI/OBA/data/jyp_advections/"
dir2="/data/hjchoi/CMI/OBA/image/"
lat_s=-20
lat_f=20
lon_s=150
lon_f=270

g=addfile(dir0+"new2.temp.madv.100-300m_avg.199001-201712.nc","r")
temp_madv=g->madv(:,{lat_s:lat_f},{lon_s:lon_f})

h=addfile(dir0+"new2.temp.zadv.100-300m_avg.199001-201712.nc","r")
temp_zadv=h->zadv(:,{lat_s:lat_f},{lon_s:lon_f})

k=addfile(dir0+"new.temp.vadv.100-300m_avg.199001-201712.nc","r")
temp_vadv=k->temp_vadv(:,{lat_s:lat_f},{lon_s:lon_f})
temp_vadv := dble2flt(temp_vadv)

m=addfile(dir0+"new2.Dt.dt.100-300m_avg.199001-201712.nc","r")
Dt_dt=m->Dt_dt(:,{lat_s:lat_f},{lon_s:lon_f})

lateral=temp_madv+temp_zadv
vertical=temp_vadv
copy_VarCoords(temp_vadv,lateral)
copy_VarCoords(temp_vadv,vertical)
    printMinMax(lateral,0)
    exit

dim1=dimsizes(temp_vadv)
T_seperated=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
T_seperated(0,:,:,:)=lateral
T_seperated(1,:,:,:)=vertical
T_seperated(2,:,:,:)=Dt_dt
copy_VarCoords(lateral,T_seperated(0,:,:,:))
T_seperated!0="variables"
T_seperated1=dim_avg_n_Wrap(T_seperated,2)
T_seperated2=dim_avg_n_Wrap(T_seperated1,2)
T_seperated2=T_seperated2*60*60*24*30
T_seperated2 := T_seperated2(time|:,variables|:)
T_seperated3=month_to_annual(T_seperated2,1)
T_seperated3 := T_seperated3(variables|:,year|:); variables 3* year 28
;-----------------------------------------------------------------------------
dim2=dimsizes(T_seperated3)
T_test=new((/dim2(0)-1,dim2(1)/),"float")
T_test=T_seperated3(0:dim2(0)-2,:)
T_test2=dim_sum_n_Wrap(T_test,0); Sum 

T_bio=T_seperated3(2,:)-T_test2
T_bio!0="year"
;-----------------------------------------------------------------------------
T_plot=new((/5,dim2(1)/),"float")
T_plot(0:2,:)=T_seperated3
T_plot(3,:)=T_test2
T_plot(4,:)=T_bio
printMinMax(T_plot,0)
    exit

x=ispan(1990,2017,1)

 wks=gsn_open_wks("x11",dir2+"jyp_3components_New_Temperature_budget_seperated_annual_timeseries_1990-2017")
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
 res@xyLineColors   = (/"red","blue","black","purple","gray50"/) 
 ;res@xyLineColors   =   (/"red","magenta","blue","cyan","green","gold","purple","black"/)
 res@xyLineThicknessF= 5
 res@tiYAxisString       =       "~S~o~N~C/ mon"
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 res@xyDashPatterns    =   (/0,0,0,0,0/)
 res@trXMinF             =       1990
 res@trXMaxF             =       2017
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2		; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"	; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"	; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,x,T_plot,res)
 
 gres = True
 gres@YPosPercent = 95.
 gres@XPosPercent = 2
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors =(/"red","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"Lateral","Vertical"/)
; textres@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 gres1 = True
 gres1@YPosPercent = 95. 
 gres1@XPosPercent = 36 
 gres1@ItemSpacePercent          = 5
 lineres1 = True
 lineres1@lgLineColors =(/"black","purple","gray50"/)
 ;lineres1@lgLineColors = (/"purple"/)
 lineres1@lgLineThicknesses = 4 
 lineres1@LineLengthPercent = 4.
 lineres1@lgDashIndexes            = (/0,0,0/)
 textres1 = True
 ;textres1@lgLabels = (/"Residual"/)
 textres1@lgLabels = (/"dT*/dt","Sum","Residual"/)
 ;textres1@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)

 draw(plot)
 frame(wks)

end
