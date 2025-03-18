begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"

dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
;-------------------------piControl-----------------
f1=addfile(dir1+"test_pictrl_ver2_001/dissic_nat_r192x96_185001-190012_6m.nc","r")
dic_tot_surf=f1->dissic(:,0,:,:)
dic_nat_surf=f1->dissicnat(:,0,:,:)

f2=addfile(dir1+"test_pictrl_ver2_001/dissic_nat_r192x96_185001-190012_182.5m.nc","r")
dic_tot_200m=f2->dissic(:,0,:,:)
dic_nat_200m=f2->dissicnat(:,0,:,:)

dic_diff_surf=dic_nat_surf-dic_tot_surf
copy_VarCoords(dic_tot_surf,dic_diff_surf)
dic_diff_200m=dic_nat_200m-dic_tot_200m
copy_VarCoords(dic_tot_200m,dic_diff_200m)
;------------------------------------------------------------------------------------------------------------
dic_clim_diff_surf=dim_avg_n_Wrap(dic_diff_surf,0)
dic_clim_diff_200m=dim_avg_n_Wrap(dic_diff_200m,0)

;printMinMax(dic_clim_diff_surf,0)
;printMinMax(dic_clim_diff_200m,0)
;exit

 plot=new(2,graphic)
 wks=gsn_open_wks("png",dir2+"DIC_diff_Clim_global_map_0_200m")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 ;res@cnFillMode                =   "AreaFill"
 res@lbLabelBarOn           =      False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.020
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@lbLabelBarOn           = True
; res@tmXBLabelFontHeightF  =       0.025
; res@tmYLLabelFontHeightF  =       0.025
; res@tmXBLabelStride     =       2
; res@tmYLLabelStride     =       2
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnFillPalette          =       "BlueDarkRed18"
 res@gsnCenterString="(a) Surface"
 res@cnMinLevelValF         =     -0.0018 
 res@cnMaxLevelValF         =     0.0018 
 res@lbLabelFontHeightF  = 0.015
 res@cnLevelSpacingF        =       0.0003
 plot(0)=gsn_csm_contour_map(wks,dic_clim_diff_surf,res)
 res@cnMaxLevelValF         =      0.0015
 res@cnMinLevelValF         =     -0.0015 
 res@cnLevelSpacingF        =       0.0003
 res@gsnCenterString="(b) 200m"
 plot(1)=gsn_csm_contour_map(wks,dic_clim_diff_200m ,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 pres@lbLabelStride     =   3
 ;pres@gsnPanelLeft=0.1
 ;pres@gsnPanelTop=1.
 ;spres@gsnPanelTop=0.4

 txres1               = True
 txres1@txFontHeightF = 0.012
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.5,0.36,txres1)

 gsn_panel(wks,plot,(/1,2/),pres)
 frame(wks)

end
