begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/DICs_invent/"
dir2="/work/uo1451/m301158/MPI-ESM/image/Final_figures/"
dir3="/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO/"
f=addfile(dir0+"for_figure1_variables_for_timeseries_for_450years.nc","r")
;-----------------------------
lat="40"
;-----------------------------

T=f->T
;npp=f->npp
AMOC=f->AMOC
dic_inv=f->dic_inv
E=f->E
E_cum=f->E_cum
co2=f->co2
sst=f->sst
OCE=f->OCE
MOC=new((/1,450/),typeof(AMOC))
MOC(0,:)=AMOC(2,:)


colors=(/"deepskyblue","red","gold","green","darkviolet"/)
Labels=(/"Arc","Atl","Ind","Pac","South"/)

h=addfile(dir0+"flat10_cdr_fgco2_18500101-22991231.nc","r")
flt_cdr_ocean=h->fgco2(:,0,0,0)
time=h->time

files2=systemfunc("ls "+dir3+"flat10_cdr_001_dissic_invent_*"+lat+"*_1850-2299.nc"); arc, atl, ind, pac, south
f2=addfiles(files2,"r")
ListSetType(f2,"join")
flt_cdr_org=f2[:]->dissic
carbon_basins=flt_cdr_org(:,:,0,0)

files3=systemfunc("ls "+dir3+"test_pictrl_preform_001_spinup_dissic_invent_*"+lat+"*_8920-8949.nc")
f3=addfiles(files3,"r")
ListSetType(f3,"join")
flt_pi_org=f3[:]->dissic
flt_pi=flt_pi_org(:,:,0,0)

flt_pi_an=dim_avg_n_Wrap(flt_pi,1)
flt_pi_clim=new((/5,450/),typeof(flt_pi_an))

do i=0,450-1
 flt_pi_clim(:,i)=flt_pi_an(:)
end do
copy_VarCoords(carbon_basins,flt_pi_clim)
carbon_basins := carbon_basins-flt_pi_clim
carbon_basins!0="basins"
carbon_basins!1="time"
carbon_basins&time=time
;----------------------------------------------------------------------------------
g1=addfile(dir3+"flat10_cdr_001_dissicnat_invent_nonSO"+lat+"_atl_1850-2299.nc","r")
nat_atl=g1->dissicnat(:,0,0)
nat_atl := nat_atl-flt_pi_clim(1,:)
nat_atl!0="time"
nat_atl&time=time
g2=addfile(dir3+"flat10_cdr_001_dissicnat_invent_nonSO"+lat+"_pac_1850-2299.nc","r")
nat_pac=g2->dissicnat(:,0,0)
nat_pac := nat_pac-flt_pi_clim(3,:)
nat_pac!0="time"
nat_pac&time=time
g3=addfile(dir3+"flat10_cdr_001_dissicnat_invent_SO"+lat+"_1850-2299.nc","r")
nat_SO=g3->dissicnat(:,0,0)
nat_SO := nat_SO-flt_pi_clim(4,:)
nat_SO!0="time"
nat_SO&time=time

g11=addfile(dir3+"flat10_cdr_001_dissicant_invent_nonSO"+lat+"_atl_1850-2299.nc","r")
ant_atl=g11->dissic(:,0,0)
ant_atl!0="time"
ant_atl&time=time
g22=addfile(dir3+"flat10_cdr_001_dissicant_invent_nonSO"+lat+"_pac_1850-2299.nc","r")
ant_pac=g22->dissic(:,0,0)
ant_pac!0="time"
ant_pac&time=time
g33=addfile(dir3+"flat10_cdr_001_dissicant_invent_SO"+lat+"_1850-2299.nc","r")
ant_SO=g33->dissic(:,0,0)
ant_SO!0="time"
ant_SO&time=time

ATL=new((/3,450/),typeof(nat_atl))
ATL(0,:)=carbon_basins(1,:)
ATL(1,:)=nat_atl
ATL(2,:)=ant_atl

PAC=new((/3,450/),typeof(nat_atl))
PAC(0,:)=carbon_basins(3,:)
PAC(1,:)=nat_pac
PAC(2,:)=ant_pac

SO=new((/3,450/),typeof(nat_atl))
SO(0,:)=carbon_basins(4,:)
SO(1,:)=nat_SO
SO(2,:)=ant_SO

T_del=new((/3,450/),"float")
 do i=0,449
  T_del(:,i)=T(:,i)-T(:,0)
 end do
T_del!0="Scenarios"
T_del!1="time"

year=ispan(1,450,1)

wks=gsn_open_wks("png",dir2+"Climate_variabiles_timeseries_450years_with_SO_"+lat)
plot=new(8,graphic)
 res                =   True
 res@gsnMaximize    =   False
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@tiXAxisString       =       "Simulation years"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.04
 res@tiYAxisFontHeightF =0.04
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@tmYRMinorPerMajor=4
 res@xyLineColor   = (/"black"/)
 res@gsnLeftStringFontHeightF=0.05
 res@gsnLeftStringOrthogonalPosF=0.06
 res@tmXBLabelFontHeightF = 0.04
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@tmYLLabelFontHeightF = 0.04
 ;res@trYMinF       =  -1.5 
 ;res@trYMaxF       =   1.5
 ;res@tmYLMode = "Mannual"
 ;res@gsnYRefLine=0.
 ;res@gsnYRefLineDashPattern=1
 ;res@tmYLTickSpacingF=1
 ;res@tmYLTickStartF=-2.0
 resL1=res
 resR1=res
 resL2=res
 resR2=res
 resL1@gsnLeftString="(a) "
 resL1@xyDashPatterns   =   (/0/)
 resL1@trYMinF       =  -15
 resL1@trYMaxF       =  15
 resL1@tiYAxisString       =       "E [PgC/yr]"
 resL1@xyLineColor       =      "black" 
 resR1@xyDashPatterns    =   (/0/)
 resR1@trYMinF       = 200 
 resR1@trYMaxF       =  600
 resR1@tiYAxisString       =       "Atm CO~B~2~N~ [ppm]"
 resR1@xyLineColor       =      "darkorange2" 
 resR1@tiYAxisFontColor="darkorange2"
 resL1@tmXBLabelFontHeightF = 0.04
 resL1@tmYLLabelFontHeightF = 0.04
 resR1@tmYRLabelFontHeightF = 0.04
 plot(0) = gsn_csm_xy2(wks,year,E(2,:),co2(2,:),resL1,resR1)
 res@gsnLeftString="(b) "
 res@xyLineThicknessF= 2
 res@tiYAxisString       =       "SST [~S~o~N~C]"
 plot(1)=gsn_csm_xy(wks,year,sst(2,:),res)
 res@gsnLeftString="(c) "
 res@trYMinF       = 0
 res@trYMaxF       =  1500
 res@trXMinF       = 0
 res@trXMaxF       =  500
 res@xyLineColor="blue"
 res@xyLineThicknessF=6
 res@tiYAxisString       =       "Cumulative E [PgC]"
 res@tiXAxisString       =       "Oceean Carbon Sink [PgC]"
 plot(2)=gsn_csm_xy(wks,OCE(2,:),E_cum(2,:),res)
 res@tiYAxisString       =       "Ocean Carbon Storage [PgC]"
 res@tiXAxisString       =       "Simulation years"
 res@gsnLeftString="(e) "
 res@trXMinF       = 0
 res@trXMaxF       = 450
 delete([/res@xyLineColor/])
 res@trYMinF       = -10
 res@trYMaxF       =  150
 res@xyDashPatterns    =   (/0,0,0,0,0/)
 res@xyLineColors   = colors 
 plot(4)=gsn_csm_xy(wks,year,carbon_basins,res)
 res@xyLineThicknessF=4
 delete([/res@xyDashPatterns,res@xyLineColors/])
 res@trYMaxF       =  160
 res@trYMinF       = -40
 res@xyDashPatterns    =   (/0,16,14/)
 res@xyLineColors   =  (/"black","black","black"/)
 res@gsnLeftString="(f) Pacific"
 plot(5)=gsn_csm_xy(wks,year,PAC,res)
 res@gsnLeftString="(g) Atlantic"
 plot(6)=gsn_csm_xy(wks,year,ATL,res)
 res@gsnLeftString="(h) Southern"
 plot(7)=gsn_csm_xy(wks,year,SO,res)
 delete([/res@trYMaxF,res@trYMinF/])
 res@trYMaxF       =  24.
 res@xyLineThicknessF= 2
 res@trYMinF       = 12.
 res@tiYAxisString       =       "AMOC [Sv]"
 res@gsnLeftString="(d) "
 plot(3)=gsn_csm_xy(wks,year,MOC,res)

 gres = True
 gres@YPosPercent = 94.
 gres@XPosPercent = 38
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColor =(/"black","black"/)
 lineres@lgLineThicknesses = 2
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/2,0/)
 textres = True
 textres@lgLabels = (/"emission","air-sea exchange"/)
 textres@lgLabelFontHeights   =(/0.04,0.04/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
; plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 ;plot(8) = simple_legend(wks,plot(8),gres,lineres,textres)

 gres1=True
 gres1@YPosPercent = 94.
 gres1@XPosPercent = 72
 gres1@ItemSpacePercent=8
 lineres1 = True
 lineres1@lgLineColors = colors
 lineres1@lgLineThicknesses = 4
 lineres1@LineLengthPercent = 6.
 lineres1@lgDashIndexes            = (/0,0,0,0,0/)
 textres1 = True
 textres1@lgLabels =Labels 
 textres1@lgLabelFontHeights   =(/0.04,0.04,0.04,0.04,0.04/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 4
 plot(4) = simple_legend(wks,plot(4),gres1,lineres1,textres1)

 gres1@YPosPercent = 94.
 gres1@XPosPercent = 57
 gres1@ItemSpacePercent=10
 lineres2=True
 lineres2@lgDashIndexes    =   (/0,16,14/)
 lineres2@lgLineColors=  (/"black","black","black"/)
 lineres2@LineLengthPercent = 20.
 lineres2@lgLineThicknesses = 3
 lineres2@lgLineDashSegLens=0.05
 textres2= True
 textres2@lgLabels  =(/"DIC~B~tot~N~","DIC~B~nat~N~","DIC~B~ant~N~"/)
 textres2@lgLabelFontHeights   =(/0.04,0.04,0.04/)
 textres2@lgPerimOn                = False
 textres2@lgItemCount              = 7
 plot(7) = simple_legend(wks,plot(7),gres1,lineres2,textres2)
 plot(5) = simple_legend(wks,plot(5),gres1,lineres2,textres2)
 plot(6) = simple_legend(wks,plot(6),gres1,lineres2,textres2)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/4,2/),pres)

 frame(wks)

end
