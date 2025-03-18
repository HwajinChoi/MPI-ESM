begin
dir1="/data/hjchoi/CMI/OBA/data/"
dir2="/data/hjchoi/CMI/OBA/data/advection/"
;-------------------------Constant-------------------------
t=60*60*24*30
re=6370000
pi=3.141592
rad  = 4.0*atan(1.0)/180.
;-----------------------------------------------------------------------------------------
N=asciiread("/data/hjchoi/CMI/OBA/data/st_ocean",-1,"string")
f1=addfile("/data/hjchoi/CMI/OBA/data/spilt_levels/temp_"+N(0)+"m_COBALT.199001-201712.nc","r")
temp=f1->temp(:,0,{-5:5},{210:270}) ;time*yt_ocean*xt_ocean
time=f1->time

lat=f1->yt_ocean;-89.5 - 89.5
xt_ocean=f1->xt_ocean;0-359
yt_ocean=f1->yt_ocean({-5:5});-89.5 - 89.5

;clat=cos(rad*lat)
;clat := dble2flt(clat)
;copy_VarCoords(lat,clat)

T=temp;time*lat*lon
dim=dimsizes(T);time*lat*lon
x=ispan(1990,2017,1)

rad  = 4.0*atan(1.0)/180.
clat=cos(rad*yt_ocean)
;-----------------------------------------------------------------------------------------
T_clim_12=clmMonTLL(T)
T_ano=calcMonAnomTLL(T,T_clim_12)
T_ano_djf=month_to_season(T_ano,"DJF")
T_ano_djf_1=dim_avg_n_Wrap(T_ano_djf,1)
T_ano_djf_2=dim_avg_n_Wrap(T_ano_djf_1,1)
T_clim=new((/dim(0),dim(1),dim(2)/),"float")

    do m =0,dim(0)/12-1
        T_clim(12*m:12*m+11,:,:)=T_clim_12(:,:,:)
    end do

T_ano_test=T-T_clim
copy_VarCoords(T,T_ano_test)
T_ano_test_djf=month_to_season(T_ano_test,"DJF")
T_ano_test_djf_1=dim_avg_n_Wrap(T_ano_test_djf,1)
T_ano_test_djf_2=dim_avg_n_Wrap(T_ano_test_djf_1,1)

T_ano_area_averaged=wgt_areaave_Wrap(T_ano_djf,clat,1.0,1);depth*time

 wks=gsn_open_wks("x11","./imsi")
 plot=new(2,graphic)
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
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=0.5
 res@tmYLTickStartF=1.0
 res@tiYAxisString       =       "~S~o~N~C"
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 ;res@tiMainString       =   "Nino3_DJF_Temperature (5-25m | 150W-90W, 5S-5N)"
 res@trXMinF             =       1990
 res@trXMaxF             =       2017
 plot(0)=gsn_csm_xy(wks,x,T_ano_djf_2,res)
 plot(1)=gsn_csm_xy(wks,x,T_ano_test_djf_2,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 5 
 pres@gsnPanelXWhiteSpacePercent = 3 
 pres@lbLabelFontHeightF  = 0.010
 pres@lbLabelStride     =   2   
 pres@gsnPanelMainString = "Nino3_DJF_Temperature (5-25m | 150W-90W, 5S-5N)"

 gsn_panel(wks,plot,(/2,1/),pres)
 frame(wks)

end
