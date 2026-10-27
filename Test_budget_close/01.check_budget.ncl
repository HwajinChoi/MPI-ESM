begin
dir0="/work/uo1451/m301158/MPI-ESM/image/"
dir1="/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/"

f=addfile(dir1+"DIC_advection_terms_r192x96_229901-229912.nc","r")
g=addfile(dir1+"dissicnat_adv_r192x96_229901-229912.nc","r")
cnat_adv=g->tsco212nat_adv ; time depth lat lon
adv_UC=f->adv_UC
adv_VC=f->adv_VC
adv_WC=f->adv_WC

adv_WC := -adv_WC

adv=adv_UC+adv_VC+adv_WC
copy_VarCoords(adv_UC,adv)
copy_VarCoords(adv_UC,adv_WC)

;--- random numbers ----
i=3 ; 0-11 month
j=0; 0-39 depth
;-----------------------

plot=new(5,graphic)
wks   = gsn_open_wks ("png", dir0+"random_check_budget_term_closeness" )          ; send graphics to PNG file
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
res@cnFillPalette        = "GMT_polar"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.03
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"

res@lbLabelBarOn           = True
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterString="-(d(uC)/dx)"
res@cnMaxLevelValF         =   4e-07 
res@cnMinLevelValF         =     -4e-07
res@cnLevelSpacingF        =      1e-07
plot(0)  = gsn_csm_contour_map(wks,adv_UC(i,j,:,:), res )   ; plaace holder
res@gsnCenterString="-(d(vC)/dy)"
plot(1)  = gsn_csm_contour_map(wks,adv_VC(i,j,:,:), res )   ; plaace holder
res@gsnCenterString="(d(wC)/dz)"
plot(2)  = gsn_csm_contour_map(wks,adv_WC(i,j,:,:), res )   ; plaace holder
res@gsnCenterString="Offline adv"
plot(3)  = gsn_csm_contour_map(wks,adv(i,j,:,:), res )   ; plaace holder
res@gsnCenterString="Online adv"
res@cnMaxLevelValF         =   4e-09 
res@cnMinLevelValF         =     -4e-09
res@cnLevelSpacingF        =      1e-09
plot(4)  = gsn_csm_contour_map(wks,cnat_adv(i,j,:,:), res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       False
pres@gsnPanelLabelBar      = False
pres@gsnPanelRowSpec = True


gsn_panel(wks,plot,(/3,2/),pres)
frame(wks)






end
