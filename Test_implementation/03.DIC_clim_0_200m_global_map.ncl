begin
load "./panel_two_sets.ncl"
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
;------------------------------------------------------------------------------------------------------------
dic_clim_tot_surf=dim_avg_n_Wrap(dic_tot_surf,0)
dic_clim_nat_surf=dim_avg_n_Wrap(dic_nat_surf,0)

dic_clim_tot_200m=dim_avg_n_Wrap(dic_tot_200m,0)
dic_clim_nat_200m=dim_avg_n_Wrap(dic_nat_200m,0)
;printMinMax(dic_clim_tot_surf,0)
;printMinMax(dic_clim_nat_surf,0)
;printMinMax(dic_clim_tot_200m,0)
;exit

 plot=new(4,graphic)
 wks=gsn_open_wks("png",dir2+"DIC_tot_nat_Clim_global_map_0_200m")
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
 res@lbLabelBarOn           = False
; res@tmXBLabelFontHeightF  =       0.025
; res@tmYLLabelFontHeightF  =       0.025
; res@tmXBLabelStride     =       2
; res@tmYLLabelStride     =       2
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnFillPalette          =       "cmocean_deep"
 sres                   =   res
 res@gsnCenterString="(a) Surface"
 res@cnMinLevelValF         =      1.8
 res@cnMaxLevelValF         =     2.2 
 res@cnLevelSpacingF        =       0.02

 sres@cnMaxLevelValF         =      2.4
 sres@cnMinLevelValF         =     1.8 
 sres@cnLevelSpacingF        =       0.02

 plot(0)=gsn_csm_contour_map(wks,dic_clim_tot_surf,res)
 res@gsnCenterString=""
 plot(1)=gsn_csm_contour_map(wks,dic_clim_nat_surf ,res)
 sres@gsnCenterString="(b) 200m"
 plot(2)=gsn_csm_contour_map(wks,dic_clim_tot_200m,sres)
 sres@gsnCenterString=""
 plot(3)=gsn_csm_contour_map(wks,dic_clim_nat_200m ,sres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 pres@lbLabelFontHeightF  = 0.015
 pres@lbLabelStride     =   3
 pres@gsnPanelLeft=0.1
 ;pres@gsnPanelTop=1.
 pres1=pres
 spres = pres
 ;spres@gsnPanelTop=0.4

 txres1               = True
 txres1@txFontHeightF = 0.016
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.55,0.25,txres1)

 gsn_text_ndc(wks,"DIC~B~tot~N~",0.05,0.65,txres1)
 gsn_text_ndc(wks,"DIC~B~nat~N~",0.05,0.35,txres1)
 txres1@txFontHeightF = 0.02
; gsn_text_ndc(wks,"Clim (esm-flat10)",0.5,0.75,txres1)

 ;pres@lbLabelStrings   =   (/"-0.8","-0.6","-0.4","-0.2","0.2","0.4","0.6","0.8"/)

 panel_two_sets(wks,plot(0:1),plot(2:3),(/2,1/),(/2,1/),pres,spres,pres1)
 ;gsn_panel(wks,plot(0:1),(/1,2/),pres)
 ;gsn_panel(wks,plot(2:3),(/1,2/),spres)
 ;frame(wks)

end
