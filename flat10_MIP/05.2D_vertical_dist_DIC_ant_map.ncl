begin

dir0="/work/uo1451/m301158/MPI-ESM/data/esm-flat10/raw/regrid/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
dir2="/work/uo1451/m301158/MPI-ESM/data/esm-piControl/raw/"

;----------------------flat10MIP-----------------------------------------------
f=addfile(dir0+"dissic_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012_lon_340.nc","r")
DIC_fl10_Atl=f->dissic(:,:,:,0)
dim=dimsizes(DIC_fl10_Atl)

g=addfile(dir0+"dissic_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012_lon_190.nc","r")
DIC_fl10_Pac=g->dissic(:,:,:,0)

h=addfile(dir0+"dissic_Omon_MPI-ESM1-2-LR_esm-flat10_r1i1p1f1_gn_185001-215012_lon_70.nc","r")
DIC_fl10_Ind=h->dissic(:,:,:,0)
;---------------------piControl--------------------------------------------
f1=addfile(dir2+"dissic_Omon_MPI-ESM1-2-LR_esm-piControl_r1i1p1f1_gn_205001-234912_lon_340.nc","r")
DIC_piC_Atl=f1->dissic(:,:,:,0)
DIC_piC_Atl_mon=clmMonTLL(DIC_piC_Atl)

g1=addfile(dir2+"dissic_Omon_MPI-ESM1-2-LR_esm-piControl_r1i1p1f1_gn_205001-234912_lon_190.nc","r")
DIC_piC_Pac=g1->dissic(:,:,:,0)
DIC_piC_Pac_mon=clmMonTLL(DIC_piC_Pac)

h1=addfile(dir2+"dissic_Omon_MPI-ESM1-2-LR_esm-piControl_r1i1p1f1_gn_205001-234912_lon_70.nc","r")
DIC_piC_Ind=h1->dissic(:,:,:,0);time,lev,lat
DIC_piC_Ind_mon=clmMonTLL(DIC_piC_Ind)
;--------------------------------------------------------------------------------
dic_piC_Atl_re=new((/dim(0),dim(1),dim(2)/),typeof(DIC_piC_Atl))
dic_piC_Pac_re=new((/dim(0),dim(1),dim(2)/),typeof(DIC_piC_Atl))
dic_piC_Ind_re=new((/dim(0),dim(1),dim(2)/),typeof(DIC_piC_Atl))

do i=0,(dim(0)/12)-1
 dic_piC_Atl_re(12*i:12*i+11,:,:)=DIC_piC_Atl_mon
 dic_piC_Pac_re(12*i:12*i+11,:,:)=DIC_piC_Pac_mon
 dic_piC_Ind_re(12*i:12*i+11,:,:)=DIC_piC_Ind_mon
end do

DIC_ant_Atl=DIC_fl10_Atl-dic_piC_Atl_re
copy_VarMeta(DIC_fl10_Atl,DIC_ant_Atl)
DIC_ant_Pac=DIC_fl10_Pac-dic_piC_Pac_re
copy_VarMeta(DIC_fl10_Pac,DIC_ant_Pac)
DIC_ant_Ind=DIC_fl10_Ind-dic_piC_Ind_re
copy_VarMeta(DIC_fl10_Ind,DIC_ant_Ind)

DIC_ant_Atl_avg=dim_avg_n_Wrap(DIC_ant_Atl,0)
DIC_ant_Pac_avg=dim_avg_n_Wrap(DIC_ant_Pac,0)
DIC_ant_Ind_avg=dim_avg_n_Wrap(DIC_ant_Ind,0)

;printMinMax(DIC_ant_Atl_avg,0)
;printMinMax(DIC_ant_Pac_avg,0)
;printMinMax(DIC_ant_Ind_avg,0)
plot=new(3,graphic)
wks   = gsn_open_wks ("png", dir1+"2D_vertical_DIC_clim" )          ; send graphics to PNG file

res                      = True                 ; plot mods desired
res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
res@cnLevelSpacingF      = 0.02                  ; contour spacing
res@cnLineLabelsOn         =       False
res@cnMinLevelValF       = -0.08                 ; min level
res@cnMaxLevelValF       =  0.18                 ; max level
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "cmocean_deep"
res@trYReverse =True
res@vpWidthF       = 0.6            ; Change the aspect ratio, but 
res@vpHeightF      = 0.5
res@cnMissingValFillColor="black"
res@lbLabelBarOn           = False
res@gsnFrame               =       False
res@gsnDraw                =       False
;res@tmYLLabels =(..)
res@cnInfoLabelOn          =   False
res@cnLineLabelsOn         =       False
res@tmYRMode             = "Automatic"          ; turn off special labels on right axis
res@gsnCenterStringFontHeightF= 0.025
res@gsnCenterStringOrthogonalPosF=0.05
res@gsnCenterString="(a) Atlantic Ocean"
res@gsnLeftString=""
res@gsnRightString=""

; note u is already on pressure levels. If this were model data, it
; would be necessary to interpolate from the hybrid coordinates to 
; pressure levels.
res@tiYAxisString="Depth (m)"
plot(0)  = gsn_csm_contour(wks, DIC_ant_Atl_avg, res )   ; plaace holder
res@tiYAxisString=""
res@gsnCenterString="(b) Pacific Ocean"
plot(1)  = gsn_csm_contour(wks, DIC_ant_Pac_avg, res )   ; plaace holder
res@gsnCenterString="(c) Indian Ocean"
plot(2)  = gsn_csm_contour(wks, DIC_ant_Ind_avg, res )   ; plaace holder

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = True
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 7
 pres@lbLabelFontHeightF  = 0.013
 pres@lbLabelStride     =   3
 pres@pmLabelBarHeightF=0.06

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"[mol/m~S~3~N~]",0.90,0.37,txres1)
 txres1@txFontHeightF = 0.02
 gsn_panel(wks,plot,(/1,3/),pres)
 frame(wks)

end
