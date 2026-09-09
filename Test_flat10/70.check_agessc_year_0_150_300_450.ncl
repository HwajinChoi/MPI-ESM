begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"agessc_r192x96_18500101-22991231.nc","r")
age=f->agessc

age1=dim_max_n_Wrap(age(11,:,:,:),0)
age150=dim_max_n_Wrap(age((12*150)-1,:,:,:),0)
age300=dim_max_n_Wrap(age((12*300)-1,:,:,:),0)
age450=dim_max_n_Wrap(age((12*450)-1,:,:,:),0)

plot=new(4,graphic)

wks   = gsn_open_wks ("png", dir2+"agessc_check_year_0_150_300_450" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnLineLabelsOn       = False                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@lbLabelBarOn           = False
res@gsnFrame               =       False
res@gsnDraw                =       False
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@cnFillPalette        = "BlAqGrYeOrReVi200"
res@lbLabelFontHeightF  = 0.012
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@gsnCenterStringFontHeightF= 0.025
res@gsnCenterString="(a) year 1"
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterStringOrthogonalPosF=0.05
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"
res@cnMaxLevelValF         =     450
res@cnMinLevelValF         =     0
res@cnLevelSpacingF        =      50
plot(0)=gsn_csm_contour_map(wks,age1,res)
res@gsnCenterString="(b) year 150"
plot(1)=gsn_csm_contour_map(wks,age150,res)
res@gsnCenterString="(c) year 300"
plot(2)=gsn_csm_contour_map(wks,age300,res)
res@gsnCenterString="(d) year 450"
plot(3)=gsn_csm_contour_map(wks,age450,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelLabelBar      = True
txres=True
txres@txFontHeightF = 0.014
gsn_text_ndc(wks,"[yr]",0.84,0.035,txres)
gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)

end

