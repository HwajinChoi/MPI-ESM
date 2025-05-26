begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"Beu_re_test_flat10_001_cfcs_ideal_r192x96_thetao_18500101_21491231.nc","r")
g=addfile(dir1+"Beu_re_test_flat10_zec_001_cfcs_ideal_r192x96_thetao_18500101_21491231.nc","r")
h=addfile(dir1+"Beu_re_test_flat10_cdr_001_cfcs_ideal_r192x96_thetao_18500101_21491231.nc","r")

t_flt=f->thetao; time x depth x lat x lon
t_zec=g->thetao
t_cdr=h->thetao

depth_1=f->depth({0:400})

t_flt_0=dim_avg_n_Wrap(t_flt,2)
t_zec_0=dim_avg_n_Wrap(t_zec,2)
t_cdr_0=dim_avg_n_Wrap(t_cdr,2)

t_flt_1=dim_avg_n_Wrap(t_flt_0,2)
t_zec_1=dim_avg_n_Wrap(t_zec_0,2)
t_cdr_1=dim_avg_n_Wrap(t_cdr_0,2)

t_flt_2=month_to_annual(t_flt_1,1)
t_zec_2=month_to_annual(t_zec_1,1)
t_cdr_2=month_to_annual(t_cdr_1,1)

dim=dimsizes(t_cdr_2)
First=new((/3,dim(1)/),typeof(t_flt_2))
First(0,:)=dim_avg_n_Wrap(t_flt_2(0:29,:),0)
First(1,:)=dim_avg_n_Wrap(t_zec_2(0:29,:),0)
First(2,:)=dim_avg_n_Wrap(t_cdr_2(0:29,:),0)
First!0="scenarios"

Middle=new((/3,dim(1)/),typeof(t_flt_2))
Middle(0,:)=dim_avg_n_Wrap(t_flt_2(135:164,:),0)
Middle(1,:)=dim_avg_n_Wrap(t_zec_2(135:164,:),0)
Middle(2,:)=dim_avg_n_Wrap(t_cdr_2(135:164,:),0)
Middle!0="scenarios"

Last=new((/3,dim(1)/),typeof(t_flt_2))
Last(0,:)=dim_avg_n_Wrap(t_flt_2(270:299,:),0)
Last(1,:)=dim_avg_n_Wrap(t_zec_2(270:299,:),0)
Last(2,:)=dim_avg_n_Wrap(t_cdr_2(270:299,:),0)
Last!0="scenarios"

First_1=First(:,{0:400})
Middle_1=Middle(:,{0:400})
Last_1=Last(:,{0:400})
printMinMax(First_1,0)
printMinMax(Last_1,0)
exit

wks=gsn_open_wks("png",dir2+"Beaufort_temp_vertical_distribution_400m")
 plot=new(3,"graphic")
 res	=True
 ;res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 ;res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@xyLineColors   = (/"grey40","darkorange","dodgerblue"/)
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "[~S~o~N~C]"
 res@tiXAxisFontHeightF =0.025
 res@tiYAxisFontHeightF =0.025
 res@tiMainFontHeightF =0.025
 res@trYReverse =True
 res@tiMainString       =   ""
 res@trXMinF             =       -2
 res@trXMaxF             =      4 
 res@gsnCenterString="(a) Beaufort Gyre region (Potential Temp.)"
 res@gsnCenterStringFontHeightF=0.02
 res@trYMinF       =  0
 res@trYMaxF       =  400
 res@tiYAxisString       =       "[m]"
 res@gsnCenterStringOrthogonalPosF=0.06
 res@xyDashPatterns    =   (/0,0,0/)
 plot(0)=gsn_csm_xy(wks,First_1,depth_1,res)
 res@xyDashPatterns    =   (/16,16,16/)
 plot(1)=gsn_csm_xy(wks,Middle_1,depth_1,res)
 res@xyDashPatterns    =   (/2,2,2/)
 plot(2)=gsn_csm_xy(wks,Last_1,depth_1,res)

 gres = True
 gres@YPosPercent = 94.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec","esm-flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.018,0.018,0.018/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 gres@YPosPercent = 20.
 gres@XPosPercent = 74
 lineres@LineLengthPercent = 8.
 lineres@lgLineColors =(/"black","black","black"/)
 lineres@lgDashIndexes            = (/0,16,2/)
 textres@lgLabels = (/"First","Middle","Last"/)
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)

 overlay(plot(0),plot(1))
 overlay(plot(0),plot(2))

 draw(plot(0))
 frame(wks)

end
