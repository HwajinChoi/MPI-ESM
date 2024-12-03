begin
dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

;----------------Atmospheric CO2 conc----------------------------------------------------------------------------------
f1=addfile(dir1+"esm-flat10/co2_area_mean_Amon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012.nc","r")
flat10_co2=f1->co2(:,0,0,0) ; 1850-2150
fl10_co2_annual=month_to_annual(flat10_co2,1) ; 301

g1=addfile(dir1+"esm-zec/co2_area_mean_Amon_MPI-ESM1-2-LR_esm-flat10_zec_r1i1p1f1_gn_195001-216912.nc","r")
zec_co2=g1->co2(:,0,0,0) ; 1950-2169
zec_co2_annual=month_to_annual(zec_co2,1) ; 220
year=ispan(0,319,1)
CO2=new((/2,320/),"float")
CO2@_FillValue = -999 
CO2(0,0:300)=fl10_co2_annual
CO2(1,100:319)=zec_co2_annual
CO2!0="scenario"
CO2!1="year"
CO2&year=year
CO2 := CO2*10^6
CO2@units="ppm"
;--------------------------------------------------------------------------------------------------
f2=addfile(dir1+"esm-flat10/tas_area_mean_Amon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012.nc","r")
flat10_tas=f2->tas(:,0,0)
fl10_tas_annual=month_to_annual(flat10_tas,1)

g2=addfile(dir1+"esm-zec/tas_area_mean_Amon_MPI-ESM1-2-LR_esm-flat10_zec_r1i1p1f1_gn_195001-216912.nc","r")
zec_tas=g2->tas(:,0,0)
zec_tas_annual=month_to_annual(zec_tas,1)
tas=new((/2,320/),"float")
tas@_FillValue = -999
tas(0,0:300)=fl10_tas_annual
tas(1,100:319)=zec_tas_annual
tas!0="scenario"
tas!1="year"
tas&year=year
;--------------------------------------------------------------------------------------------------
f3=addfile(dir1+"esm-flat10/fgco2_area_sum_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012.nc","r")
flat10_fgco2=f3->fgco2(:,0,0)
fl10_fgco2_annual=month_to_annual(flat10_fgco2,1)

g3=addfile(dir1+"esm-zec/fgco2_area_sum_Omon_MPI-ESM1-2-LR_esm-flat10_zec_r1i1p1f1_gn_195001-216912.nc","r")
zec_fgco2=g3->fgco2(:,0,0)
zec_fgco2_annual=month_to_annual(zec_fgco2,1)
fgco2=new((/2,320/),"float")
fgco2@_FillValue = -999
fgco2(0,0:300)=fl10_fgco2_annual
fgco2(1,100:319)=zec_fgco2_annual
fgco2!0="scenario"
fgco2!1="year"
fgco2&year=year
;fgco2 :=fgco2*((365.25*86400*362*(10)^12)/(10^15))
printMinMax(fgco2,1)
fgco2 :=fgco2*((365.25*86400)/(10^15))
printMinMax(fgco2,1)
exit

wks=gsn_open_wks("x11",dir2+"Atm_CO2_conc_timeseries_1850-2169")
 plot=new(4,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@gsnPaperOrientation =       "portrait"
; res@gsnYRefLine         =       0
; res@gsnYRefLineThicknessF       =       3.0
; res@gsnYRefLineDashPattern      =       2
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.4            ; make plot as large as possible.
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 ;res@trYMinF       =  -1.5 
 ;res@trYMaxF       =   1.5
 ;res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@xyLineColors   = (/"red","blue"/)
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   ""
 res@xyDashPatterns    =   (/0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       320
 res@gsnCenterString="Atm. CO2 Concentration"
 res@trYMinF       =  200
 res@trYMaxF       =  1000 
 res@tiYAxisString       =       "CO2 fluxes into the ocean [PgC/yr]"
; res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2         ; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"      ; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"      ; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,year,CO2,res)
 res@gsnCenterString="2m Temperature"
 res@trYMinF       =  280
 res@trYMaxF       =  300 
 res@tiYAxisString       =       "2m Temperatrue (K)"
 plot(1)=gsn_csm_xy(wks,year,tas,res)
 res@gsnCenterString="2m Temperature"
 res@trYMinF       =  280
 res@trYMaxF       =  300 
 res@tiYAxisString       =       "2m Temperatrue (K)"
 plot(2)=gsn_csm_xy(wks,year,tas,res)
 res@gsnCenterString="2m Temperature"
 res@trYMinF       =  280
 res@trYMaxF       =  300 
 res@tiYAxisString       =       "2m Temperatrue (K)"
 plot(3)=gsn_csm_xy(wks,year,tas,res)

 gres = True
 gres@YPosPercent = 12.
 gres@XPosPercent = 60
 gres@ItemSpacePercent          = 5
 lineres = True
 lineres@lgLineColors =(/"red","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec"/)
; textres@lgLabelFontHeights   =(/0.012,0.012,0.012,0.012/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 3
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)


 draw(plot)
 frame(wks)

end
