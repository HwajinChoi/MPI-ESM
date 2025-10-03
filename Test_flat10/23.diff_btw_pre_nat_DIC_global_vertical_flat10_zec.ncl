begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
g=addfile(dir1+"test_flat10_zec_001_cfcs_ideal_r192x96_dissicnat_1850_2149.nc","r")
h=addfile(dir1+"test_pictrl_ver2_002_cfcs_ideal_r192x96_dissic_19710101_20001231.nc","r")

tot_pi=h->dissic
tot_pi1=dim_avg_n_Wrap(tot_pi,0)
tot_pi2=dim_avg_n_Wrap(tot_pi1,1)
tot_pi3=dim_avg_n_Wrap(tot_pi2,1)
tot_pi3=tot_pi3*(10^(6)/1035)

nat=g->dissicnat
depth=g->depth
dim=dimsizes(depth)

nat1=dim_avg_n_Wrap(nat,2)
nat2=dim_avg_n_Wrap(nat1,2); time * depth
nat2=nat2*(10^(6)/1035)

diff=nat2(299,:)-tot_pi3
copy_VarMeta(tot_pi3,diff)

wks   = gsn_open_wks ("png",dir2+"diff_nat_pre_DIC_vert_glb_avg_flat10_zec_last_year")                  ; send graphics to PNG file
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
res@trXMinF=-20.
res@trXMaxF=60.
res@tmXTMode="Manual"
res@tmXTTickStartF=0.
res@tmXTTickSpacingF=20.
res@tmYLLabelFontHeightF=0.02
res@tmXTLabelFontHeightF=0.02
res@gsnXRefLine=0.
res@gsnXRefLineDashPattern=1
res@gsnCenterString="Diff(DIC~B~nat|300yr~N~ - DIC~B~pre~N~)"
res@gsnCenterStringFontHeightF=0.022
res@gsnCenterStringOrthogonalPosF=0.04

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

res@tiXAxisString=""
res@tiYAxisString="Depth [m]"
res@xyLineColor="black"
res@xyDashPattern    = 0
res@xyLineThicknessF=6
res@tmXTTickStartF    = -20.
res@tmXTTickEndF      = 60.  
res@tmXTTickSpacingF  = 20.
plot  = gsn_csm_xy (wks,diff,depth,res) ; create plot

txres               = True                      ; text mods desired
txres@txFontHeightF = 0.016                     ; text font height
txres@txJust        = "CenterLeft"              ; Default is "CenterCenter".
txres@txFuncCode    = ":"  
gsn_text_ndc(wks,":F8:m",0.58,0.90,txres)
txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.016                     ; text font height
gsn_text_ndc(wks,"["+"   mol kg-1]",0.63,0.90,txres1)

draw(plot)
frame(wks)

end
