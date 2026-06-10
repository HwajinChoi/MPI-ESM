begin
dir2="/work/uo1451/m301158/MPI-ESM/image/"
dir4="/work/uo1451/m301158/MPI-ESM/code/flat10_with_pref/test_imsi/for_Hovemuller_with_SO/"
dir3="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"

;-----------------
;---Indian-------
;-----------------
h1=addfile(dir4+"ind_mean_dissic_nonSO40_flat10_cdr_1850-2299.nc","r")
h2=addfile(dir4+"ind_mean_dissicnat_nonSO40_flat10_cdr_1850-2299.nc","r")
ind_dic_cdr=h1->dissic(:,:,0,0)
ind_dicnat_cdr=h2->dissicnat(:,:,0,0)

ind_dic_cdr_an=month_to_annual(ind_dic_cdr,1)
ind_dicnat_cdr_an=month_to_annual(ind_dicnat_cdr,1)
ind_dicant_cdr_an=ind_dic_cdr_an-ind_dicnat_cdr_an
copy_VarCoords(ind_dic_cdr_an,ind_dicant_cdr_an)

h01=addfile(dir4+"ind_mean_preformed_DIC_nonSO40_flat10_cdr_1850-2299.nc","r")
pre_ind_dic_cdr=h01->preformed_DIC(:,:,0,0)
pre_ind_dic_cdr=pre_ind_dic_cdr*1000
reg_ind_dic_cdr=ind_dic_cdr-pre_ind_dic_cdr
copy_VarCoords(pre_ind_dic_cdr,reg_ind_dic_cdr)
reg_ind_dic_cdr_an=month_to_annual(reg_ind_dic_cdr,1)
pre_ind_dic_cdr_an=month_to_annual(pre_ind_dic_cdr,1)
;---------------------------------------------------------------------------------------
;----------     Indian_PI  ---------------------------------------------------------------
;---------------------------------------------------------------------------------------
b1=addfile(dir4+"ind_mean_dissic_nonSO40_test_pictrl_preform_001_spinup_8920-8949.nc","r")
b2=addfile(dir4+"ind_mean_dissicnat_nonSO40_test_pictrl_preform_001_spinup_8920-8949.nc","r")
ind_dic_pi=b1->dissic(:,:,0,0)
ind_dicnat_pi=b2->dissicnat(:,:,0,0)

ind_dic_pi_clim=dim_avg_n_Wrap(ind_dic_pi,0)
ind_dicnat_pi_clim=dim_avg_n_Wrap(ind_dicnat_pi,0)

dim0=dimsizes(ind_dic_pi)

IND_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(ind_dic_pi_clim))
IND_DICNAT_PI_CLIM=new((/450,dim0(1)/),typeof(ind_dic_pi_clim))

do i=0,450-1
 IND_DIC_PI_CLIM(i,:)=ind_dic_pi_clim
 IND_DICNAT_PI_CLIM(i,:)=ind_dicnat_pi_clim
end do

;=== MAIN VARIABLES for figures
ind_dic_cdr_an_diff=ind_dic_cdr_an-IND_DIC_PI_CLIM
copy_VarCoords(ind_dic_cdr_an,ind_dic_cdr_an_diff)
ind_dicnat_cdr_an_diff=ind_dicnat_cdr_an-IND_DICNAT_PI_CLIM
copy_VarCoords(ind_dicnat_cdr_an,ind_dicnat_cdr_an_diff)
;==========================================================================================
a01=addfile(dir4+"ind_mean_preformed_DIC_nonSO40_test_pictrl_preform_001_spinup_8920-8949.nc","r")
ind_pre_dic_pi=a01->preformed_DIC(:,:,0,0)
ind_pre_dic_pi=ind_pre_dic_pi*1000
ind_reg_dic_pi=ind_dic_pi-ind_pre_dic_pi
copy_VarCoords(ind_dic_pi,ind_reg_dic_pi)
ind_reg_dic_pi_clim=dim_avg_n_Wrap(ind_reg_dic_pi,0)
ind_pre_dic_pi_clim=dim_avg_n_Wrap(ind_pre_dic_pi,0)
dim0=dimsizes(ind_pre_dic_pi)
IND_REG_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(ind_reg_dic_pi_clim))
IND_PRE_DIC_PI_CLIM=new((/450,dim0(1)/),typeof(ind_pre_dic_pi_clim))

do i=0,450-1
 IND_REG_DIC_PI_CLIM(i,:)=ind_reg_dic_pi_clim
 IND_PRE_DIC_PI_CLIM(i,:)=ind_pre_dic_pi_clim
end do
;=== MAIN VARIABLES for figures
reg_ind_dic_cdr_an_diff=reg_ind_dic_cdr_an-IND_REG_DIC_PI_CLIM
copy_VarCoords(reg_ind_dic_cdr_an,reg_ind_dic_cdr_an_diff)

pre_ind_dic_cdr_an_diff=pre_ind_dic_cdr_an-IND_REG_DIC_PI_CLIM
copy_VarCoords(pre_ind_dic_cdr_an,pre_ind_dic_cdr_an_diff)
;===================================================================
pre_ind_dic_cdr_an_diff := pre_ind_dic_cdr_an_diff(depth|:,year|:)
reg_ind_dic_cdr_an_diff := reg_ind_dic_cdr_an_diff(depth|:,year|:)
ind_dic_cdr_an_diff := ind_dic_cdr_an_diff(depth|:,year|:)
ind_dicnat_cdr_an_diff := ind_dicnat_cdr_an_diff(depth|:,year|:)
ind_dicant_cdr_an := ind_dicant_cdr_an(depth|:,year|:)

ind_dic_cdr_an_diff=ind_dic_cdr_an_diff*1000
ind_dicnat_cdr_an_diff=ind_dicnat_cdr_an_diff*1000
ind_dicant_cdr_an=ind_dicant_cdr_an*1000
reg_ind_dic_cdr_an_diff=reg_ind_dic_cdr_an_diff*1000
depth=ind_dic_cdr_an_diff&depth

pre_ind_dic_cdr_an_diff=pre_ind_dic_cdr_an_diff*1000

x=ispan(1,450,1)

levels=new(13,"float")
do i=0,12
 levels(i)=-120+20*i
end do

plot=new(4,graphic)
wks=gsn_open_wks("png",dir2+"Supple_Hovmuller_DICs_Indian_with_SO_40")
res                       = True     ; plot mods desired
; Set resources for when we turn on labelbar later
res@gsnFrame               =       False
res@gsnDraw                =       False
res@lbLabelBarOn           = False
res@gsnMaximize          = False
res@lbTitleFontHeightF         = .04                 ; make title smaller
res@lbTitleString              = ""            ; title string
res@lbTitlePosition            = "Right"            ; title position
res@lbTitleDirection           = "Across"            ; title direction
res@lbLabelStride              = 2
res@lbLabelFontHeightF         = 0.2
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
res@cnFillPalette         = "test_jin"
res@tmYLMode              = "Automatic"
;res@gsnCenterStringFontHeightF= 0.060
;res@gsnCenterStringOrthogonalPosF=0.10
res@gsnLeftStringFontHeightF= 0.05
res@gsnLeftStringOrthogonalPosF=0.10
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.05
res@tiXAxisFontHeightF=0.05

res@trYReverse            = True     ; reverse the y (time) axis
res@gsnYAxisIrregular2Linear = True
res@cnMissingValFillColor="black"
res@tiYAxisString="Depth (m)"
res@cnInfoLabelOn          =   False

;res@gsnMaximize           = True
;res@gsnPaperOrientation   = "portrait"

res@cnLevelSelectionMode   =       "ManualLevels"
res@cnMaxLevelValF         =     100
res@cnMinLevelValF         =     -40
res@cnLevelSpacingF        =      10

dim0=dimsizes(ind_dic_cdr_an_diff)

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
res@tmXBLabelsOn        = False
res@gsnLeftString="(b) DIC~B~tot~N~"
res@tmYLLabelsOn        = True
plot(0)   = gsn_csm_contour(wks,ind_dic_cdr_an_diff, res)
res@tiYAxisString=""
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnLeftString="(c) DIC~B~nat~N~"
plot(1)   = gsn_csm_contour(wks,ind_dicnat_cdr_an_diff, res)
res@tmYLLabelsOn        = True
res@tiYAxisString="Depth (m)"
res@gsnLeftString="(d) DIC~B~ant~N~"
res@tiXAxisString="Year"
res@tmXBLabelsOn        = True
plot(2)   = gsn_csm_contour(wks,ind_dicant_cdr_an, res)
res@tmYLLabelsOn        = False
res@tiYAxisString=""
res@gsnLeftString="(e) DIC~B~reg~N~"
plot(3)   = gsn_csm_contour(wks,reg_ind_dic_cdr_an_diff, res)

dum0=gsn_add_polyline(wks,plot(0),plx,depth,plres)
dum1=gsn_add_polyline(wks,plot(1),plx,depth,plres)
dum2=gsn_add_polyline(wks,plot(2),plx,depth,plres)
dum3=gsn_add_polyline(wks,plot(3),plx,depth,plres)
dum00=gsn_add_polyline(wks,plot(0),plx2,depth,plres2)
dum01=gsn_add_polyline(wks,plot(1),plx2,depth,plres2)
dum02=gsn_add_polyline(wks,plot(2),plx2,depth,plres2)
dum03=gsn_add_polyline(wks,plot(3),plx2,depth,plres2)

pres                       =   True
pres@gsnFrame         = False
pres@gsnPanelLabelBar      = True
pres@gsnMaximize        =       False
pres@gsnPanelYWhiteSpacePercent =10
pres@gsnPanelXWhiteSpacePercent =0
pres@pmLabelBarOrthogonalPosF=-0.015
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelMainString=""
pres@gsnPanelLeft=0.05
pres@gsnPanelRight=0.95
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels
pres@pmLabelBarWidthF    = 0.75
pres@lbLabelStride              = 2
pres@lbLabelFontHeightF         = 0.02
;txres3               = True
;txres3@txFontHeightF = 0.02
;gsn_text_ndc(wks,"Depth",0.10,0.8,txres3)

txres2               = True
txres2@txFontHeightF = 0.02
gsn_text_ndc(wks,"[mmol/m~S~3~N~]",0.93,0.13,txres2)

;txres4               = True
;txres4@txFontHeightF = 0.016
;gsn_text_ndc(wks,"DIC~B~tot~N~",0.20,0.82,txres4)
;gsn_text_ndc(wks,"DIC~B~ant~N~",0.425,0.82,txres4)
;gsn_text_ndc(wks,"DIC~B~nat~N~",0.65,0.82,txres4)
;gsn_text_ndc(wks,"DIC~B~reg~N~",0.875,0.82,txres4)

gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)

end
