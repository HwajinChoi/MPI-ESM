begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_1850_2149.nc","r")
g=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_1850_2149.nc","r")

tot=f->dissic
nat=g->dissicnat
depth=f->depth
depth2=depth({0:2500})
DEPTH=dble2flt(depth2)
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
DIC(0,:)=tot2(299,:)
DIC(1,:)=nat2(299,:)
DIC(2,:)=ant(299,:)

DIC2=DIC(:,{0:2500})

plot=new(2,graphic)
wks   = gsn_open_wks ("png",dir2+"area_2plots_vert_glb_avg_DIC_flat10_last_year")                  ; send graphics to PNG file
res                   = True                       ; plot mods desired
res@gsnFrame               =       False
res@gsnDraw                =       False
res@tiMainString      = ""             ; add title
res@trYReverse        = True                       ; reverse Y-axis
res@tmXUseBottom=False
res@tmXBOn=False
res@tmXTOn=True
res@vpWidthF       = 0.4            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
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
res@trXMinF           = 0.
res@trXMaxF           = 250.
res@tmXTTickStartF    = 0.
res@tmXTTickEndF      = 250.   
res@tmXTTickSpacingF  = 100.
res@tiXAxisString=""

res@tiYAxisString="Depth [m]"
res@xyLineColor=(/"red"/)
res@xyDashPattern    = (/0/) 
res@xyLineThicknessF=(/6/)
plot(0)  = gsn_csm_xy (wks,DIC2(2,:),depth2,res) ; create plot
res@xyLineColors=(/"green","blue"/)
res@tiYAxisString=""
res@xyDashPatterns    = (/0,0/) 
res@xyLineThicknesses=(/6,6/)
res@trXMinF           = 1900.
res@trXMaxF           = 2300.
res@tmXTTickStartF    = 1900.
res@tmXTTickEndF      = 2300.  
res@tmXTTickSpacingF  = 100.
plot(1)  = gsn_csm_xy (wks,DIC2(0:1,:),depth2,res) ; create plot

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

nz = dimsizes(depth2)
xgL = new(2*nz+1, float)
ygL = new(2*nz+1, float)
xgL(0:nz-1)      = 0.0           ; 축(베이스라인)
ygL(0:nz-1)      = DEPTH
xgL(nz:2*nz-1)   = DIC2(2,::-1)  ; 음수 방지(필요 시)
ygL(nz:2*nz-1)   = DEPTH(::-1)
xgL(2*nz) = xgL(0)
ygL(2*nz) = ygL(0)

gsL = True
gsL@gsFillColor     = "Tomato"     ; 두 패널 동일 색 추천
gsL@gsFillOpacityF  = 0.35         ; 반투명
gsL@tfPolyDrawOrder = "PreDraw"    ; 선 아래에 칠하기
dumL = gsn_add_polygon(wks, plot(0), xgL, ygL, gsL)

gres@YPosPercent = 20
gres@XPosPercent = 4
lineres1 = True
lineres1@lgLineColors =(/"green","blue"/)
lineres1@lgLineThicknesses = 6
lineres1@LineLengthPercent = 8.
lineres1@lgDashIndexes            = (/0,0/)
textres1 = True
textres1@lgLabels = (/"DIC~B~tot~N~","DIC~B~nat~N~"/)
textres1@lgLabelFontHeights   =(/0.02,0.02/)
textres1@lgPerimOn                = False
textres1@lgItemCount              = 4
plot(1) = simple_legend(wks,plot(1),gres,lineres1,textres1)

xgR = new(2*nz+1, float)
ygR = new(2*nz+1, float)
xgR(0:nz-1)      = DIC2(1,:)       ; 파란선 (nat)
ygR(0:nz-1)      = DEPTH
xgR(nz:2*nz-1)   = DIC2(0,::-1)    ; 검은선 (tot) 역순
ygR(nz:2*nz-1)   = DEPTH(::-1)
xgR(2*nz) = xgR(0)
ygR(2*nz) = ygR(0)

gsR = True
gsR@gsFillColor     = "Tomato"     ; 왼쪽과 동일 색
gsR@gsFillOpacityF  = 0.35
gsR@tfPolyDrawOrder = "PreDraw"
dumR = gsn_add_polygon(wks, plot(1), xgR, ygR, gsR)

pres                       =   True
pres@gsnMaximize        =False
pres@gsnFrame         = False
pres@gsnPanelLeft=0.05
pres@gsnPanelRight=0.95

txres               = True                      ; text mods desired
txres@txFontHeightF = 0.018                     ; text font height
txres@txJust        = "CenterLeft"              ; Default is "CenterCenter".
txres@txFuncCode    = ":"  
gsn_text_ndc(wks,":F8:m",0.27,0.75,txres)
gsn_text_ndc(wks,":F8:m",0.72,0.75,txres)

txres1               = True                      ; text mods desired
txres1@txFontHeightF = 0.018                     ; text font height
gsn_text_ndc(wks,"["+"   mol kg-1]",0.325,0.75,txres1)
gsn_text_ndc(wks,"["+"   mol kg-1]",0.775,0.75,txres1)

gsn_panel(wks,plot,(/1,2/),pres)
frame(wks)

end
