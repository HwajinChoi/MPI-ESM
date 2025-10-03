begin
dir="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir+"test4_tpreformed_DIC_reg_0_100mavg_ym_1850.nc","r")
lon=f->lon
lat=f->lat
tot=f->tpreformed_DIC_tot(0,:,:)
adv=f->tpreformed_DIC_adv(0,:,:)
dif=f->tpreformed_DIC_dif(0,:,:)
gm=f->tpreformed_DIC_gm(0,:,:)
bc=f->tpreformed_DIC_bc(0,:,:)

plot=new(5,graphic)
 wks=gsn_open_wks("png",dir1+"Test4_budget_tpreformed_DIC")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.028
 res@gsnCenterString="(a) Total tendency"
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =     0.0000000006
 res@cnMinLevelValF         =     -0.0000000006
 res@cnLevelSpacingF        =      0.0000000001
 res@lbLabelFontHeightF  = 0.024
 res@cnFillPalette          =       "temp_diff_18lev"
 res@lbLabelStride     =   4
 res@lbLabelBarOn           =      True
 plot(0)=gsn_csm_contour_map(wks,tot,res)
 res@cnMaxLevelValF         =     0.000000003
 res@cnMinLevelValF         =     -0.000000003
 res@cnLevelSpacingF        =      0.0000000005
 res@gsnCenterString="(b) Advection"
 plot(1)=gsn_csm_contour_map(wks,adv,res)
 res@gsnCenterString="(c) Diffusion"
 plot(2)=gsn_csm_contour_map(wks,dif,res)
 res@gsnCenterString="(d) GM"
 plot(3)=gsn_csm_contour_map(wks,gm,res)
 res@gsnCenterString="(e) Boundary condition"
 plot(4)=gsn_csm_contour_map(wks,bc,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 4
 pres@gsnPanelMainString="mean budget terms of tpreformed_DIC (0-100m)"

 gsn_panel(wks,plot,(/3,2/),pres)
 frame(wks)
end
