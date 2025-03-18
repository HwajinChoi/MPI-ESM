begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_pictrl_ver2_001/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

;----------------------flat10MIP-----------------------------------------------
f=addfile(dir0+"dissic_nat_r192x96_185001-190012_lon_340.nc","r")
DIC_tot_Atl=f->dissic(:,:,:,0)
DIC_nat_Atl=f->dissicnat(:,:,:,0)
dim=dimsizes(DIC_tot_Atl)

g=addfile(dir0+"dissic_nat_r192x96_185001-190012_lon_190.nc","r")
DIC_tot_Pac=g->dissic(:,:,:,0)
DIC_nat_Pac=g->dissicnat(:,:,:,0)

h=addfile(dir0+"dissic_nat_r192x96_185001-190012_lon_70.nc","r")
DIC_tot_Ind=h->dissic(:,:,:,0)
DIC_nat_Ind=h->dissicnat(:,:,:,0)

;--------------------------------------------------------------------------------
DIC_tot_Atl_avg=dim_avg_n_Wrap(DIC_tot_Atl,0)
DIC_tot_Pac_avg=dim_avg_n_Wrap(DIC_tot_Pac,0)
DIC_tot_Ind_avg=dim_avg_n_Wrap(DIC_tot_Ind,0)

DIC_nat_Atl_avg=dim_avg_n_Wrap(DIC_nat_Atl,0)
DIC_nat_Pac_avg=dim_avg_n_Wrap(DIC_nat_Pac,0)
DIC_nat_Ind_avg=dim_avg_n_Wrap(DIC_nat_Ind,0)

;printMinMax(DIC_tot_Atl_avg,0)
;exit
plot=new(6,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_verti_Imple_test_DIC_clim_51years" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
res@cnLevelSpacingF      = 0.025                  ; contour spacing
res@cnLineLabelsOn         =       False
res@cnMinLevelValF       = 2.                 ; min level
res@cnMaxLevelValF       =  2.4                 ; max level
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "cmocean_deep"
res@trYReverse =True
res@vpWidthF       = 0.6            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@tmYLLabels =(..)
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnCenterStringFontHeightF= 0.028
res@gsnCenterStringOrthogonalPosF=0.05
res@gsnCenterString="(a) Atlantic Ocean"
res@gsnLeftString=""
res@gsnRightString=""
res@tmXBLabelFontHeightF=0.026
res@tmYLLabelFontHeightF=0.026
res@tiYAxisFontHeightF=0.028

; note u is already on pressure levels. If this were model data, it
; would be necessary to interpolate from the hybrid coordinates to 
; pressure levels.
res@tiYAxisString="Depth (m)"
plot(0)  = gsn_csm_contour(wks, DIC_tot_Atl_avg, res )   ; plaace holder
res@tiYAxisString=""
res@gsnCenterString="(b) Pacific Ocean"
plot(1)  = gsn_csm_contour(wks, DIC_tot_Pac_avg, res )   ; plaace holder
res@gsnCenterString="(c) Indian Ocean"
plot(2)  = gsn_csm_contour(wks, DIC_tot_Ind_avg, res )   ; plaace holder
res@gsnCenterString=""
res@tiYAxisString="Depth (m)"
plot(3)  = gsn_csm_contour(wks, DIC_nat_Atl_avg, res )   ; plaace holder
res@tiYAxisString=""
plot(4)  = gsn_csm_contour(wks, DIC_nat_Pac_avg, res )   ; plaace holder
plot(5)  = gsn_csm_contour(wks, DIC_nat_Ind_avg, res )   ; plaace holder

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelLeft=0.1
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.013
 pres@lbLabelStride     =   3
 pres@pmLabelBarHeightF=0.06
 pres@gsnPanelMainString=""

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.90,0.25,txres1)

 gsn_text_ndc(wks,"DIC~B~tot~N~",0.05,0.66,txres1)
 gsn_text_ndc(wks,"DIC~B~nat~N~",0.05,0.40,txres1)
 txres1@txFontHeightF = 0.02
 gsn_panel(wks,plot,(/2,3/),pres)
 frame(wks)

end
