begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

u2=addfile(dir0+"flat10_cdr_atlantic_moc_18500101-22991231.nc","r")
amoc=u2->atlantic_moc(:,:,:,0)
amoc_clim=dim_avg_n_Wrap(amoc,0)

f=addfile(dir0+"flat10_cdr_001_indopacific_moc_mm_18500101-22991231.nc","r")
indopacific_moc=f->indopacific_moc(:,:,:,0)
indopacific_moc_clim=dim_avg_n_Wrap(indopacific_moc,0)

g=addfile(dir0+"flat10_cdr_001_global_moc_moc_mm_18500101-22991231.nc","r")
glo_moc=g->global_moc(:,:,:,0)
glo_moc_clim=dim_avg_n_Wrap(glo_moc,0)

amoc_clim_sv=amoc_clim/(1025*10^(6))
glo_moc_clim_sv=glo_moc_clim/(1025*10^(6))
indopacific_moc_clim_sv=indopacific_moc_clim/(1025*10^(6))
copy_VarCoords(amoc_clim,amoc_clim_sv)
copy_VarCoords(glo_moc_clim,glo_moc_clim_sv)
copy_VarCoords(indopacific_moc_clim,indopacific_moc_clim_sv)

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"MOCs_CDR_clim" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLevelSelectionMode   =       "ManualLevels"
res@trYReverse =True
res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@gsnDraw                =       False
res@gsnFrame               =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@gsnCenterStringFontHeightF= 0.035
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04

res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "GMT_polar"
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@cnMaxLevelValF         =     50
res@cnMinLevelValF         =     -50
res@cnLevelSpacingF        =      10
res@gsnCenterString="Atlantic MOC"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
res@tiYAxisString="Depth (m)"
res@tmXBLabelsOn        = True
res@tmYLLabelsOn        = True
plot(0)  = gsn_csm_contour(wks, amoc_clim_sv, res )   ; plaace holder
res@gsnCenterString="Indo-Pacific MOC"
plot(1)  = gsn_csm_contour(wks, indopacific_moc_clim_sv,res )   ; plaace holder
res@gsnCenterString="Global MOC"
plot(2)  = gsn_csm_contour(wks, glo_moc_clim_sv, res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 4
pres@gsnPanelXWhiteSpacePercent = 1
;pres@gsnPanelLeft=0.1
;pres@gsnPanelRight=0.9
pres@gsnPanelLabelBar      = True

gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
