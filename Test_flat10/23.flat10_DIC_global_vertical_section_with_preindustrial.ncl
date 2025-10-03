begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_1850_2149.nc","r")
g=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_1850_2149.nc","r")

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

DIC=new((/3,dim(0)/),"float")
DIC(0,:)=tot_pi3
DIC(1,:)=tot2(299,:)
DIC(2,:)=nat2(299,:)
print(DIC(0,0:4))
print(DIC(2,0:4))
exit

wks   = gsn_open_wks ("png",dir2+"DIC_vert_glb_avg_flat10_last_year_with_prei")                  ; send graphics to PNG file
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
res@tiXAxisString=""
res@tiYAxisString="Depth [m]"
res@xyLineColors=(/"black","green","blue"/)
res@xyDashPatterns    = (/0,0,0/) 
res@xyLineThicknesses=(/6,6,6/)
res@trXMinF           = 1900.
res@trXMaxF           = 2250.
res@tmXTTickStartF    = 1900.
res@tmXTTickEndF      = 2250.  
res@tmXTTickSpacingF  = 100.
plot  = gsn_csm_xy (wks,DIC,depth,res) ; create plot

gres = True
gres@ItemSpacePercent          = 6
gres@YPosPercent = 80
gres@XPosPercent = 4
lineres1 = True
lineres1@lgLineColors =(/"black","green","blue"/)
lineres1@lgLineThicknesses = 6
lineres1@LineLengthPercent = 8.
lineres1@lgDashIndexes            = (/0,0,0/)
textres1 = True
textres1@lgLabels = (/"DIC~B~pre~N~","DIC~B~tot|300yr~N~","DIC~B~nat|300yr~N~"/)
textres1@lgLabelFontHeights   =(/0.018,0.018,0.018/)
textres1@lgPerimOn                = False
textres1@lgItemCount              = 4
plot = simple_legend(wks,plot,gres,lineres1,textres1)

txres               = True                      ; text mods desired
txres@txFontHeightF = 0.018                     ; text font height
txres@txJust        = "CenterLeft"              ; Default is "CenterCenter".
txres@txFuncCode    = ":"  
gsn_text_ndc(wks,":F8:m",0.33,0.90,txres)
txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.018                     ; text font height
gsn_text_ndc(wks,"["+"   mol kg-1]",0.385,0.90,txres1)

draw(plot)
frame(wks)

end
