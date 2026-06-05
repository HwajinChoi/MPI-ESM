begin
dir0="/work/uo1451/m301158/MPI-ESM/data/input/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;----------------------------------1,2 Emission & Cumulative emission--------------------
f=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_1849-2298.nc","r")
g=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_zec_1849-2298.nc","r")
h=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_cdr_1849-2298.nc","r")
x=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_nz_1849-2298.nc","r")
y=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_rev_1849-2298.nc","r")

f10=f->carbon_emission(:,0,0)
f10_zec=g->carbon_emission(:,0,0)
f10_cdr=h->carbon_emission(:,0,0)
f10_nz=x->carbon_emission(:,0,0)
f10_rev=y->carbon_emission(:,0,0)

f10_cum=dim_cumsum_Wrap(f10,2)
f10_zec_cum=dim_cumsum_Wrap(f10_zec,2)
f10_cdr_cum=dim_cumsum_Wrap(f10_cdr,2)
f10_nz_cum=dim_cumsum_Wrap(f10_nz,2)
f10_rev_cum=dim_cumsum_Wrap(f10_rev,2)

E=new((/5,450/),typeof(f10))
E(0,:)=f10
E(1,:)=f10_zec
E(2,:)=f10_cdr
E(3,:)=f10_nz
E(4,:)=f10_rev
E!0="Scenarios"

E_cum=new((/5,450/),typeof(f10))
E_cum(0,:)=f10_cum
E_cum(1,:)=f10_zec_cum
E_cum(2,:)=f10_cdr_cum
E_cum(3,:)=f10_nz_cum
E_cum(4,:)=f10_rev_cum
E_cum!0="Scenarios"
year=ispan(1,450,1)

wks=gsn_open_wks("png",dir1+"Test_flat10mip_emission_for_450_with_nz_rev")
 plot=new(2,graphic)
 res                =   True
 res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trYMinF       =  -15 
 res@trYMaxF       =   15
 res@tmYLMode = "Manual"
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@tmYRMinorPerMajor=4
 ;res@tmYLTickSpacingF=1
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyLineColors   = (/"grey40","darkorange","dodgerblue","red","purple"/)
 res@xyDashPatterns    =   (/0,0,0,0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@gsnCenterStringFontHeightF=0.04
 res@gsnCenterStringOrthogonalPosF=0.06
 res@gsnCenterString="(a) Emissions"
 res@tiYAxisString       =       "[PgC/yr]"
 plot(0)=gsn_csm_xy(wks,year,E,res)
 res@gsnCenterString="(b) Cumulative emissions"
 res@trYMinF       =  -500
 res@trYMaxF       =5000
 res@tiYAxisString       =       "[PgC]"
 plot(1)=gsn_csm_xy(wks,year,E_cum,res)

 gres = True
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue","red","purple"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0,0,0/)
 textres = True
 textres@lgLabels = (/"flat10","flat10-zec","flat10-cdr","flat10-nz","flat10-rev"/)
 textres@lgLabelFontHeights   =(/0.03,0.03,0.03,0.03,0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 gres@YPosPercent = 30.
 gres@XPosPercent = 4
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 gres@YPosPercent = 94.
 gres@XPosPercent = 4
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/1,2/),pres)

 frame(wks)

end
