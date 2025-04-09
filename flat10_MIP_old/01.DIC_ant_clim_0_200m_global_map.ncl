begin
file11="$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc"

dir1="/work/uo1451/m301158/MPI-ESM/data/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
;-------------------------piControl-----------------
f1=addfile(dir1+"esm-piControl/dissic_reg_Omon_MPI-ESM1-2-LR_esm-piControl_r1i1p1f1_gn_205001-234912_6.nc","r")
dic_piC_surf=f1->dissic(:,0,:,:)
dic_piC_surf_mon=clmMonTLL(dic_piC_surf)

f2=addfile(dir1+"esm-piControl/dissic_reg_Omon_MPI-ESM1-2-LR_esm-piControl_r1i1p1f1_gn_205001-234912_182.5.nc","r")
dic_piC_200m=f2->dissic(:,0,:,:)
dic_piC_200m_mon=clmMonTLL(dic_piC_200m)

;--------------------------flat10----------------------
g1=addfile(dir1+"esm-flat10/dissic_reg_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012_6.nc","r")
dic_flat_surf=g1->dissic(:,0,:,:)
dim=dimsizes(dic_flat_surf)

g2=addfile(dir1+"esm-flat10/dissic_reg_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012_182.5.nc","r")
dic_flat_200m=g2->dissic(:,0,:,:)
;------------------------------------------------------------------------------------------------------------
dic_piC_surf_re=new((/dim(0),dim(1),dim(2)/),typeof(dic_flat_surf))
dic_piC_200m_re=new((/dim(0),dim(1),dim(2)/),typeof(dic_flat_surf))

do i=0,(dim(0)/12)-1
 dic_piC_surf_re(12*i:12*i+11,:,:)=dic_piC_surf_mon
 dic_piC_200m_re(12*i:12*i+11,:,:)=dic_piC_200m_mon
end do
;------------------------------------------------------------------------------------------------------------

dic_surf=dic_flat_surf-dic_piC_surf_re
copy_VarMeta(dic_flat_surf,dic_surf)
dic_surf_avg=dim_avg_n_Wrap(dic_surf,0)
printMinMax(dic_surf_avg,0)

dic_200m=dic_flat_200m-dic_piC_200m_re
copy_VarMeta(dic_flat_200m,dic_200m)
dic_200m_avg=dim_avg_n_Wrap(dic_200m,0)
printMinMax(dic_200m_avg,0)

 plot=new(2,graphic)
 wks=gsn_open_wks("png",dir2+"DIC_ant_Clim_global_map_0_200m")
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
 res@gsnCenterString="(a) Surface"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@lbLabelBarOn           = False
; res@tmXBLabelFontHeightF  =       0.025
; res@tmYLLabelFontHeightF  =       0.025
; res@tmXBLabelStride     =       2
; res@tmYLLabelStride     =       2
 sres                   =   res
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.18
 res@cnMinLevelValF         =      -0.01
 res@cnLevelSpacingF        =       0.01
 res@cnFillPalette          =       "cmocean_deep"

 plot(0)=gsn_csm_contour_map(wks,dic_surf_avg,res)
 res@gsnCenterString="(b) 200m"
 plot(1)=gsn_csm_contour_map(wks,dic_200m_avg ,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.015
 pres@lbLabelStride     =   3

 txres1               = True
 txres1@txFontHeightF = 0.016
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.8,0.35,txres1)
 txres1@txFontHeightF = 0.02
 gsn_text_ndc(wks,"Clim (esm-flat10)",0.5,0.75,txres1)


 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)
 gsn_panel(wks,plot,(/1,2/),pres)
 frame(wks)

end
