
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212_mul_dz_0-1000m_1850_2299_Nor_Atl.nc","r")
g=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_mul_dz_0-1000m_1850_2299_Nor_Atl.nc","r")

tot=f->tsco212_tot(:,0,0) 
adv=f->tsco212_adv(:,0,0)
dif=f->tsco212_dif(:,0,0)
gm=f->tsco212_gm(:,0,0)
sosi=f->tsco212_sosi(:,0,0)
surf=f->tsco212_surf(:,0,0)

tot_nat=g->tsco212nat_tot(:,0,0) 
adv_nat=g->tsco212nat_adv(:,0,0)
dif_nat=g->tsco212nat_dif(:,0,0)
gm_nat=g->tsco212nat_gm(:,0,0)
sosi_nat=g->tsco212nat_sosi(:,0,0)
surf_nat=g->tsco212nat_surf(:,0,0)

TOT=new((/6,450/),typeof(tot))
TOT(0,:)=tot
TOT(1,:)=adv
TOT(2,:)=dif
TOT(3,:)=gm
TOT(4,:)=sosi
TOT(5,:)=surf

NAT=new((/6,450/),typeof(tot))
NAT(0,:)=tot_nat
NAT(1,:)=adv_nat
NAT(2,:)=dif_nat
NAT(3,:)=gm_nat
NAT(4,:)=sosi_nat
NAT(5,:)=surf_nat

ANT=TOT-NAT
TOT =TOT*3.78*(10^(-7))
NAT =NAT*3.78*(10^(-7))
ANT =ANT*3.78*(10^(-7))
copy_VarCoords(TOT,ANT)

year=ispan(1,450,1)
wks=gsn_open_wks("png",dir1+"Budget_terms_timseries_Nor_Atl")
plot=new(3,graphic)
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

 res@trYMinF             =       -0.5
 res@trYMaxF             =       0.5
 res@tiXAxisString       =       "Simulation years"
 res@tiYAxisString       =       "[ PgC/yr ]"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.04
 res@tiMainString       =   "North Atlantic DIC~B~tot~N~ budget terms"
 res@tmYRMinorPerMajor=4
 res@xyLineColors   = (/"green","blue","red","orange","purple","gold"/)
 res@xyDashPatterns   =   (/0,0,0,0,0,0/)

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
 plot(0)=gsn_csm_xy(wks,year,TOT,res)
 res@tiMainString       =   "North Atlantic DIC~B~nat~N~ budget terms"
 plot(1)=gsn_csm_xy(wks,year,NAT,res)
 res@tiMainString       =   "North Atlantic DIC~B~ant~N~ budget terms"
 plot(2)=gsn_csm_xy(wks,year,ANT,res)

 gres = True
 gres@YPosPercent = 22.
 gres@XPosPercent = 57
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColors =(/"green","blue","red"/)
 lineres@lgLineThicknesses = (/6,6,6/)
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"tend","adv","dif"/)
 textres@lgLabelFontHeights   =(/0.025,0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4

 gres1 = True
 gres1@YPosPercent = 22.
 gres1@XPosPercent = 77
 gres1@ItemSpacePercent          = 8
 lineres1 = True
 lineres1@lgLineColors =(/"orange","purple","gold"/)
 lineres1@lgLineThicknesses = (/6,6,6/)
 lineres1@LineLengthPercent = 6.
 lineres1@lgDashIndexes            = (/0,0,0/)
 textres1 = True
 textres1@lgLabels = (/"GM","so_si","surf"/)
 textres1@lgLabelFontHeights   =(/0.025,0.025,0.025/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 4

 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)

 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)
 plot(1) = simple_legend(wks,plot(1),gres1,lineres1,textres1)
 plot(2) = simple_legend(wks,plot(2),gres1,lineres1,textres1)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 4
 gsn_panel(wks,plot,(/3,1/),pres)
 frame(wks)

end
