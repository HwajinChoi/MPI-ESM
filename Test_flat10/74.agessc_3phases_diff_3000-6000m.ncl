; export NCARG_COLORMAPS=/work/uo1451/m301158/MPI-ESM/code/Test_flat10:$NCARG_ROOT/lib/ncarg/colormaps/

begin
dir0="/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"age_185012-229912_3000_6000m_r192x96.nc","r")
agessc=f->agessc ; time * lat

First=dim_avg_n_Wrap(agessc(0:29,:,:),0)
Middle=dim_avg_n_Wrap(agessc(135:164,:,:),0)
Last=dim_avg_n_Wrap(agessc(270:299,:,:),0)
Last1=dim_avg_n_Wrap(agessc(285:314,:,:),0)
Last2=dim_avg_n_Wrap(agessc(420:449,:,:),0)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)
printMinMax(Middle_First,0)
printMinMax(Last_Middle,0)
printMinMax(Last2_Last1,0)

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"agessc_map_changes_3phases_3000-6000m" )          ; send graphics to PNG file
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

res@cnFillPalette        = "test_colorbar3"
res@lbLabelBarOn           = False
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =    150
res@cnMinLevelValF         =     -50
res@cnLevelSpacingF        =      5
res@gsnCenterString="(a) Positive emissions"
plot(0)  = gsn_csm_contour_map(wks, Middle_First, res )   ; plaace holder
res@gsnCenterString="(b) Negative emissions"
plot(1)  = gsn_csm_contour_map(wks, Last_Middle, res )   ; plaace holder
res@gsnCenterString="(c) Zero emissions"
plot(2)  = gsn_csm_contour_map(wks, Last2_Last1, res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       False
pres@gsnPanelLabelBar      = True

gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)
end
