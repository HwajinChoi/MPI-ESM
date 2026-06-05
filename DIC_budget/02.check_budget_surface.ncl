begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

A=100
B=120

f=addfile(dir0+"flat10_cdr_budget_tsco212_sosi_terms_6m_186001_186912.nc","r")
g=addfile(dir0+"flat10_cdr_budget_tsco212nat_sosi_terms_6m_186001_186912.nc","r")

tot_sosi=f->tsco212_sosi(:,0,A,B)
tot_gas=f->tsco212_gasex(:,0,A,B)
tot_dissol=f->tsco212_dissol(:,0,A,B)
tot_bio=f->tsco212_biol(:,0,A,B)
tot_aere=f->tsco212_aeremin(:,0,A,B)
tot_anre=f->tsco212_anremin(:,0,A,B)
tot_sulf=f->tsco212_sulfred(:,0,A,B)

nat_sosi=g->tsco212nat_sosi(:,0,A,B)
nat_gas=g->tsco212nat_gasex(:,0,A,B)
nat_dissol=g->tsco212nat_dissol(:,0,A,B)
nat_bio=g->tsco212nat_biol(:,0,A,B)
nat_aere=g->tsco212nat_aeremin(:,0,A,B)
nat_anre=g->tsco212nat_anremin(:,0,A,B)
nat_sulf=g->tsco212nat_sulfred(:,0,A,B)

dim=dimsizes(tot_sosi)
TOT=new((/7,dim(0)/),typeof(tot_sosi))
TOT(0,:)=tot_sosi
TOT(1,:)=tot_gas
TOT(2,:)=tot_dissol
TOT(3,:)=tot_bio
TOT(4,:)=tot_aere
TOT(5,:)=tot_anre
TOT(6,:)=tot_sulf

NAT=new((/7,dim(0)/),typeof(nat_sosi))
NAT(0,:)=nat_sosi
NAT(1,:)=nat_gas
NAT(2,:)=nat_dissol
NAT(3,:)=nat_bio
NAT(4,:)=nat_aere
NAT(5,:)=nat_anre
NAT(6,:)=nat_sulf

year=ispan(1,120,1)
wks=gsn_open_wks("png",dir1+"SOSI_Budget_terms_check_timseries")
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
 res@trXMaxF             =       120

; res@trYMinF             =       -0.5
; res@trYMaxF             =       0.5
 res@tiXAxisString       =       "Simulation years"
 res@tiYAxisString       =       "[ mol m-3 s-1 ]"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.025
 res@gsnCenterStringFontHeightF=0.03
 res@gsnCenterString       =   "DIC~B~tot~N~"
 res@tmYRMinorPerMajor=4
 res@xyLineColors   = (/"black","green","blue","red","magenta","purple","gold"/)
 res@xyDashPatterns   =   (/0,0,0,0,0,0,0/)

 res@gsnLeftStringFontHeightF=0.05
 res@gsnLeftStringOrthogonalPosF=0.06
 res@tmXBLabelFontHeightF = 0.03
 res@tmYLLabelFontHeightF = 0.03
 plot(0)=gsn_csm_xy(wks,year,TOT,res)
 res@gsnCenterString       =   "DIC~B~nat~N~"
 plot(1)=gsn_csm_xy(wks,year,NAT,res)

 gres = True
 gres@YPosPercent = 22.
 gres@XPosPercent = 10
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColors =(/"black","green","blue","red"/)
 lineres@lgLineThicknesses = (/6,6,6,6/)
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/0,0,0,0/)
 textres = True
 textres@lgLabels = (/"Sosi","gasex","dissol","bio"/)
 textres@lgLabelFontHeights   =(/0.025,0.025,0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4

 gres1 = True
 gres1@YPosPercent = 22.
 gres1@XPosPercent = 40
 gres1@ItemSpacePercent          = 8
 lineres1 = True
 lineres1@lgLineColors =(/"magenta","purple","gold"/)
 lineres1@lgLineThicknesses = (/6,6,6/)
 lineres1@LineLengthPercent = 6.
 lineres1@lgDashIndexes            = (/0,0,0/)
 textres1 = True
 textres1@lgLabels = (/"aero","anre","sulfred"/)
 textres1@lgLabelFontHeights   =(/0.025,0.025,0.025/)
 textres1@lgPerimOn                = False
 textres1@lgItemCount              = 4

 gres2 = True
 gres2@YPosPercent = 10.
 gres2@XPosPercent = 70
 gres2@ItemSpacePercent          = 8
 lineres2 = True
 lineres2@lgLineColors =(/"red"/)
 lineres2@lgLineThicknesses = (/6/)
 lineres2@LineLengthPercent = 6.
 lineres2@lgDashIndexes            = (/0/)
 textres2 = True
 textres2@lgLabels = (/"bio"/)
 textres2@lgLabelFontHeights   =(/0.025/)
 textres2@lgPerimOn                = False
 textres2@lgItemCount              = 4

 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 plot(0) = simple_legend(wks,plot(0),gres1,lineres1,textres1)
 plot(1) = simple_legend(wks,plot(1),gres1,lineres1,textres1)

 plot(0) = simple_legend(wks,plot(0),gres2,lineres2,textres2)
 plot(1) = simple_legend(wks,plot(1),gres2,lineres2,textres2)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 4
 gsn_panel(wks,plot,(/2,1/),pres)
 frame(wks)

end
