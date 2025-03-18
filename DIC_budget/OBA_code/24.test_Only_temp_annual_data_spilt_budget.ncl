begin
dir1="/data/hjchoi/CMI/OBA/data/advection/cal_mk_annual_data/raw/"
dir2="/data/hjchoi/CMI/OBA/data/advection/new/raw/"
dir3="/data/hjchoi/CMI/OBA/code/mk_advection_seperate/cal_mk_annual_data/"
lat_s=-5
lat_f=5
lon_s=210
lon_f=270

f=addfile(dir1+"test_ECDA-COBALT_dT_dt_5-35m_advection_199001-201712.nc","r")
Tt_prime=f->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f});time 28*lat 180*lon 360
time=ispan(1990,2017,1)
Tt_prime=Tt_prime*60*60*24*30
Tt_1=dim_avg_n_Wrap(Tt_prime,1)
Tt_2=dim_avg_n_Wrap(Tt_1,1)
;    Tt_2=-Tt_2
g=addfile(dir2+"test_ECDA-COBALT_dT_dt_5-35m_advection_1990-2017.nc","r")
Tt_prime_mon=g->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f})
Tt_prime_mon=Tt_prime_mon*60*60*24*30
Tt_1_mon=dim_avg_n_Wrap(Tt_prime_mon,1)
Tt_2_mon=dim_avg_n_Wrap(Tt_1_mon,1)
;    Tt_2_mon=-Tt_2_mon
   
h=addfile(dir3+"T_ano_annual_1990-2017.nc","r")
T_ano=h->T_ano(:,{lat_s:lat_f},{lon_s:lon_f})
T_ano1=dim_avg_n_Wrap(T_ano,1)
T_ano2=dim_avg_n_Wrap(T_ano1,1)


wks=gsn_open_wks("x11","./test_only_temp_annual_data_budget")
plot=new(4,graphic)
 res                =   True
 ;res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@gsnYRefLine         =       0
 res@gsnYRefLineThicknessF       =       3.0
 res@gsnYRefLineDashPattern      =       2
 res@xyMarkLineMode     =   "MarkLines"
 res@xyMarkerSizeF      =   0.02
 res@xyMarkers          =   16
 res@xyLineColor   =   "black"
 res@xyLineThicknessF= 3
 res@gsnXRefLine = ispan(1990,2017,5)
 res@gsnXRefLineColor = "black"
 res@gsnXRefLineThicknessF = 2.0
 res@gsnYRefLineDashPattern      =       0
 res@tmYLMode       ="Manual"
 res@trYMinF    =-0.15
 res@trYMaxF    =0.15
 res@trXMinF             =       1990
 res@trXMaxF             =       2017
 res@tiMainString       =   "Annual data - Temp budget"
 plot(0)=gsn_csm_xy(wks,time,Tt_2,res)
 plot(2)=gsn_csm_xy(wks,time,Tt_2,res)
 res@trYMinF    =-0.5
 res@trYMaxF    =0.5
 res@tiMainString       =   "Monthly data - Temp budget"
 plot(1)=gsn_csm_xy(wks,time,Tt_2_mon,res)
 res@trYMinF    =-2.
 res@trYMaxF    =2.
 res@tiMainString       =   "Annual Temp anomaly"
 plot(3)=gsn_csm_xy(wks,time,T_ano2,res)

 Pres                    =       True
 Pres@gsnMaximize        =      False
 Pres@gsnFrame          = False
 Pres@gsnPanelYWhiteSpacePercent       =       5
 gsn_panel(wks,plot,(/2,2/),Pres)
 frame(wks)

end
