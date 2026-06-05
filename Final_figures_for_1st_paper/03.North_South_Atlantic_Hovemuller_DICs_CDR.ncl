begin
dir0="/work/uo1451/m301158/MPI-ESM/image/Final_figures/"
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir3="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"

g1=addfile(dir1+"South_Atl_dissic_flat10_cdr_1850-2299_mean.nc","r")
g2=addfile(dir1+"South_Atl_dissicnat_flat10_cdr_1850-2299_mean.nc","r")
south_dic=g1->dissic(:,:,0,0)
south_dicnat=g2->dissicnat(:,:,0,0)

south_dic_an=month_to_annual(south_dic,1)
south_dicnat_an=month_to_annual(south_dicnat,1)
south_dicant_an=south_dic_an-south_dicnat_an
copy_VarCoords(south_dic_an,south_dicant_an)

h1=addfile(dir1+"North_Atl_dissic_flat10_cdr_1850-2299_mean.nc","r")
h2=addfile(dir1+"North_Atl_dissicnat_flat10_cdr_1850-2299_mean.nc","r")
north_dic=h1->dissic(:,:,0,0)
north_dicnat=h2->dissicnat(:,:,0,0)

north_dic_an=month_to_annual(north_dic,1)
north_dicnat_an=month_to_annual(north_dicnat,1)
north_dicant_an=north_dic_an-north_dicnat_an
copy_VarCoords(north_dic_an,north_dicant_an)
;----------  North   PI  ---------------------------------------------------------------
k1=addfile(dir3+"North_Atl_dissic_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
k2=addfile(dir3+"North_Atl_dissicnat_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
north_dic_pi=k1->dissic(:,:,0,0)
north_dicnat_pi=k2->dissicnat(:,:,0,0)
north_dic_pi_clim=dim_avg_n_Wrap(north_dic_pi,0)
north_dicnat_pi_clim=dim_avg_n_Wrap(north_dicnat_pi,0)
;----------  South   PI  ---------------------------------------------------------------
w1=addfile(dir3+"South_Atl_dissic_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
w2=addfile(dir3+"South_Atl_dissicnat_test_pictrl_preform_001_spinup_8920-8949_mean.nc","r")
south_dic_pi=w1->dissic(:,:,0,0)
south_dicnat_pi=w2->dissicnat(:,:,0,0)
south_dic_pi_clim=dim_avg_n_Wrap(south_dic_pi,0)
south_dicnat_pi_clim=dim_avg_n_Wrap(south_dicnat_pi,0)
dim0=dimsizes(north_dic_pi)
;--------------------------------------------------------------------------
south_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(south_dic_pi_clim))
south_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(south_dic_pi_clim))
north_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(south_dic_pi_clim))
north_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(south_dic_pi_clim))

do i=0,450-1
 south_DIC_PI_CLIM(i,:)=south_dic_pi_clim
 south_DICNAT_PI_CLIM(i,:)=south_dicnat_pi_clim
 north_DIC_PI_CLIM(i,:)=north_dic_pi_clim
 north_DICNAT_PI_CLIM(i,:)=north_dicnat_pi_clim
end do
;--------------------------------------------------------------------------
north_dic_an_diff=north_dic_an-north_DIC_PI_CLIM
north_dicnat_an_diff=north_dicnat_an-north_DICNAT_PI_CLIM
copy_VarCoords(north_dic_an,north_dic_an_diff)
copy_VarCoords(north_dicnat_an,north_dicnat_an_diff)

south_dic_an_diff=south_dic_an-south_DIC_PI_CLIM
south_dicnat_an_diff=south_dicnat_an-south_DICNAT_PI_CLIM
copy_VarCoords(south_dic_an,south_dic_an_diff)
copy_VarCoords(south_dicnat_an,south_dicnat_an_diff)

north_dic_an_diff := north_dic_an_diff(depth|:,year|:)
north_dicnat_an_diff := north_dicnat_an_diff(depth|:,year|:)
north_dicant_an := north_dicant_an(depth|:,year|:)

south_dic_an_diff := south_dic_an_diff(depth|:,year|:)
south_dicnat_an_diff := south_dicnat_an_diff(depth|:,year|:)
south_dicant_an := south_dicant_an(depth|:,year|:)

north_dic_an_diff=north_dic_an_diff*1000
north_dicnat_an_diff=north_dicnat_an_diff*1000
north_dicant_an=north_dicant_an*1000
south_dic_an_diff=south_dic_an_diff*1000
south_dicnat_an_diff=south_dicnat_an_diff*1000
south_dicant_an=south_dicant_an*1000
depth=south_dicant_an&depth

x=ispan(1,450,1)
levels=new(13,"float")
do i=0,12
 levels(i)=-120+20*i
end do

plot=new(6,graphic)
wks=gsn_open_wks("png",dir0+"Hovmuller_DICs_North_South_Atlantic")
res                       = True     ; plot mods desired
; Set resources for when we turn on labelbar later
res@gsnFrame               =       False
res@gsnDraw                =       False
res@lbLabelBarOn           = False
res@gsnMaximize          = False
res@lbTitleFontHeightF         = .02                 ; make title smaller
res@lbTitleString              = ""            ; title string
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelStride              = 2
res@lbLabelFontHeightF         = 0.02
res@pmLabelBarHeightF          = 0.4
res@lbBoxEndCapStyle           = "TriangleBothEnds"
res@lbOrientation              = "Vertical"        ; orientation

res@vpWidthF = 0.6
res@vpHeightF = 0.35
;res@pmLabelBarOrthogonalPosF=0.3
res@cnLevelSelectionMode="ManualLevels"
res@cnFillOn              = True     ; turn on color fill
res@cnLinesOn             = False    ; turn of contour lines
res@cnLineLabelsOn        = False    ; turn of contour line labels
res@cnFillPalette         = "GMT_polar"
res@tmYLMode              = "Automatic"
res@gsnCenterStringFontHeightF= 0.035
res@gsnCenterStringOrthogonalPosF=0.08
res@tmXBLabelFontHeightF=0.025
res@tmYLLabelFontHeightF=0.025
res@tiYAxisFontHeightF=0.03
res@tiXAxisFontHeightF=0.03

res@trYReverse            = True     ; reverse the y (time) axis
res@gsnYAxisIrregular2Linear = True
res@cnMissingValFillColor="black"
res@tiYAxisString="Depth (m)"
res@tiXAxisString=""
res@cnInfoLabelOn          =   False

;res@gsnMaximize           = True
;res@gsnPaperOrientation   = "portrait"

res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     120
res@cnMinLevelValF         =     -120
res@cnLevelSpacingF        =      20

dim0=dimsizes(north_dic_an_diff)
plres=True
plres@gsLineThicknessF=2.0
plres@gsLineColor="black"
plx=new(dim0(0),"float")
plx=150.

res@gsnCenterString="(a) North Atlantic"
plot(0)   = gsn_csm_contour(wks,north_dic_an_diff, res)
res@tiYAxisString=""
res@gsnCenterString="(b) South Atlantic"
plot(1)   = gsn_csm_contour(wks,south_dic_an_diff, res)
res@gsnCenterString=""
res@tiYAxisString="Depth (m)"
plot(2)   = gsn_csm_contour(wks,north_dicnat_an_diff, res)
res@tiYAxisString=""
plot(3)   = gsn_csm_contour(wks,south_dicnat_an_diff, res)
res@tiYAxisString="Depth (m)"
res@tiXAxisString="Year"
plot(4)   = gsn_csm_contour(wks,north_dicant_an, res)
res@tiYAxisString=""
plot(5)   = gsn_csm_contour(wks,south_dicant_an, res)

dum0=gsn_add_polyline(wks,plot(0),plx,depth,plres)
dum1=gsn_add_polyline(wks,plot(1),plx,depth,plres)
dum2=gsn_add_polyline(wks,plot(2),plx,depth,plres)
dum3=gsn_add_polyline(wks,plot(3),plx,depth,plres)
dum4=gsn_add_polyline(wks,plot(4),plx,depth,plres)
dum5=gsn_add_polyline(wks,plot(5),plx,depth,plres)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent = 0
pres@gsnPanelXWhiteSpacePercent = 0
pres@pmLabelBarOrthogonalPosF=-0.02
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString=""
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.9
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@pmLabelBarWidthF    = 0.7
pres@lbLabelStride              = 2
;pres@lbOrientation              = "Vertical"        ; orientation

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.020
gsn_text_ndc(wks,"DIC~B~tot~N~",0.05,0.8,txres1)
gsn_text_ndc(wks,"DIC~B~nat~N~",0.05,0.52,txres1)
gsn_text_ndc(wks,"DIC~B~ant~N~",0.05,0.27,txres1)
txres2               = True
txres2@txFontHeightF = 0.015
gsn_text_ndc(wks,"[mmol/m~S~3~N~]",0.9,0.07,txres2)

gsn_panel(wks,plot,(/3,2/),pres)
frame(wks)

end
