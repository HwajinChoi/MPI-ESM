begin
;--------------------------------------------
; EQUATOR : 150E-90E (270), 20S-20N
; SP region : 160W-110W, 15S-10S
;--------------------------------------------
dir1="/data/hjchoi/CMI/OBA/data/advection/new/"
dir2="/data/hjchoi/CMI/OBA/image/"
lat_s=-20
lat_f=20
lon_s=150
lon_f=270

g=addfile(dir1+"ECDA-COBALT_dT_dx_100-300m_advection_199001-201712.nc","r")
u_bar_T_prime=g->u_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_T_bar=g->u_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h=addfile(dir1+"ECDA-COBALT_dT_dy_100-300m_advection_199001-201712.nc","r")
v_bar_T_prime=h->v_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_T_bar=h->v_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k=addfile(dir1+"ECDA-COBALT_dT_dz_100-300m_advection_199001-201712.nc","r")
w_bar_T_prime=k->w_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
w_prime_T_bar=k->w_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

m=addfile(dir1+"ECDA-COBALT_dT_dt_100-300m_advection_199001-201712.nc","r")
Tt_prime=m->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f})

lateral=u_bar_T_prime+u_prime_T_bar+v_bar_T_prime+v_prime_T_bar
vertical=w_bar_T_prime+w_prime_T_bar
copy_VarCoords(v_prime_T_bar,lateral)
copy_VarCoords(v_prime_T_bar,vertical)

dim1=dimsizes(u_bar_T_prime)
T_seperated=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
T_seperated(0,:,:,:)=lateral
T_seperated(1,:,:,:)=vertical
T_seperated(2,:,:,:)=Tt_prime
copy_VarCoords(u_bar_T_prime,T_seperated(0,:,:,:))
T_seperated!0="variables"
T_seperated1=dim_avg_n_Wrap(T_seperated,2)
T_seperated2=dim_avg_n_Wrap(T_seperated1,2)
T_seperated2=T_seperated2*60*60*24*30
T_seperated2 := T_seperated2(time|:,variables|:)
T_seperated3=month_to_annual(T_seperated2,1)
T_seperated3 := T_seperated3(variables|:,year|:)

dim2=dimsizes(T_seperated3)
T_test=new((/dim2(0)-1,dim2(1)/),"float")
T_test=T_seperated3(0:dim2(0)-2,:)
T_test2=dim_sum_n_Wrap(T_test,0); Sum
T_bio=T_seperated3(2,:)-T_test2

;-------------------------------------------------------------------------------
g1=addfile(dir1+"LT_1_dT_dx_100-300m_advection_199101-201712.nc","r")
u_bar_T_prime1=g1->u_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_T_bar1=g1->u_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h1=addfile(dir1+"LT_1_dT_dy_100-300m_advection_199101-201712.nc","r")
v_bar_T_prime1=h1->v_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_T_bar1=h1->v_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k1=addfile(dir1+"LT_1_dT_dz_100-300m_advection_199101-201712.nc","r")
w_bar_T_prime1=k1->w_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
w_prime_T_bar1=k1->w_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

m1=addfile(dir1+"LT_1_dT_dt_100-300m_advection_199101-201712.nc","r")
Tt_prime1=m1->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f})
Tt_prime1!0="time"

lateral1=u_bar_T_prime1+u_prime_T_bar1+v_bar_T_prime1+v_prime_T_bar1
vertical1=w_bar_T_prime1+w_prime_T_bar1
copy_VarCoords(v_prime_T_bar1,lateral1)
copy_VarCoords(v_prime_T_bar1,vertical1)

dim1_LT1=dimsizes(u_bar_T_prime1)

T_seperated_LT1=new((/3,dim1_LT1(0),dim1_LT1(1),dim1_LT1(2)/),"float")
T_seperated_LT1(0,:,:,:)=lateral1
T_seperated_LT1(1,:,:,:)=vertical1
T_seperated_LT1(2,:,:,:)=Tt_prime1
copy_VarCoords(u_bar_T_prime1,T_seperated_LT1(0,:,:,:))
T_seperated_LT1!0="variables"
T_seperated1_LT1=dim_avg_n_Wrap(T_seperated_LT1,2)
T_seperated2_LT1=dim_avg_n_Wrap(T_seperated1_LT1,2)
T_seperated2_LT1=T_seperated2_LT1*60*60*24*30
T_seperated2_LT1 := T_seperated2_LT1(time|:,variables|:)
T_seperated3_LT1=month_to_annual(T_seperated2_LT1,1)
T_seperated3_LT1 := T_seperated3_LT1(variables|:,year|:)

dim2_LT1=dimsizes(T_seperated3_LT1)
T_test_LT1=new((/dim2_LT1(0)-1,dim2_LT1(1)/),"float")
T_test_LT1=T_seperated3_LT1(0:dim2_LT1(0)-2,:)
T_test2_LT1=dim_sum_n_Wrap(T_test_LT1,0); Sum
T_bio_LT1=T_seperated3_LT1(2,:)-T_test2_LT1
;-------------------------------------------------------------------------------
g2=addfile(dir1+"LT_2_dT_dx_100-300m_advection_199201-201712.nc","r")
u_bar_T_prime2=g2->u_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_T_bar2=g2->u_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h2=addfile(dir1+"LT_2_dT_dy_100-300m_advection_199201-201712.nc","r")
v_bar_T_prime2=h2->v_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_T_bar2=h2->v_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k2=addfile(dir1+"LT_2_dT_dz_100-300m_advection_199201-201712.nc","r")
w_bar_T_prime2=k2->w_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
w_prime_T_bar2=k2->w_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

m2=addfile(dir1+"LT_2_dT_dt_100-300m_advection_199201-201712.nc","r")
Tt_prime2=m2->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f})
Tt_prime2!0="time"

lateral2=u_bar_T_prime2+u_prime_T_bar2+v_bar_T_prime2+v_prime_T_bar2
vertical2=w_bar_T_prime2+w_prime_T_bar2
copy_VarCoords(v_prime_T_bar2,lateral2)
copy_VarCoords(v_prime_T_bar2,vertical2)

dim1_LT2=dimsizes(u_bar_T_prime2)
T_seperated_LT2=new((/3,dim1_LT2(0),dim1_LT2(1),dim1_LT2(2)/),"float")
T_seperated_LT2(0,:,:,:)=lateral2
T_seperated_LT2(1,:,:,:)=vertical2
T_seperated_LT2(2,:,:,:)=Tt_prime2
copy_VarCoords(u_bar_T_prime2,T_seperated_LT2(0,:,:,:))
T_seperated_LT2!0="variables"
T_seperated1_LT2=dim_avg_n_Wrap(T_seperated_LT2,2)
T_seperated2_LT2=dim_avg_n_Wrap(T_seperated1_LT2,2)
T_seperated2_LT2=T_seperated2_LT2*60*60*24*30
T_seperated2_LT2 := T_seperated2_LT2(time|:,variables|:)
T_seperated3_LT2=month_to_annual(T_seperated2_LT2,1)
T_seperated3_LT2 := T_seperated3_LT2(variables|:,year|:)

dim2_LT2=dimsizes(T_seperated3_LT2)
T_test_LT2=new((/dim2_LT2(0)-1,dim2_LT2(1)/),"float")
T_test_LT2=T_seperated3_LT2(0:dim2_LT2(0)-2,:)
T_test2_LT2=dim_sum_n_Wrap(T_test_LT2,0); Sum
T_bio_LT2=T_seperated3_LT2(2,:)-T_test2_LT2
;-----------------------------------------------------------------------------
corr_LT1=escorc(T_seperated3(:,1:27),T_seperated3_LT1(:,:))
corr_LT2=escorc(T_seperated3(:,2:27),T_seperated3_LT2(:,:))
corr_bio_LT1=escorc(T_bio(1:27),T_bio_LT1)
corr_bio_LT2=escorc(T_bio(2:27),T_bio_LT2)
;    exit
B=new((/3,28/),"float")
B(0,:)=T_bio
B(1,1:27)=T_bio_LT1
B(2,2:27)=T_bio_LT2
B!0="variable"

T=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
T(0,:,:,:)=Tt_prime
T(1,12:335,:,:)=Tt_prime1
T(2,24:335,:,:)=Tt_prime2
T!0="variable"
T1=dim_avg_n_Wrap(T,2)
T2=dim_avg_n_Wrap(T1,2)
T2 := T2(time|:,variable|:)
T3=month_to_annual(T2,1)
T3 := T3(variable|:,year|:)

U=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
U(0,:,:,:)=lateral
U(1,12:335,:,:)=lateral1
U(2,24:335,:,:)=lateral2
U!0="variable"
U1=dim_avg_n_Wrap(U,2)
U2=dim_avg_n_Wrap(U1,2)
U2 := U2(time|:,variable|:)
U3=month_to_annual(U2,1)
U3 := U3(variable|:,year|:)

W=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
W(0,:,:,:)=vertical
W(1,12:335,:,:)=vertical1
W(2,24:335,:,:)=vertical2
W!0="variable"
W1=dim_avg_n_Wrap(W,2)
W2=dim_avg_n_Wrap(W1,2)
W2 := W2(time|:,variable|:)
W3=month_to_annual(W2,1)
W3 := W3(variable|:,year|:)
;print(W3(0,:))
;    exit

T3=T3*60*60*24*30
U3=U3*60*60*24*30
W3=W3*60*60*24*30

x=ispan(1990,2017,1)
 
 wks=gsn_open_wks("x11",dir2+"3COMPONENTS_spilt_LTs_Temp_budget_seperated_annual_timeseries_1990-2017")
 plot=new(4,graphic)
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
 res@xyLineColors   =   (/"black","red","blue"/)
 res@xyDashPatterns    =   (/0,0,0/)
 res@xyLineThicknessF= 3
 res@tiYAxisString       =       " ~S~o~N~C / mon"
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@trXMinF             =       1990
 res@trXMaxF             =       2017
 res@gsnCenterString    =   "dT*/dt"
 res@gsnCenterStringFontHeightF=0.027
 res@gsnCenterStringOrthogonalPosF=0.05
 plot(0)=gsn_csm_xy(wks,x,T3,res)
 
 res@gsnCenterString    =   "Residual"
 plot(3)=gsn_csm_xy(wks,x,B,res)
 gres = True
 gres@YPosPercent = 95.
 gres@XPosPercent = 2
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors =(/"black","red","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"ECDA-COBALT","LT=1","LT=2"/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

 delete(res@xyLineColors)
 delete(res@xyDashPatterns)
 res@xyLineColors   =   (/"black","red","blue"/)
 res@xyDashPatterns    =   (/0,0,0/)
 res@gsnCenterString    =   "Lateral"
 plot(1)=gsn_csm_xy(wks,x,U3,res)
 res@gsnCenterString    =   "Vertical"
 plot(2)=gsn_csm_xy(wks,x,W3,res)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 gres@YPosPercent = 95.
 gres@XPosPercent = 72
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)

;print("corr_LT1 ; Lateral = "+corr_LT1(0))
;print("corr_LT1 ; Vertical = "+corr_LT1(1))
;print("corr_LT1 ; Tt_prime = "+corr_LT1(2))

;print("corr_LT2 ; Lateral = "+corr_LT2(0))
;print("corr_LT2 ; Vertical = "+corr_LT2(1))
;print("corr_LT2 ; Tt_prime = "+corr_LT2(2))

;print("corr_LT1 ; Residual = "+corr_bio_LT1)
;print("corr_LT2 ; Residual = "+corr_bio_LT2)
;exit

 txres1               = True
 txres1@txFontHeightF = 0.01
 gsn_text_ndc(wks, "R(LT=1) ="+sprintf("%1.2f",corr_LT1(2))+"*",0.32, 0.55, txres1);dT/dt
 gsn_text_ndc(wks, "R(LT=2) ="+sprintf("%1.2f",corr_LT2(2)),0.42, 0.55, txres1)

 gsn_text_ndc(wks, "R(LT=1) ="+sprintf("%1.2f",corr_LT1(0))+"*",0.82, 0.55, txres1);Lateral
 gsn_text_ndc(wks, "R(LT=2) ="+sprintf("%1.2f",corr_LT2(0))+"*",0.92, 0.55, txres1)

 gsn_text_ndc(wks, "R(LT=1) ="+sprintf("%1.2f",corr_LT1(1))+"*",0.32, 0.24, txres1);Vertical
 gsn_text_ndc(wks, "R(LT=2) ="+sprintf("%1.2f",corr_LT2(1)),0.42, 0.24, txres1)

 gsn_text_ndc(wks, "R(LT=1) ="+sprintf("%1.2f",corr_bio_LT1)+"*",0.82, 0.24, txres1);residual
 gsn_text_ndc(wks, "R(LT=2) ="+sprintf("%1.2f",corr_bio_LT2),0.92, 0.24, txres1)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@gsnPanelXWhiteSpacePercent = 3
 pres@gsnPanelRowSpec = True
 pres@lbLabelFontHeightF  = 0.010
 pres@lbLabelStride     =   2
 pres@gsnPanelMainString = "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"

 gsn_panel(wks,plot,(/2,2/),pres)
 frame(wks)

end
