begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
;------------------------------------------------------
levels=new(21,"float")

do i=0,20
 levels(i)=-0.25+0.025*i
end do
;------------------------------------------------------
u=addfile(dir0+"atlantic_moc_test_flat10_001_cfcs_ideal_mpiom_data_moc_mm_18500101_21491231.nc","r")
u1=addfile(dir0+"atlantic_moc_test_flat10_zec_001_cfcs_ideal_mpiom_data_moc_mm_18500101_21491231.nc","r")
u2=addfile(dir0+"atlantic_moc_test_flat10_cdr_001_cfcs_ideal_mpiom_data_moc_mm_18500101_21491231.nc","r")
flt_moc=u->atlantic_moc(:,:,:,0)
flt_zec_moc=u1->atlantic_moc(:,:,:,0)
flt_cdr_moc=u2->atlantic_moc(:,:,:,0)
depth_2=u->depth_2
lat=u->lat

flt_moc_an=month_to_annual(flt_moc,1)
flt_zec_moc_an=month_to_annual(flt_zec_moc,1) ;year x depth x lat
flt_cdr_moc_an=month_to_annual(flt_cdr_moc,1)
dim=dimsizes(flt_moc_an)

First_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
First_moc=dim_avg_n_Wrap(flt_moc_an(0:29,:,:),0)
Last_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
Last_moc=dim_avg_n_Wrap(flt_moc_an(270:299,:,:),0)
Last_First_moc=Last_moc-First_moc
copy_VarCoords(Last_moc,Last_First_moc)

flat10=new((/3,dim(1),dim(2)/),typeof(First_moc))
flat10(0,:,:)=First_moc
flat10(1,:,:)=Last_moc
flat10(2,:,:)=Last_First_moc
flat10!0="period"

First_zec_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
First_zec_moc=dim_avg_n_Wrap(flt_zec_moc_an(0:29,:,:),0)
Last_zec_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
Last_zec_moc=dim_avg_n_Wrap(flt_zec_moc_an(270:299,:,:),0)
Last_First_zec_moc=Last_zec_moc-First_zec_moc
copy_VarCoords(Last_zec_moc,Last_First_zec_moc)

flat10_zec=new((/3,dim(1),dim(2)/),typeof(First_moc))
flat10_zec(0,:,:)=First_zec_moc
flat10_zec(1,:,:)=Last_zec_moc
flat10_zec(2,:,:)=Last_First_zec_moc
flat10_zec!0="period"

First_cdr_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
First_cdr_moc=dim_avg_n_Wrap(flt_cdr_moc_an(0:29,:,:),0)
Middle_cdr_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
Middle_cdr_moc=dim_avg_n_Wrap(flt_cdr_moc_an(135:164,:,:),0)
Last_cdr_moc=new((/dim(1),dim(2)/),typeof(flt_moc_an))
Last_cdr_moc=dim_avg_n_Wrap(flt_cdr_moc_an(270:299,:,:),0)
Last_First_cdr_moc=Last_cdr_moc-First_cdr_moc
copy_VarCoords(Last_cdr_moc,Last_First_cdr_moc)

Middle_First_cdr_moc=Middle_cdr_moc-First_cdr_moc
Last_Middle_cdr_moc=Last_cdr_moc-Middle_cdr_moc
copy_VarCoords(Last_cdr_moc,Middle_First_cdr_moc)
copy_VarCoords(Last_cdr_moc,Last_Middle_cdr_moc)

CDR_moc=new((/2,dim(1),dim(2)/),typeof(First_moc))
CDR_moc(0,:,:)=Middle_First_cdr_moc
CDR_moc(1,:,:)=Last_Middle_cdr_moc
CDR_moc!0="scenarios"

flat10_cdr=new((/3,dim(1),dim(2)/),typeof(First_moc))
flat10_cdr(0,:,:)=First_cdr_moc
flat10_cdr(1,:,:)=Last_cdr_moc
flat10_cdr(2,:,:)=Last_First_cdr_moc
flat10_cdr!0="period"

CDR_moc=CDR_moc/(1025.*10^6)
CDR_moc@units="Sv (10^6 m^3/s)"

flat10=flat10/(1025.*10^6)
flat10_zec=flat10_zec/(1025.*10^6)
flat10_cdr = flat10_cdr/(1025.*10^6)
flat10@units="Sv (10^6 m^3/s)"
flat10_cdr@units="Sv (10^6 m^3/s)"
flat10_zec@units="Sv (10^6 m^3/s)"
printMinMax(flat10_cdr(0:1,:,:),0)
printMinMax(flat10_cdr(2,:,:),0)

system("rm -f "+dir0+"AMOC_simulations_CDR_First_Middle_Last_diff_300years.nc")
ggg=addfile(    dir0+"AMOC_simulations_CDR_First_Middle_Last_diff_300years.nc","c")
ggg->CDR_moc=CDR_moc
ggg->lat=lat
ggg->depth_2=depth_2
;exit


;------------------------------------------------------
plot=new(6,graphic)
plot1=new(3,graphic)
wks   = gsn_open_wks ("pdf", dir1+"2D_vertical_flat10mip_AMOC_Last_First" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@cnLineLabelsOn         =       False
res@cnLinesOn=False
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@trYReverse =True
res@vpWidthF       = 0.65            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@tmYLLabels =(..)
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnYAxisIrregular2Linear = True ;-- converts irreg depth to linear
res@gsnCenterStringFontHeightF= 0.043
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.03
res@tmYLLabelFontHeightF=0.03
res@tiYAxisFontHeightF=0.03
res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     20
res@cnMinLevelValF         =     -4
res@cnLevelSpacingF        =      2.
res@tiYAxisString="Depth (m)"
res@cnFillPalette        = "BlAqGrYeOrRe"
res1=res
res1@gsnCenterString=""
res1@gsnRightString=""
res1@gsnLeftString=""
res1@cnFillPalette        = "GMT_polar"
res1@cnLevelSelectionMode   =       "ManualLevels"
res1@cnMaxLevelValF         =     4
res1@cnMinLevelValF         =     -4
res1@cnLevelSpacingF        =      1.
res@gsnCenterString="(a) flat10"
res@gsnLeftString=""
res@gsnRightString=""
res@tiYAxisOn=True
plot(0)  = gsn_csm_contour(wks, flat10(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(3)  = gsn_csm_contour(wks, flat10(1,:,:), res )   ; plaace holder
plot1(0)  = gsn_csm_contour(wks, flat10(2,:,:), res1 )   ; plaace holder
res@tiYAxisString=""
res@tmYLLabelsOn	= False
res@gsnCenterString="(b) flat10-zec"
plot(1)  = gsn_csm_contour(wks, flat10_zec(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(4)  = gsn_csm_contour(wks, flat10_zec(1,:,:), res )   ; plaace holder
plot1(1)  = gsn_csm_contour(wks, flat10_zec(2,:,:), res1 )   ; plaace holder
res@gsnCenterString="(c) flat10-cdr"
plot(2)  = gsn_csm_contour(wks, flat10_cdr(0,:,:), res )   ; plaace holder
res@gsnCenterString=""
plot(5)  = gsn_csm_contour(wks, flat10_cdr(1,:,:), res )   ; plaace holder
plot1(2)  = gsn_csm_contour(wks, flat10_cdr(2,:,:), res1 )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@gsnMaximize        =       False
;pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@lbLabelFontHeightF  = 0.013
pres@pmLabelBarHeightF=0.4
pres@gsnPanelLeft=0.1
pres@lbLabelStride     =   4
pres@lbOrientation        = "vertical"
pres2=pres
pres2@pmLabelBarHeightF=0.2
pres@gsnPanelMainString="AMOC"
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelTop=0.9
pres@gsnPanelBottom=0.25
pres2@gsnPanelTop=0.3
pres2@gsnPanelBottom=0.1

txres1               = True
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"First",0.05,0.68,txres1)
gsn_text_ndc(wks,"Last",0.05,0.46,txres1)
gsn_text_ndc(wks,"Diff",0.05,0.22,txres1)
gsn_text_ndc(wks,"(Last-First)",0.05,0.20,txres1)
txres1@txFontHeightF = 0.014

gsn_text_ndc(wks,"[Sv]",0.95,0.35,txres1)

gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot1,(/1,3/),pres2)
frame(wks)
end
