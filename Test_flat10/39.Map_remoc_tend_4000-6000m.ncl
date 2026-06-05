begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_remoc_mul_dz_4000-6000m_r192x96_185001_229912.nc","r")
remoc=f->remoc
Inc=remoc(0:149,:,:)
Dec=remoc(150:299,:,:)
Zec=remoc(300:449,:,:)

Inc_avg=dim_avg_n_Wrap(Inc,0)
Dec_avg=dim_avg_n_Wrap(Dec,0)
Zec_avg=dim_avg_n_Wrap(Zec,0)

Inc_avg=Inc_avg*1000*1000
Dec_avg=Dec_avg*1000*1000
Zec_avg=Zec_avg*1000*1000

plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"Map_CDR_remoc_3phases_tend_4000-6000m" )          ; send graphics to PNG file
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
res@cnFillPalette        = "cmocean_amp"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.025
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"
res@lbLabelBarOn           = True
res@gsnCenterString="Positive emissions"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     16.
res@cnMinLevelValF         =     0.
res@cnLevelSpacingF        =      2
;printMinMax(Inc_avg(0,:,:),0)
;exit
plot(0)  = gsn_csm_contour_map(wks, Inc_avg, res )   ; plaace holder
res@gsnCenterString="Negative emission"
plot(1)  = gsn_csm_contour_map(wks, Dec_avg,res )   ; plaace holder
res@gsnCenterString="Zero emission"
plot(2)  = gsn_csm_contour_map(wks, Zec_avg,res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelLabelBar      = False

txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[micro mol/m~S~2~N~ s~S~1~N~]",0.80,0.97,txres2)


gsn_panel(wks,plot,(/3,1/),pres)
frame(wks)

end
