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
dic_Atl_diff=new((/dim(0),dim(1),dim(2)/),typeof(DIC_tot_Atl))
dic_Pac_diff=new((/dim(0),dim(1),dim(2)/),typeof(DIC_tot_Atl))
dic_Ind_diff=new((/dim(0),dim(1),dim(2)/),typeof(DIC_tot_Atl))

dic_Atl_diff=DIC_tot_Atl-DIC_nat_Atl
copy_VarMeta(DIC_tot_Atl,dic_Atl_diff)
dic_Pac_diff=DIC_tot_Pac-DIC_nat_Pac
copy_VarMeta(DIC_tot_Pac,dic_Pac_diff)
dic_Ind_diff=DIC_tot_Ind-DIC_nat_Ind
copy_VarMeta(DIC_tot_Ind,dic_Ind_diff)

DIC_diff_Atl_avg=dim_avg_n_Wrap(dic_Atl_diff,0)
DIC_diff_Pac_avg=dim_avg_n_Wrap(dic_Pac_diff,0)
DIC_diff_Ind_avg=dim_avg_n_Wrap(dic_Ind_diff,0)

DIC_diff_Atl_avg=DIC_diff_Atl_avg*(-1)
DIC_diff_Ind_avg=DIC_diff_Ind_avg*(-1)
DIC_diff_Pac_avg=DIC_diff_Pac_avg*(-1)

printMinMax(DIC_diff_Atl_avg,0)
printMinMax(DIC_diff_Pac_avg,0)
printMinMax(DIC_diff_Ind_avg,0)
;exit
plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_verti_Imple_test_DIC_diff_51years" )          ; send graphics to PNG file

res                      = True                 ; plot mods desired
res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
res@cnLevelSpacingF      = 0.0002                  ; contour spacing
res@cnLineLabelsOn         =       False
res@cnMinLevelValF       = -0.0012                 ; min level
res@cnMaxLevelValF       =  0.0012                ; max level
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "BlueDarkRed18"
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
plot(0)  = gsn_csm_contour(wks, DIC_diff_Atl_avg, res )   ; plaace holder
res@tiYAxisString=""
res@gsnCenterString="(b) Pacific Ocean"
plot(1)  = gsn_csm_contour(wks, DIC_diff_Pac_avg, res )   ; plaace holder
res@gsnCenterString="(c) Indian Ocean"
plot(2)  = gsn_csm_contour(wks, DIC_diff_Ind_avg, res )   ; plaace holder

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.013
 pres@lbLabelStride     =   3
 pres@pmLabelBarHeightF=0.06
 pres@gsnPanelMainString="Diff (nat-tot)"

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.90,0.34,txres1)
 txres1@txFontHeightF = 0.02
 gsn_panel(wks,plot,(/1,3/),pres)
 frame(wks)

end
