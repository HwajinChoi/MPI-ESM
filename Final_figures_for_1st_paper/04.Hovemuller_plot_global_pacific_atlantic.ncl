begin
dir0="/work/uo1451/m301158/MPI-ESM/image/Final_figures/"
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir3="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"

; glbal, pac, atl
;-----------------
;--Global--------
;-----------------
g1=addfile(dir1+"ocean_mean_dissic_flat10_cdr_1850-2299.nc","r")
g2=addfile(dir1+"ocean_mean_dissicnat_flat10_cdr_1850-2299.nc","r")
ocean_dic_cdr=g1->dissic(:,:,0,0); time(5400) * depth()
ocean_dicnat_cdr=g2->dissicnat(:,:,0,0)

ocean_dic_cdr_an=month_to_annual(ocean_dic_cdr,1)
ocean_dicnat_cdr_an=month_to_annual(ocean_dicnat_cdr,1)
ocean_dicant_cdr_an=ocean_dic_cdr_an-ocean_dicnat_cdr_an
copy_VarCoords(ocean_dic_cdr_an,ocean_dicant_cdr_an)

g01=addfile(dir1+"ocean_mean_preformed_DIC_flat10_cdr_1850-2299.nc","r")
pre_ocean_dic_cdr=g01->preformed_DIC(:,:,0,0)
pre_ocean_dic_cdr=pre_ocean_dic_cdr*1000
reg_ocean_dic_cdr=ocean_dic_cdr-pre_ocean_dic_cdr
copy_VarCoords(pre_ocean_dic_cdr,reg_ocean_dic_cdr)
reg_ocean_dic_cdr_an=month_to_annual(reg_ocean_dic_cdr,1)
;-----------------
;---Pacific-------
;-----------------
h1=addfile(dir1+"pac_mean_dissic_flat10_cdr_1850-2299.nc","r")
h2=addfile(dir1+"pac_mean_dissicnat_flat10_cdr_1850-2299.nc","r")
pac_dic_cdr=h1->dissic(:,:,0,0)
pac_dicnat_cdr=h2->dissicnat(:,:,0,0)

pac_dic_cdr_an=month_to_annual(pac_dic_cdr,1)
pac_dicnat_cdr_an=month_to_annual(pac_dicnat_cdr,1)
pac_dicant_cdr_an=pac_dic_cdr_an-pac_dicnat_cdr_an
copy_VarCoords(pac_dic_cdr_an,pac_dicant_cdr_an)

h01=addfile(dir1+"pac_mean_preformed_DIC_flat10_cdr_1850-2299.nc","r")
pre_pac_dic_cdr=h01->preformed_DIC(:,:,0,0)
pre_pac_dic_cdr=pre_pac_dic_cdr*1000
reg_pac_dic_cdr=pac_dic_cdr-pre_pac_dic_cdr
copy_VarCoords(pre_pac_dic_cdr,reg_pac_dic_cdr)
reg_pac_dic_cdr_an=month_to_annual(reg_pac_dic_cdr,1)
;-----------------
;---Atlantic-------
;-----------------
k1=addfile(dir1+"atl_mean_dissic_flat10_cdr_1850-2299.nc","r")
k2=addfile(dir1+"atl_mean_dissicnat_flat10_cdr_1850-2299.nc","r")
atl_dic_cdr=k1->dissic(:,:,0,0)
atl_dicnat_cdr=k2->dissicnat(:,:,0,0)

atl_dic_cdr_an=month_to_annual(atl_dic_cdr,1)
atl_dicnat_cdr_an=month_to_annual(atl_dicnat_cdr,1)
atl_dicant_cdr_an=atl_dic_cdr_an-atl_dicnat_cdr_an
copy_VarCoords(atl_dic_cdr_an,atl_dicant_cdr_an)

k01=addfile(dir1+"atl_mean_preformed_DIC_flat10_cdr_1850-2299.nc","r")
pre_atl_dic_cdr=k01->preformed_DIC(:,:,0,0)
pre_atl_dic_cdr=pre_atl_dic_cdr*1000
reg_atl_dic_cdr=atl_dic_cdr-pre_atl_dic_cdr
copy_VarCoords(pre_atl_dic_cdr,reg_atl_dic_cdr)
reg_atl_dic_cdr_an=month_to_annual(reg_atl_dic_cdr,1)
;---------------------------------------------------------------------------------------
;----------     Pacific_PI  ---------------------------------------------------------------
;---------------------------------------------------------------------------------------
a1=addfile(dir3+"ocean_mean_dissic_test_pictrl_preform_001_spinup_8920-8949.nc","r")
a2=addfile(dir3+"ocean_mean_dissicnat_test_pictrl_preform_001_spinup_8920-8949.nc","r")
ocean_dic_pi=a1->dissic(:,:,0,0)
ocean_dicnat_pi=a2->dissicnat(:,:,0,0)

b1=addfile(dir3+"pac_mean_dissic_test_pictrl_preform_001_spinup_8920-8949.nc","r")
b2=addfile(dir3+"pac_mean_dissicnat_test_pictrl_preform_001_spinup_8920-8949.nc","r")
pac_dic_pi=b1->dissic(:,:,0,0)
pac_dicnat_pi=b2->dissicnat(:,:,0,0)

c1=addfile(dir3+"atl_mean_dissic_test_pictrl_preform_001_spinup_8920-8949.nc","r")
c2=addfile(dir3+"atl_mean_dissicnat_test_pictrl_preform_001_spinup_8920-8949.nc","r")
atl_dic_pi=c1->dissic(:,:,0,0)
atl_dicnat_pi=c2->dissicnat(:,:,0,0)

ocean_dic_pi_clim=dim_avg_n_Wrap(ocean_dic_pi,0)
ocean_dicnat_pi_clim=dim_avg_n_Wrap(ocean_dicnat_pi,0)
pac_dic_pi_clim=dim_avg_n_Wrap(pac_dic_pi,0)
pac_dicnat_pi_clim=dim_avg_n_Wrap(pac_dicnat_pi,0)
atl_dic_pi_clim=dim_avg_n_Wrap(atl_dic_pi,0)
atl_dicnat_pi_clim=dim_avg_n_Wrap(atl_dicnat_pi,0)

dim0=dimsizes(pac_dic_pi)

PAC_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pac_dic_pi_clim))
PAC_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(pac_dic_pi_clim))

OCEAN_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(ocean_dic_pi_clim))
OCEAN_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(ocean_dic_pi_clim))

ATL_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pac_dic_pi_clim))
ATL_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(pac_dic_pi_clim))

do i=0,450-1
 OCEAN_DIC_PI_CLIM(i,:)=ocean_dic_pi_clim
 OCEAN_DICNAT_PI_CLIM(i,:)=ocean_dicnat_pi_clim
 PAC_DIC_PI_CLIM(i,:)=pac_dic_pi_clim
 PAC_DICNAT_PI_CLIM(i,:)=pac_dicnat_pi_clim
 ATL_DIC_PI_CLIM(i,:)=atl_dic_pi_clim
 ATL_DICNAT_PI_CLIM(i,:)=atl_dicnat_pi_clim
end do

;=== MAIN VARIABLES for figures
atl_dic_cdr_an_diff=atl_dic_cdr_an-ATL_DIC_PI_CLIM
copy_VarCoords(atl_dic_cdr_an,atl_dic_cdr_an_diff)
pac_dic_cdr_an_diff=pac_dic_cdr_an-PAC_DIC_PI_CLIM
copy_VarCoords(pac_dic_cdr_an,pac_dic_cdr_an_diff)
ocean_dic_cdr_an_diff=ocean_dic_cdr_an-OCEAN_DIC_PI_CLIM
copy_VarCoords(ocean_dic_cdr_an,ocean_dic_cdr_an_diff)
atl_dicnat_cdr_an_diff=atl_dicnat_cdr_an-ATL_DICNAT_PI_CLIM
copy_VarCoords(atl_dicnat_cdr_an,atl_dicnat_cdr_an_diff)
pac_dicnat_cdr_an_diff=pac_dicnat_cdr_an-PAC_DICNAT_PI_CLIM
copy_VarCoords(pac_dicnat_cdr_an,pac_dicnat_cdr_an_diff)
ocean_dicnat_cdr_an_diff=ocean_dicnat_cdr_an-OCEAN_DICNAT_PI_CLIM
copy_VarCoords(ocean_dicnat_cdr_an,ocean_dicnat_cdr_an_diff)
;==========================================================================================
a01=addfile(dir3+"pac_mean_preformed_DIC_test_pictrl_preform_001_spinup_8920-8949.nc","r")
pac_pre_dic_pi=a01->preformed_DIC(:,:,0,0)
pac_pre_dic_pi=pac_pre_dic_pi*1000
pac_reg_dic_pi=pac_dic_pi-pac_pre_dic_pi
copy_VarCoords(pac_dic_pi,pac_reg_dic_pi)

a02=addfile(dir3+"ocean_mean_preformed_DIC_test_pictrl_preform_001_spinup_8920-8949.nc","r")
ocean_pre_dic_pi=a02->preformed_DIC(:,:,0,0)
ocean_pre_dic_pi=ocean_pre_dic_pi*1000
ocean_reg_dic_pi=ocean_dic_pi-ocean_pre_dic_pi
copy_VarCoords(ocean_dic_pi,ocean_reg_dic_pi)

a03=addfile(dir3+"atl_mean_preformed_DIC_test_pictrl_preform_001_spinup_8920-8949.nc","r")
atl_pre_dic_pi=a03->preformed_DIC(:,:,0,0)
atl_pre_dic_pi=atl_pre_dic_pi*1000
atl_reg_dic_pi=atl_dic_pi-atl_pre_dic_pi
copy_VarCoords(atl_dic_pi,atl_reg_dic_pi)

pac_reg_dic_pi_clim=dim_avg_n_Wrap(pac_reg_dic_pi,0)
atl_reg_dic_pi_clim=dim_avg_n_Wrap(atl_reg_dic_pi,0)
ocean_reg_dic_pi_clim=dim_avg_n_Wrap(ocean_reg_dic_pi,0)

dim0=dimsizes(pac_pre_dic_pi)
PAC_REG_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pac_reg_dic_pi_clim))
ATL_REG_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pac_reg_dic_pi_clim))
OCEAN_REG_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(pac_reg_dic_pi_clim))

do i=0,450-1
 PAC_REG_DIC_PI_CLIM(i,:)=pac_reg_dic_pi_clim
 ATL_REG_DIC_PI_CLIM(i,:)=atl_reg_dic_pi_clim
 OCEAN_REG_DIC_PI_CLIM(i,:)=ocean_reg_dic_pi_clim
end do
;=== MAIN VARIABLES for figures
reg_pac_dic_cdr_an_diff=reg_pac_dic_cdr_an-PAC_REG_DIC_PI_CLIM
copy_VarCoords(reg_pac_dic_cdr_an,reg_pac_dic_cdr_an_diff)
reg_atl_dic_cdr_an_diff=reg_atl_dic_cdr_an-ATL_REG_DIC_PI_CLIM
copy_VarCoords(reg_atl_dic_cdr_an,reg_atl_dic_cdr_an_diff)
reg_ocean_dic_cdr_an_diff=reg_ocean_dic_cdr_an-OCEAN_REG_DIC_PI_CLIM
copy_VarCoords(reg_ocean_dic_cdr_an,reg_ocean_dic_cdr_an_diff)

;===================================================================
reg_pac_dic_cdr_an_diff := reg_pac_dic_cdr_an_diff(depth|:,year|:)
reg_atl_dic_cdr_an_diff := reg_atl_dic_cdr_an_diff(depth|:,year|:)
reg_ocean_dic_cdr_an_diff := reg_ocean_dic_cdr_an_diff(depth|:,year|:)

atl_dic_cdr_an_diff := atl_dic_cdr_an_diff(depth|:,year|:)
pac_dic_cdr_an_diff := pac_dic_cdr_an_diff(depth|:,year|:)
ocean_dic_cdr_an_diff := ocean_dic_cdr_an_diff(depth|:,year|:)
atl_dicnat_cdr_an_diff := atl_dicnat_cdr_an_diff(depth|:,year|:)
pac_dicnat_cdr_an_diff := pac_dicnat_cdr_an_diff(depth|:,year|:)
ocean_dicnat_cdr_an_diff := ocean_dicnat_cdr_an_diff(depth|:,year|:)

ocean_dicant_cdr_an := ocean_dicant_cdr_an(depth|:,year|:)
pac_dicant_cdr_an := pac_dicant_cdr_an(depth|:,year|:)
atl_dicant_cdr_an := atl_dicant_cdr_an(depth|:,year|:)

atl_dic_cdr_an_diff=atl_dic_cdr_an_diff*1000
pac_dic_cdr_an_diff=pac_dic_cdr_an_diff*1000
ocean_dic_cdr_an_diff=ocean_dic_cdr_an_diff*1000
atl_dicnat_cdr_an_diff=atl_dicnat_cdr_an_diff*1000
pac_dicnat_cdr_an_diff=pac_dicnat_cdr_an_diff*1000
ocean_dicnat_cdr_an_diff=ocean_dicnat_cdr_an_diff*1000
atl_dicant_cdr_an=atl_dicant_cdr_an*1000
pac_dicant_cdr_an=pac_dicant_cdr_an*1000
ocean_dicant_cdr_an=ocean_dicant_cdr_an*1000
reg_pac_dic_cdr_an_diff=reg_pac_dic_cdr_an_diff*1000
reg_atl_dic_cdr_an_diff=reg_atl_dic_cdr_an_diff*1000
reg_ocean_dic_cdr_an_diff=reg_ocean_dic_cdr_an_diff*1000
depth=atl_dic_cdr_an_diff&depth

x=ispan(1,450,1)
levels=new(13,"float")
do i=0,12
 levels(i)=-120+20*i
end do

plot=new(12,graphic)
wks=gsn_open_wks("png",dir0+"Hovmuller_DICs_Global_Pacific_Atlantic")
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
res@pmLabelBarHeightF          = 0.5
res@lbBoxEndCapStyle           = "TriangleBothEnds"
res@lbOrientation              = "Vertical"        ; orientation

res@vpWidthF = 0.7
res@vpHeightF = 0.4
;res@pmLabelBarOrthogonalPosF=0.3
res@cnLevelSelectionMode="ManualLevels"
res@cnFillOn              = True     ; turn on color fill
res@cnLinesOn             = False    ; turn of contour lines
res@cnLineLabelsOn        = False    ; turn of contour line labels
res@cnFillPalette         = "GMT_polar"
res@tmYLMode              = "Automatic"
res@gsnCenterStringFontHeightF= 0.060
res@gsnCenterStringOrthogonalPosF=0.10
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.05
res@tiXAxisFontHeightF=0.05

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

dim0=dimsizes(ocean_dic_cdr_an_diff)

plres=True
plres@gsLineThicknessF=2.0
plres@gsLineColor="black"
plx=new(dim0(0),"float")
plx=150.

plres2=True
plres2@gsLineThicknessF=2.0
plres2@gsLineColor="black"
plres2@gsLineDashPattern=1
plx2=new(dim0(0),"float")
plx2=300.

res@tiYAxisString=""
res@tmXBLabelsOn        = False
res@gsnCenterString="(a) DIC~B~tot~N~"
plot(0)   = gsn_csm_contour(wks,ocean_dic_cdr_an_diff, res)
res@tiYAxisString=""
res@tmYLLabelsOn        = False
res@gsnCenterString="(b) DIC~B~ant~N~"
plot(1)   = gsn_csm_contour(wks,ocean_dicant_cdr_an, res)
res@gsnCenterString="(c) DIC~B~nat~N~"
plot(2)   = gsn_csm_contour(wks,ocean_dicnat_cdr_an_diff, res)
res@gsnCenterString="(d) DIC~B~reg~N~"
plot(3)   = gsn_csm_contour(wks,reg_ocean_dic_cdr_an_diff, res)
res@gsnCenterString=""
res@tmYLLabelsOn        = True
plot(4)   = gsn_csm_contour(wks,pac_dic_cdr_an_diff, res)
res@tiYAxisString=""
res@tmYLLabelsOn        = False
plot(5)   = gsn_csm_contour(wks,pac_dicant_cdr_an, res)
plot(6)   = gsn_csm_contour(wks,pac_dicnat_cdr_an_diff, res)
plot(7)   = gsn_csm_contour(wks,reg_pac_dic_cdr_an_diff, res)
res@tiXAxisString="Year"
res@tmYLLabelsOn        = True
res@tmXBLabelsOn        = True
plot(8)   = gsn_csm_contour(wks,atl_dic_cdr_an_diff, res)
res@tiYAxisString=""
res@tmYLLabelsOn        = False
plot(9)   = gsn_csm_contour(wks,atl_dicant_cdr_an, res)
plot(10)   = gsn_csm_contour(wks,atl_dicnat_cdr_an_diff, res)
plot(11)   = gsn_csm_contour(wks,reg_atl_dic_cdr_an_diff, res)

dum0=gsn_add_polyline(wks,plot(0),plx,depth,plres)
dum1=gsn_add_polyline(wks,plot(1),plx,depth,plres)
dum2=gsn_add_polyline(wks,plot(2),plx,depth,plres)
dum3=gsn_add_polyline(wks,plot(3),plx,depth,plres)
dum4=gsn_add_polyline(wks,plot(4),plx,depth,plres)
dum5=gsn_add_polyline(wks,plot(5),plx,depth,plres)
dum6=gsn_add_polyline(wks,plot(6),plx,depth,plres)
dum7=gsn_add_polyline(wks,plot(7),plx,depth,plres)
dum8=gsn_add_polyline(wks,plot(8),plx,depth,plres)
dum9=gsn_add_polyline(wks,plot(9),plx,depth,plres)
dum10=gsn_add_polyline(wks,plot(10),plx,depth,plres)
dum11=gsn_add_polyline(wks,plot(11),plx,depth,plres)

dum00=gsn_add_polyline(wks,plot(0),plx2,depth,plres2)
dum01=gsn_add_polyline(wks,plot(1),plx2,depth,plres2)
dum02=gsn_add_polyline(wks,plot(2),plx2,depth,plres2)
dum03=gsn_add_polyline(wks,plot(3),plx2,depth,plres2)
dum04=gsn_add_polyline(wks,plot(4),plx2,depth,plres2)
dum05=gsn_add_polyline(wks,plot(5),plx2,depth,plres2)
dum06=gsn_add_polyline(wks,plot(6),plx2,depth,plres2)
dum07=gsn_add_polyline(wks,plot(7),plx2,depth,plres2)
dum08=gsn_add_polyline(wks,plot(8),plx2,depth,plres2)
dum09=gsn_add_polyline(wks,plot(9),plx2,depth,plres2)
dum010=gsn_add_polyline(wks,plot(10),plx2,depth,plres2)
dum011=gsn_add_polyline(wks,plot(11),plx2,depth,plres2)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent =0
pres@gsnPanelXWhiteSpacePercent =0
pres@pmLabelBarOrthogonalPosF=-0.02
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString=""
pres@gsnPanelLeft=0.05
pres@gsnPanelRight=0.95
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@pmLabelBarWidthF    = 0.8
pres@lbLabelStride              = 2
;pres@lbOrientation              = "Vertical"        ; orientation

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.016
gsn_text_ndc(wks,"Global",0.026,0.65,txres1)
gsn_text_ndc(wks,"Pacific",0.026,0.51,txres1)
gsn_text_ndc(wks,"Atlantic",0.026,0.36,txres1)

txres3               = True
txres3@txFontHeightF = 0.012
gsn_text_ndc(wks,"Depth",0.08,0.71,txres3)

txres2               = True
txres2@txFontHeightF = 0.012
gsn_text_ndc(wks,"[mmol/m~S~3~N~]",0.95,0.25,txres2)
gsn_panel(wks,plot,(/3,4/),pres)
frame(wks)
end
