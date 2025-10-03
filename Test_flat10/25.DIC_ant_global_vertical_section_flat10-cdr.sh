#!/bin/bash

for year in $(seq 1 300); do

 Y=$((year - 1))

cat <<EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissic_1850_2149.nc","r")
g=addfile(dir1+"test_flat10_cdr_001_cfcs_ideal_r192x96_dissicnat_1850_2149.nc","r")
h=addfile(dir1+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231.nc","r")
tot_pi=h->dissic
tot_pi1=dim_avg_n_Wrap(tot_pi,0)
tot_pi2=dim_avg_n_Wrap(tot_pi1,1)
tot_pi3=dim_avg_n_Wrap(tot_pi2,1)
tot_pi3=tot_pi3*(10^(6)/1035)

tot=f->dissic
nat=g->dissicnat
depth=f->depth
dim=dimsizes(depth)
tot1=dim_avg_n_Wrap(tot,2)
tot2=dim_avg_n_Wrap(tot1,2); time * depth
tot2=tot2*(10^(6)/1035)

nat1=dim_avg_n_Wrap(nat,2)
nat2=dim_avg_n_Wrap(nat1,2); time * depth
nat2=nat2*(10^(6)/1035)

ant=tot2-nat2
copy_VarMeta(tot2,ant)

DIC=new((/4,dim(0)/),"float")
DIC(0,:)=tot2(${Y},:)
DIC(1,:)=nat2(${Y},:)
DIC(2,:)=tot_pi3
DIC(3,:)=ant(${Y},:)

plot=new(1,graphic)
wks   = gsn_open_wks ("png",dir2+"DIC_ant_vert_glb_avg_DIC_flat10_cdr_${Y}_year")                  ; send graphics to PNG file
res                   = True                       ; plot mods desired
res@gsnFrame               =       False
res@gsnDraw                =       False
res@tiMainString      = ""             ; add title
res@trYReverse        = True                       ; reverse Y-axis
res@tmXUseBottom=False
res@tmXBOn=False
res@tmXTOn=True
res@vpWidthF       = 0.4            ; Change the aspect ratio, but 
res@vpHeightF      = 0.7
res@trXMinF=0.
res@trXMaxF=2300.
res@tmXTMode="Manual"
res@tmXTTickStartF=0.
res@tmXTTickSpacingF=400.
res@tmYLLabelFontHeightF=0.02
res@tmXTLabelFontHeightF=0.02
res@gsnXRefLine=0.
res@gsnXRefLineDashPattern=1
res@tmXBOn            = False
res@tmXBLabelsOn      = False
res@tmXBMinorOn       = False
res@tmXBBorderOn      = False

res@tmXTOn            = True
res@tmXTLabelsOn      = True
res@tmXTMinorOn       = True
res@tmXTMajorLengthF  = 0.02
res@tmXTMinorLengthF  = 0.012
res@tmXTBorderOn      = True

res@tmXTMode          = "Manual"
res@trXMinF           = -50.
res@trXMaxF           = 100.
res@tmXTTickStartF    = -50.
res@tmXTTickEndF      = 100.
res@tmXTTickSpacingF  = 50.
res@tiXAxisString=""

res@tiYAxisString="Depth [m]"
res@xyLineColor=(/"red"/)
res@xyDashPattern    = (/0/)
res@xyLineThicknessF=(/6/)
plot(0)  = gsn_csm_xy (wks,DIC(3,:),depth,res) ; create plot
res@xyLineColors=(/"green","blue","black"/)
res@tiYAxisString=""
res@xyDashPatterns    = (/0,0,0/)
res@xyLineThicknesses=(/6,6,6/)
res@trXMinF           = 1800.
res@trXMaxF           = 2300.
res@tmXTTickStartF    = 1800.
res@tmXTTickEndF      = 2300.
res@tmXTTickSpacingF  = 100.
;plot(1)  = gsn_csm_xy (wks,DIC(0:2,:),depth,res) ; create plot
gres = True
gres@YPosPercent = 18
gres@XPosPercent = 70
gres@ItemSpacePercent          = 6
lineres = True
lineres@lgLineColors =(/"red"/)
lineres@lgLineThicknesses = 6
lineres@LineLengthPercent = 8.
lineres@lgDashIndexes            = (/0/)
textres = True
textres@lgLabels = (/"DIC~B~ant~N~"/)
textres@lgLabelFontHeights   =(/0.02/)
textres@lgPerimOn                = False
textres@lgItemCount              = 4
plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
;gres@YPosPercent = 30
;gres@XPosPercent = 4
;lineres1 = True
;lineres1@lgLineColors =(/"green","blue","black"/)
;lineres1@lgLineThicknesses = 6
;lineres1@LineLengthPercent = 8.
;lineres1@lgDashIndexes            = (/0,0,0/)
;textres1 = True
;textres1@lgLabels = (/"DIC~B~tot~N~","DIC~B~nat~N~","DIC~B~pi~N~"/)
;textres1@lgLabelFontHeights   =(/0.02,0.02,0.02/)
;textres1@lgPerimOn                = False
;textres1@lgItemCount              = 4
;plot(1) = simple_legend(wks,plot(1),gres,lineres1,textres1)

;pres                       =   True
;pres@gsnMaximize        =False
;pres@gsnFrame         = False
;pres@gsnPanelLeft=0.05
;pres@gsnPanelRight=0.95
;pres@gsnPanelMainString="Year ${year}"
;pres@gsnPanelMainPosYF=0.8

txres               = True                      ; text mods desired
txres@txFontHeightF = 0.018                     ; text font height
txres@txJust        = "CenterLeft"              ; Default is "CenterCenter".
txres@txFuncCode    = ":"
gsn_text_ndc(wks,":F8:m",0.36,0.9,txres)
;gsn_text_ndc(wks,":F8:m",0.72,0.75,txres)

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.018                     ; text font height
gsn_text_ndc(wks,"["+"   mol kg-1]",0.415,0.9,txres1)
;gsn_text_ndc(wks,"["+"   mol kg-1]",0.775,0.75,txres1)

;gsn_panel(wks,plot,(/1,2/),pres)
draw(plot)
frame(wks)
end
EOF
  ncl ./imsi.ncl
  rm -f ./imsi.ncl
 echo ${year}

done

