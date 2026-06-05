begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
a=180
b=150

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212_mul_dz_0-1000m_1850_2299.nc","r")
tot1=f->tsco212_tot(:,a,b)
adv1=f->tsco212_adv(:,a,b)
dif1=f->tsco212_dif(:,a,b)
gm1=f->tsco212_gm(:,a,b)
sosi1=f->tsco212_sosi(:,a,b)
surf1=f->tsco212_surf(:,a,b)

g=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_mul_dz_0-1000m_1850_2299.nc","r")
tot2=g->tsco212nat_tot(:,a,b)
adv2=g->tsco212nat_adv(:,a,b)
dif2=g->tsco212nat_dif(:,a,b)
gm2=g->tsco212nat_gm(:,a,b)
sosi2=g->tsco212nat_sosi(:,a,b)
surf2=g->tsco212nat_surf(:,a,b)

TOT=new((/6,450/),typeof(tot1))
TOT(0,:)=tot1
TOT(1,:)=adv1
TOT(2,:)=dif1
TOT(3,:)=gm1
TOT(4,:)=sosi1
TOT(5,:)=surf1
TOT!0="variable"
TOT := TOT*3.78*(10^(-7))

NAT=new((/6,450/),typeof(tot1))
NAT(0,:)=tot2
NAT(1,:)=adv2
NAT(2,:)=dif2
NAT(3,:)=gm2
NAT(4,:)=sosi2
NAT(5,:)=surf2
NAT!0="variable"
NAT := NAT*3.78*(10^(-7))

all_tot=dim_sum_n_Wrap(TOT(1:5,:),0)
all_without_surf_tot=dim_sum_n_Wrap(TOT(1:4,:),0)
diff_tot=TOT(0,:)-all_tot
diff_without_surf_tot=TOT(0,:)-all_without_surf_tot

DIFF_tot=new((/2,450/),typeof(tot1))
DIFF_tot(0,:)=diff_tot
DIFF_tot(1,:)=diff_without_surf_tot

all_nat=dim_sum_n_Wrap(NAT(1:5,:),0)
all_without_surf_nat=dim_sum_n_Wrap(NAT(1:4,:),0)
diff_nat=NAT(0,:)-all_nat
diff_without_surf_nat=NAT(0,:)-all_without_surf_nat

DIFF_nat=new((/2,450/),typeof(tot1))
DIFF_nat(0,:)=diff_nat
DIFF_nat(1,:)=diff_without_surf_nat
printMinMax(DIFF_tot(0,:),0)
;printMinMax(DIFF_nat,0)
;exit

year=ispan(1,450,1)
wks=gsn_open_wks("png",dir1+"Budget_terms_timseries_Test")
plot=new(2,graphic)
 res                =   True
 res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.4
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trXMinF             =       0
 res@trXMaxF             =       450

; res@trYMinF             =       -0.5
; res@trYMaxF             =       0.5
 res@tiXAxisString       =       "Simulation years"
 res@tiYAxisString       =       "[ PgC/s ]"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.04
 res@tiMainString       =   "Diff_check_DIC~B~tot~N~"
 res@tmYRMinorPerMajor=4
 res@xyLineColors   = (/"green","purple"/)
 res@xyDashPatterns   =   (/0,0/)

 res@gsnLeftStringFontHeightF=0.05
 res@gsnLeftStringOrthogonalPosF=0.06
 res@tmXBLabelFontHeightF = 0.03
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@gsnXRefLine=150.
 res@gsnXRefLineDashPattern=1
 res@gsnYRefLineThicknessF=4
 res@gsnXRefLineThicknessF=4
 res@tmYLLabelFontHeightF = 0.03
 plot(0)=gsn_csm_xy(wks,year,DIFF_tot,res)
 res@tiMainString       =   "Diff_check_DIC~B~nat~N~"
 plot(1)=gsn_csm_xy(wks,year,DIFF_nat,res)

 gres = True
 gres@YPosPercent = 22.
 gres@XPosPercent = 42
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColors =(/"green","purple"/)
 lineres@lgLineThicknesses = (/6,6/)
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"diff","diff_without_Surf"/)
 textres@lgLabelFontHeights   =(/0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4

 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 4
 gsn_panel(wks,plot,(/2,1/),pres)
 frame(wks)

end
