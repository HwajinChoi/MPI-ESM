begin

dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_delcar_mul_dz_1000-3000m_r192x96_1850_2299.nc","r")
delcar=f->delcar
delcar=delcar*1000*365.25*86400

delcar_clim=dim_avg_n_Wrap(delcar,0)
dim=dimsizes(delcar)
delcar_ano=new((/dim(0),dim(1),dim(2)/),typeof(delcar))

do i=0,450-1
 delcar_ano(i,:,:)=delcar(i,:,:)-delcar_clim
end do
copy_VarCoords(delcar,delcar_ano)

delcar_ano_cumsum=dim_cumsum_n_Wrap(delcar_ano,1,0)

First=new((/dim(1),dim(2)/),typeof(delcar))
Middle=new((/dim(1),dim(2)/),typeof(delcar))
Last=new((/dim(1),dim(2)/),typeof(delcar))
Last1=new((/dim(1),dim(2)/),typeof(delcar))
Last2=new((/dim(1),dim(2)/),typeof(delcar))

First=dim_avg_n_Wrap(delcar_ano_cumsum(0:29,:,:),0)
Middle=dim_avg_n_Wrap(delcar_ano_cumsum(135:164,:,:),0)
Last=dim_avg_n_Wrap(delcar_ano_cumsum(270:299,:,:),0)
Last1=dim_avg_n_Wrap(delcar_ano_cumsum(285:314,:,:),0)
Last2=dim_avg_n_Wrap(delcar_ano_cumsum(420:449,:,:),0)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_delcar_cumsum_without_mean_3phases_diff_1000-3000m" )          ; send graphics to PNG file
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
res@cnFillPalette        = "GMT_polar"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@gsnCenterStringFontHeightF= 0.028
res@gsnCenterString="First"
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterStringOrthogonalPosF=0.05
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"
res@lbLabelBarOn           =      False
res@cnMaxLevelValF         =     4
res@cnMinLevelValF         =     -4
res@cnLevelSpacingF        =     0.5 
res@gsnCenterString="Positive phase"
plot(0)=gsn_csm_contour_map(wks,Middle_First,res)
res@gsnCenterString="Negative phase"
plot(1)=gsn_csm_contour_map(wks,Last_Middle,res)
res@gsnCenterString="Zero phase"
plot(2)=gsn_csm_contour_map(wks,Last2_Last1,res)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@lbLabelFontHeightF  = 0.023
pres@pmLabelBarHeightF=0.7
pres@gsnPanelLeft=0.1
pres@lbLabelStride     =   2
pres@lbOrientation        = "vertical"

txres1               = True
txres1@txFontHeightF = 0.018

gsn_text_ndc(wks,"[mol m-2 ]",0.88,0.13,txres1)
gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
