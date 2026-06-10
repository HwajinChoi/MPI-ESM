begin
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_timeseries_with_SO/"

f1=addfile(dir3+"flat10_cdr_001_dissic_invent_nonSO40_ind_1850-2299.nc","r")
tot=f1->dissic(:,0,0)
f2=addfile(dir3+"flat10_cdr_001_dissicnat_invent_nonSO40_ind_1850-2299.nc","r")
nat=f2->dissicnat(:,0,0)
f3=addfile(dir3+"flat10_cdr_001_dissicant_invent_nonSO40_ind_1850-2299.nc","r")
ant=f3->dissic(:,0,0)

g1=addfile(dir3+"test_pictrl_preform_001_spinup_dissic_invent_nonSO40_ind_8920-8949.nc","r")
tot_pi=g1->dissic(:,0,0)
pi_an=dim_avg_n_Wrap(tot_pi,0)

tot := tot-pi_an
nat := nat-pi_an
copy_VarCoords(ant,tot)
copy_VarCoords(ant,nat)

year=ispan(1,450,1)

Ind=new((/3,450/),"float")
Ind(0,:)=tot
Ind(1,:)=nat
Ind(2,:)=ant

wks=gsn_open_wks("png",dir2+"Supple_Indian_DIC_comps_timeseries_450years")
plot=new(1,graphic)
 res                =   True
 res@gsnMaximize    =   False
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.6            ; Change the aspect ratio, but 
 res@vpHeightF          =0.4
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.025
 res@tiYAxisFontHeightF =0.025
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   ""
 res@tmYRMinorPerMajor=4
 res@gsnLeftStringFontHeightF=0.03
 res@gsnLeftStringOrthogonalPosF=0.06
 res@tmXBLabelFontHeightF = 0.025
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@tmYLLabelFontHeightF = 0.025
 res@tiYAxisString       =       "Ocean Carbon Storage [PgC]"
 res@tiXAxisString       =       "Simulation years"

 res@trYMaxF       =  80
 res@trYMinF       = -20
 res@xyDashPatterns    =   (/0,16,14/)
 res@xyLineColors   =  (/"black","black","black"/)
 res@gsnLeftString="(a) Indian"
 plot=gsn_csm_xy(wks,year,Ind,res)

 gres1=True
 gres1@YPosPercent = 94.
 gres1@XPosPercent = 59
 gres1@ItemSpacePercent=10
 lineres2=True
 lineres2@lgDashIndexes    =   (/0,16,14/)
 lineres2@lgLineColors=  (/"black","black","black"/)
 lineres2@LineLengthPercent = 20.
 lineres2@lgLineThicknesses = 3
 lineres2@lgLineDashSegLens=0.05
 textres2= True
 textres2@lgLabels  =(/"DIC~B~tot~N~","DIC~B~nat~N~","DIC~B~ant~N~"/)
 textres2@lgLabelFontHeights   =(/0.024,0.024,0.024/)
 textres2@lgPerimOn                = False
 textres2@lgItemCount              = 7
 plot = simple_legend(wks,plot,gres1,lineres2,textres2)

 draw(plot)
 frame(wks)

end
