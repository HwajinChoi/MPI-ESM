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
f3=addfile(dir1+"esm-flat10/fgco2_fldsum_units_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012.nc","r")
flat10_fgco2=f3->fgco2(:,0,0)

g3=addfile(dir1+"esm-zec/fgco2_fldsum_units_Omon_MPI-ESM1-2-LR_esm-flat10_zec_r1i1p1f1_gn_195001-216912.nc","r")
zec_fgco2=g3->fgco2(:,0,0)
fgco2=new((/2,320/),"float")
fgco2@_FillValue = -999
fgco2(0,0:300)=flat10_fgco2
fgco2(1,100:319)=zec_fgco2
fgco2!0="scenario"
fgco2!1="year"
fgco2&year=year
;--------------------------------------------------------------------------------------------------
f4=addfile(dir1+"esm-flat10/nbp_fldsum_units_Lmon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012.nc","r")
flat10_nbp=f4->nbp(:,0,0)

g4=addfile(dir1+"esm-zec/nbp_fldsum_units_Lmon_MPI-ESM1-2-LR_esm-flat10_zec_r1i1p1f1_gn_195001-216912.nc","r")
zec_nbp=g4->nbp(:,0,0)
nbp=new((/2,320/),"float")
nbp@_FillValue = -999
nbp(0,0:300)=flat10_nbp
nbp(1,100:319)=zec_nbp
nbp!0="scenario"
nbp!1="year"
nbp&year=year

;printMinMax(fgco2,1)
;printMinMax(nbp,1)
;exit

wks=gsn_open_wks("png",dir2+"Atm_CO2_tas_co2_fluxes_conc_timeseries_0-320")
 plot=new(4,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.6            ; Change the aspect ratio, but 
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
 res@xyLineColors   = (/"grey40","darkorange"/)
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   ""
 res@xyDashPatterns    =   (/0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       320
 res@gsnCenterString="(a) Atm. CO~B~2~N~ Concentration"
 res@gsnCenterStringFontHeightF=0.022
 res@trYMinF       =  200.
 res@trYMaxF       =  1000. 
 res@tiYAxisString       =       "ppm"
 res@gsnCenterStringOrthogonalPosF=0.06
; res@tiMainString       =   "Temperature Advection Budget(100-300m | 150E-90W, 20S-20N)"
 ;res@tmXBTickStartF=1990
 ;res@tmXBTickSpacingF=5
 ;res@tmXBPrecision = 2         ; set the precision to 2 significant digits
; res@tmYLFormat = "#+^se"      ; don't use "e" symbol, always show +/-
; res@tmYLFormat = "0*+^e"      ; use "e" symbol, don't force 0's (see documentation)
 plot(0)=gsn_csm_xy(wks,year,CO2,res)
 res@gsnCenterString="(b) 2m Temperature"
 res@trYMinF       =  285.
 res@trYMaxF       =  292.
 res@tiYAxisString       =       "K"
 plot(1)=gsn_csm_xy(wks,year,tas,res)
 res@gsnCenterString="(c) Global Air-Sea CO~B~2~N~ flux"
 res@trYMinF       =  -0.5
 res@trYMaxF       =  4 
 res@tiYAxisString       =       "PgC/yr"
 res@gsnYRefLine         =       0
 res@gsnYRefLineThicknessF       =       3.0
 res@gsnYRefLineDashPattern      =       2
 plot(2)=gsn_csm_xy(wks,year,fgco2,res)
 res@gsnCenterString="(d) Global Air-Land CO~B~2~N~ flux"
 res@trYMinF       = -3 
 res@trYMaxF       =  8
 res@tiYAxisString       =      "PgC/yr"
 plot(3)=gsn_csm_xy(wks,year,nbp,res)

 gres = True
 gres@YPosPercent = 94.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec"/)
 textres@lgLabelFontHeights   =(/0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 gres@YPosPercent = 94.
 gres@XPosPercent = 63
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/2,2/),pres)

 frame(wks)

end
