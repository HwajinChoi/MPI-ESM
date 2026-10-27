begin
dir0="/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/nuno_online/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"advs_r192x96_185001-185012.nc","r")

adv=f->tsco212nat_adv
h_adv=f->tsco212nat_hadv
v_adv=f->tsco212nat_vadv

sum_adv=h_adv+v_adv
copy_VarCoords(h_adv,sum_adv)
diff=adv-sum_adv
copy_VarCoords(h_adv,diff)

;=== random
i=3 ;month 0,11
j=10 ;depth 0,39

plot=new(4,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_online_budget_check" )
res                      = True                 ; plot mods desired
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@lbLabelFontHeightF  = 0.023
res@vpHeightF      = 0.5
res@gsnDraw                =       False
res@gsnFrame               =       False
res@cnLineLabelsOn         =       False
res@cnFillOn             = True                 ; turn on color fill
res@cnInfoLabelOn          =   False

res@cnLinesOn=False
res@cnFillPalette        = "BlueDarkRed18"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"
res@lbLabelBarOn           = True
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =    2e-09 
res@cnMinLevelValF         =    -2e-09
res@cnLevelSpacingF        =      4e-10  
res@gsnCenterString="Horizontal advection"
plot(0)  = gsn_csm_contour_map(wks,h_adv(i,j,:,:) , res )   ; plaace holder
res@gsnCenterString="Vertical advection"
plot(1)  = gsn_csm_contour_map(wks,v_adv(i,j,:,:) , res )   ; plaace holder
res@gsnCenterString="Advection"
plot(2)  = gsn_csm_contour_map(wks,adv(i,j,:,:) , res )   ; plaace holder
res@cnMaxLevelValF         =    2e-16 
res@cnMinLevelValF         =    -2e-16
res@cnLevelSpacingF        =      4e-17  
res@gsnCenterString="Diff ()"
plot(3)  = gsn_csm_contour_map(wks,diff(i,j,:,:) , res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 4
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.9
pres@gsnPanelLabelBar      = False

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.011
;gsn_text_ndc(wks,"Positive emissions",0.06,0.63,txres1)
gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)

end
