begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"test_flat10_001_cfcs_ideal_r192x96_intpp_18500101_21491231.nc","r")
flt_npp=f->intpp(:,0,:,:)
g=addfile(dir0+"test_flat10_zec_001_cfcs_ideal_r192x96_intpp_18500101_21491231.nc","r")
flt_zec_npp=g->intpp(:,0,:,:)
h=addfile(dir0+"test_flat10_cdr_001_cfcs_ideal_r192x96_intpp_18500101_21491231.nc","r")
flt_cdr_npp=h->intpp(:,0,:,:)

flt_npp_an=month_to_annual(flt_npp,1)
flt_zec_npp_an=month_to_annual(flt_zec_npp,1) ;year x depth x lat
flt_cdr_npp_an=month_to_annual(flt_cdr_npp,1)
dim=dimsizes(flt_npp_an)

First_npp=new((/dim(1),dim(2)/),typeof(flt_npp_an))
First_npp=dim_avg_n_Wrap(flt_npp_an(0:29,:,:),0)
Last_npp=new((/dim(1),dim(2)/),typeof(flt_npp_an))
Last_npp=dim_avg_n_Wrap(flt_npp_an(270:299,:,:),0)
Last_First_npp=Last_npp-First_npp
copy_VarCoords(Last_npp,Last_First_npp)

flat10=new((/3,dim(1),dim(2)/),typeof(First_npp))
flat10(0,:,:)=First_npp
flat10(1,:,:)=Last_npp
flat10(2,:,:)=Last_First_npp
flat10!0="period"

First_zec_npp=new((/dim(1),dim(2)/),typeof(flt_npp_an))
First_zec_npp=dim_avg_n_Wrap(flt_zec_npp_an(0:29,:,:),0)
Last_zec_npp=new((/dim(1),dim(2)/),typeof(flt_npp_an))
Last_zec_npp=dim_avg_n_Wrap(flt_zec_npp_an(270:299,:,:),0)
Last_First_zec_npp=Last_zec_npp-First_zec_npp
copy_VarCoords(Last_zec_npp,Last_First_zec_npp)

flat10_zec=new((/3,dim(1),dim(2)/),typeof(First_npp))
flat10_zec(0,:,:)=First_zec_npp
flat10_zec(1,:,:)=Last_zec_npp
flat10_zec(2,:,:)=Last_First_zec_npp
flat10_zec!0="period"

First_cdr_npp=new((/dim(1),dim(2)/),typeof(flt_npp_an))
First_cdr_npp=dim_avg_n_Wrap(flt_cdr_npp_an(0:29,:,:),0)
Last_cdr_npp=new((/dim(1),dim(2)/),typeof(flt_npp_an))
Last_cdr_npp=dim_avg_n_Wrap(flt_cdr_npp_an(270:299,:,:),0)
Last_First_cdr_npp=Last_cdr_npp-First_cdr_npp
copy_VarCoords(Last_cdr_npp,Last_First_cdr_npp)

flat10_cdr=new((/3,dim(1),dim(2)/),typeof(First_npp))
flat10_cdr(0,:,:)=First_cdr_npp
flat10_cdr(1,:,:)=Last_cdr_npp
flat10_cdr(2,:,:)=Last_First_cdr_npp
flat10_cdr!0="period"

;--- Unit convertion---
flat10=flat10*12.01*31536000
flat10_zec=flat10_zec*12.01*31536000
flat10_cdr=flat10_cdr*12.01*31536000
flat10@units="g C m^-2 yr^-1"
flat10_zec@units="g C m^-2 yr^-1"
flat10_cdr@units="g C m^-2 yr^-1"

plot=new(6,graphic)
plot1=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"NPP_global_3scenarios_diff" )          ; send graphics to PNG file
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
res@cnFillPalette        = "GMT_ocean"
res@cnLevelSelectionMode   =       "ManualLevels"
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =180
res@gsnCenterStringFontHeightF= 0.028
res@gsnCenterString="(a) flat10"
res@gsnLeftString=""
res@gsnRightString=""
res@gsnCenterStringOrthogonalPosF=0.05
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"
res@lbLabelBarOn           =      False
res1=res
res@cnMaxLevelValF         =     500
res@cnMinLevelValF         =     0
res@cnLevelSpacingF        =      50
res1@cnMaxLevelValF         =     120
res1@cnMinLevelValF         =     -120
res1@cnLevelSpacingF        =      20
res1@cnFillPalette        = "MPL_BrBG"
plot(0)=gsn_csm_contour_map(wks,flat10(0,:,:),res)
res@gsnCenterString=""
plot(3)=gsn_csm_contour_map(wks,flat10(1,:,:),res)
plot1(0)=gsn_csm_contour_map(wks,flat10(2,:,:),res1)
res@gsnCenterString="(b) flat10-zec"
plot(1)=gsn_csm_contour_map(wks,flat10_zec(0,:,:),res)
res@gsnCenterString=""
plot(4)=gsn_csm_contour_map(wks,flat10_zec(1,:,:),res)
plot1(1)=gsn_csm_contour_map(wks,flat10_zec(2,:,:),res1)
res@gsnCenterString="(c) flat10-cdr"
plot(2)=gsn_csm_contour_map(wks,flat10_cdr(0,:,:),res)
res@gsnCenterString=""
plot(5)=gsn_csm_contour_map(wks,flat10_cdr(1,:,:),res)
plot1(2)=gsn_csm_contour_map(wks,flat10_cdr(2,:,:),res1)
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
pres@gsnPanelMainString="NPP"
pres@gsnPanelMainFontHeightF=0.02
pres@gsnPanelTop=0.9
pres@gsnPanelBottom=0.25
pres2@gsnPanelTop=0.3
pres2@gsnPanelBottom=0.1

txres1               = True
txres1@txFontHeightF = 0.015
gsn_text_ndc(wks,"First",0.05,0.66,txres1)
gsn_text_ndc(wks,"Last",0.05,0.47,txres1)
gsn_text_ndc(wks,"Diff",0.05,0.20,txres1)
gsn_text_ndc(wks,"(Last-First)",0.05,0.18,txres1)
txres1@txFontHeightF = 0.014

gsn_text_ndc(wks,"[gC m-2 yr-1]",0.94,0.33,txres1)

gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot1,(/1,3/),pres2)
frame(wks)

end
