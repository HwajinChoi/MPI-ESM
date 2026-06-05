begin
dir1="/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

files0=systemfunc("ls "+dir1+"flat10_002_dissic_invent_???_1850-2299.nc"); arc, atl, ind, pac
f0=addfiles(files0,"r")
ListSetType(f0,"join")
flt_org=f0[:]->dissic
flt=flt_org(:,:,0,0)

files1=systemfunc("ls "+dir1+"flat10_zec_001_dissic_invent_???_1850-2299.nc"); arc, atl, ind, pac
f1=addfiles(files1,"r")
ListSetType(f1,"join")
flt_zec_org=f1[:]->dissic
flt_zec=flt_zec_org(:,:,0,0)

files2=systemfunc("ls "+dir1+"flat10_cdr_001_dissic_invent_???_1850-2299.nc"); arc, atl, ind, pac
f2=addfiles(files2,"r")
ListSetType(f2,"join")
flt_cdr_org=f2[:]->dissic
flt_cdr=flt_cdr_org(:,:,0,0)

files3=systemfunc("ls "+dir1+"test_pictrl_preform_001_spinup_dissic_invent_???_8920-8949.nc")
f3=addfiles(files3,"r")
ListSetType(f3,"join")
flt_pi_org=f3[:]->dissic
flt_pi=flt_pi_org(:,:,0,0)

flt_pi_an=dim_avg_n_Wrap(flt_pi,1)

flt_pi_clim=new((/4,450/),typeof(flt_pi_an))

do i=0,450-1
 flt_pi_clim(:,i)=flt_pi_an(:)
end do
copy_VarCoords(flt_cdr,flt_pi_clim)

flt := flt-flt_pi_clim
copy_VarCoords(flt_cdr,flt)
flt_zec := flt_zec-flt_pi_clim
copy_VarCoords(flt_cdr,flt_zec)
flt_cdr := flt_cdr-flt_pi_clim
copy_VarCoords(flt,flt_cdr)

arctic=new((/3,450/),typeof(flt))
arctic(0,:)=flt(0,:)
arctic(1,:)=flt_zec(0,:)
arctic(2,:)=flt_cdr(0,:)
print(arctic(2,:))
;exit

atlantic=new((/3,450/),typeof(flt))
atlantic(0,:)=flt(1,:)
atlantic(1,:)=flt_zec(1,:)
atlantic(2,:)=flt_cdr(1,:)
;print(atlantic(2,400:449))
;exit

indian=new((/3,450/),typeof(flt))
indian(0,:)=flt(2,:)
indian(1,:)=flt_zec(2,:)
indian(2,:)=flt_cdr(2,:)

pacific=new((/3,450/),typeof(flt))
pacific(0,:)=flt(3,:)
pacific(1,:)=flt_zec(3,:)
pacific(2,:)=flt_cdr(3,:)

arc_max_x=maxind(arctic(2,:))
arc_max_y=max(arctic(2,:))
atl_max_x=maxind(atlantic(2,:))
atl_max_y=max(atlantic(2,:))
ind_max_x=maxind(indian(2,:))
ind_max_y=max(indian(2,:))
pac_max_x=maxind(pacific(2,:))
pac_max_y=max(pacific(2,:))

 year=ispan(1,450,1)
 wks=gsn_open_wks("png",dir2+"dissic_timeseries_4_basins")
 plot=new(4,graphic)
 plot1=new(4,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@gsnYRefLine=0.
 res@gsnYRefLineDashPattern=1
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@gsnXRefLine=150
 res@gsnXRefLineDashPattern=1
 res@xyLineThicknessF= 6
 res@tiXAxisString       =       "Simulation years"
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.03
 res@tiMainString       =   ""
 res@xyLineColors   = (/"grey40","darkorange","dodgerblue"/)
 res@xyDashPatterns    =   (/0,0,0/)
 res@trXMinF             =       0
 res@trXMaxF             =       450
 res@gsnCenterString="(a) Arctic"
 res@gsnCenterStringFontHeightF=0.05
 res@trYMinF       =  -10
 res@trYMaxF       =  30
 res@tiYAxisString       =       "[PgC]"
 res@gsnCenterStringOrthogonalPosF=0.06
 plot(0)=gsn_csm_xy(wks,year,arctic,res)
 res@trYMinF       =  -10
 res@trYMaxF       =  500
 res@gsnCenterString="(b) Atlantic"
 plot(1)=gsn_csm_xy(wks,year,atlantic,res)
 res@trYMinF       =  -10
 res@trYMaxF       =  300
 res@gsnCenterString="(c) Indian"
 plot(2)=gsn_csm_xy(wks,year,indian,res)
 res@trYMinF       =  -10
 res@trYMaxF       =  600
 res@gsnCenterString="(d) Pacific"
 plot(3)=gsn_csm_xy(wks,year,pacific,res)

 gres = True
 gres@YPosPercent = 92.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"grey40","darkorange","dodgerblue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0,0/)
 textres = True
 textres@lgLabels = (/"esm-flat10","esm-flat10-zec","esm-flat10-cdr"/)
 textres@lgLabelFontHeights   =(/0.03,0.03,0.03/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 plot(2) = simple_legend(wks,plot(2),gres,lineres,textres)
 plot(3) = simple_legend(wks,plot(3),gres,lineres,textres)

 grres=True
 grres@gsMarkerColor = "blue"   ; Change marker color.
 grres@gsMarkerSizeF = 10. ; Increase marker size by a factor of 10.
 grres@gsMarkerIndex = 16   ; Change marker type to a filled circle.
;print(arc_max_x)
;print(arc_max_y)
;exit

;print(arc_max_x)
;print(atl_max_x)
;print(ind_max_x)
;print(pac_max_x)
;exit

 plot1(0)=gsn_add_polymarker(wks,plot(0),arc_max_x,arc_max_y,grres)  ; Draw the polymarkers on
 plot1(1)=gsn_add_polymarker(wks,plot(1),atl_max_x,atl_max_y,grres)  ; Draw the polymarkers on
 plot1(2)=gsn_add_polymarker(wks,plot(2),ind_max_x,ind_max_y,grres)  ; Draw the polymarkers on
 plot1(3)=gsn_add_polymarker(wks,plot(3),pac_max_x,pac_max_y,grres)  ; Draw the polymarkers on

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 3
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/2,2/),pres)

 frame(wks)

end
