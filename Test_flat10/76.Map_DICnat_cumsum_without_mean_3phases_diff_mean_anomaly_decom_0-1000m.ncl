begin
dir1="/work/uo1451/m301158/MPI-ESM/data/Test_advection/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"DIC_horizontal_advection_r192x96_mul_dz_0-1000m_1850-2299.nc","r")

HmeanCprime=dble2flt(f->advH_meanCprime)
HprimeCmean=dble2flt(f->advH_primeCmean)
HprimeCprime=dble2flt(f->advH_primeCprime)

g=addfile(dir1+"DIC_vertical_advection_r192x96_mul_dz_0-1000m_1850-2299.nc","r")
VmeanCprime=g->advV_meanCprime
VprimeCmean=g->advV_primeCmean
VprimeCprime=g->advV_primeCprime
HmeanCprime  = where(abs(HmeanCprime).gt.1.e+20, \
                    HmeanCprime@_FillValue, HmeanCprime)

HprimeCmean  = where(abs(HprimeCmean).gt.1.e+20, \
                    HprimeCmean@_FillValue, HprimeCmean)

HprimeCprime = where(abs(HprimeCprime).gt.1.e+20, \
                    HprimeCprime@_FillValue, HprimeCprime)


HmeanCprime  = where(ismissing(HmeanCprime),  -9.e33, HmeanCprime)
HprimeCmean  = where(ismissing(HprimeCmean),  -9.e33, HprimeCmean)
HprimeCprime = where(ismissing(HprimeCprime), -9.e33, HprimeCprime)

HmeanCprime@_FillValue  = -9.e33
HprimeCmean@_FillValue  = -9.e33
HprimeCprime@_FillValue = -9.e33

dim=dimsizes(HmeanCprime)
Bud=new((/6,dim(0),dim(1),dim(2)/),"float",-9.e33)
Bud_ano=new((/6,dim(0),dim(1),dim(2)/),"float",-9.e33)
Bud(0,:,:,:)=(/HmeanCprime/)
Bud(1,:,:,:)=(/HprimeCmean/)
Bud(2,:,:,:)=(/HprimeCprime/)
Bud(3,:,:,:)=(/VmeanCprime/)
Bud(4,:,:,:)=(/VprimeCmean/)
Bud(5,:,:,:)=(/VprimeCprime/)

; Set dimension names
Bud!0 = "component"
Bud!1 = "time"
Bud!2 = "lat"
Bud!3 = "lon"

; Copy coordinates
Bud&time = HmeanCprime&time
Bud&lat  = HmeanCprime&lat
Bud&lon  = HmeanCprime&lon

; Component coordinates
Bud&component = ispan(0,5,1)

; Set attributes
Bud@long_name = "Advection mean-anomaly decomposition"
Bud@units = HmeanCprime@units
Bud@cell_methods = HmeanCprime@cell_methods

Bud=Bud*365.25*86400
Bud_clim=dim_avg_n_Wrap(Bud,1)

do i=0,450-1
 Bud_ano(:,i,:,:)=Bud(:,i,:,:)-Bud_clim
end do
copy_VarCoords(Bud,Bud_ano)

Bud_ano_cumsum=dim_cumsum_n_Wrap(Bud_ano,1,1)

First=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Middle=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Last=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Last1=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))
Last2=new((/6,dim(1),dim(2)/),typeof(HmeanCprime))

First=dim_avg_n_Wrap(Bud_ano_cumsum(:,0:29,:,:),1)
Middle=dim_avg_n_Wrap(Bud_ano_cumsum(:,135:164,:,:),1)
Last=dim_avg_n_Wrap(Bud_ano_cumsum(:,270:299,:,:),1)
Last1=dim_avg_n_Wrap(Bud_ano_cumsum(:,285:314,:,:),1)
Last2=dim_avg_n_Wrap(Bud_ano_cumsum(:,420:449,:,:),1)

Last_Middle=Last-Middle
Middle_First=Middle-First
Last2_Last1=Last2-Last1
copy_VarCoords(Last,Last_Middle)
copy_VarCoords(Last,Middle_First)
copy_VarCoords(Last,Last2_Last1)
;----------------------------------------------------------------------------------------------------------
plot=new(6,graphic)
plot3=new(6,graphic)
plot2=new(6,graphic)

wks   = gsn_open_wks ("png", dir2+"Map_CDR_DICnat_cumsum_without_mean_3phases_anomaly_decom_0-1000m" )
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
res@mpProjection ="Robinson"
res@mpPerimOn = False
res@mpCenterLonF =-50
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.1
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"
res@cnFillMode="RasterFill"
res@cnRasterSmoothingOn = False
res@gsnLeftString=""
res@gsnRightString=""
res@cnLevelSelectionMode   =       "ManualLevels"
;res@cnMinLevelValF = -600
;res@cnMaxLevelValF = 600 
;res@cnLevelSpacingF =100 
res@cnMinLevelValF = -12000
res@cnMaxLevelValF =  12000
res@cnLevelSpacingF = 2000
res@lbLabelBarOn           = True
res@gsnCenterString="-div_h(ubar DIC')"
plot(0)  = gsn_csm_contour_map(wks, Middle_First(0,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -12000
;res@cnMaxLevelValF =  12000
;res@cnLevelSpacingF = 2000
res@gsnCenterString="-div_h(u' DICbar)"
plot(1)  = gsn_csm_contour_map(wks, Middle_First(1,:,:),res )   ; plaace holder
res@gsnCenterString="-div_h(u' DIC')"
;res@cnMinLevelValF = -600
;res@cnMaxLevelValF = 600 
;res@cnLevelSpacingF =100
plot(2)  = gsn_csm_contour_map(wks,Middle_First(2,:,:), res )   ; plaace holder
res@gsnCenterString="wbar DIC'"
;res@cnMinLevelValF = -60
;res@cnMaxLevelValF = 60 
;res@cnLevelSpacingF =10
;res@cnMinLevelValF = -12000
;res@cnMaxLevelValF =  12000
;res@cnLevelSpacingF = 2000
plot(3)  = gsn_csm_contour_map(wks, Middle_First(3,:,:), res )   ; plaace holder
res@gsnCenterString="w' DICbar"
;res@cnMinLevelValF = -12000
;res@cnMaxLevelValF =  12000
;res@cnLevelSpacingF = 2000
;res@cnMinLevelValF = -1200
;res@cnMaxLevelValF = 1200
;res@cnLevelSpacingF =200
plot(4)  = gsn_csm_contour_map(wks, Middle_First(4,:,:), res )   ; plaace holder
res@gsnCenterString="w' DIC'"
;res@cnMinLevelValF = -60
;res@cnMaxLevelValF = 60 
;res@cnLevelSpacingF =10
plot(5)  = gsn_csm_contour_map(wks, Middle_First(5,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -600
;res@cnMaxLevelValF =  600
;res@cnLevelSpacingF = 100
res@gsnCenterString="-div_h(ubar DIC')"
plot2(0)  = gsn_csm_contour_map(wks, Last_Middle(0,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -12000
;res@cnMaxLevelValF =  12000
;res@cnLevelSpacingF = 2000
res@gsnCenterString="-div_h(u' DICbar)"
plot2(1)  = gsn_csm_contour_map(wks, Last_Middle(1,:,:),res )   ; plaace holder
;res@cnMinLevelValF = -600
;res@cnMaxLevelValF =  600
;res@cnLevelSpacingF = 100
res@gsnCenterString="-div_h(u' DIC')"
plot2(2)  = gsn_csm_contour_map(wks,Last_Middle(2,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -60
;res@cnMaxLevelValF =  60
;res@cnLevelSpacingF = 10
res@gsnCenterString="wbar DIC'"
plot2(3)  = gsn_csm_contour_map(wks, Last_Middle(3,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -1200
;res@cnMaxLevelValF =  1200
;res@cnLevelSpacingF = 200
res@gsnCenterString="w' DICbar"
plot2(4)  = gsn_csm_contour_map(wks, Last_Middle(4,:,:), res )   ; plaace holder
res@gsnCenterString="w' DIC'"
;res@cnMinLevelValF = -60
;res@cnMaxLevelValF =  60
;res@cnLevelSpacingF = 10
plot2(5)  = gsn_csm_contour_map(wks, Last_Middle(5,:,:), res )   ; plaace holder

;res@cnMinLevelValF = -600
;res@cnMaxLevelValF = 600 
;res@cnLevelSpacingF =100 
res@gsnCenterString="-div_h(ubar DIC')"
plot3(0)  = gsn_csm_contour_map(wks, Last2_Last1(0,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -12000
;res@cnMaxLevelValF = 12000 
;res@cnLevelSpacingF =2000 
res@gsnCenterString="-div_h(u' DICbar)"
plot3(1)  = gsn_csm_contour_map(wks, Last2_Last1(1,:,:),res )   ; plaace holder
res@gsnCenterString="-div_h(u' DIC')"
;res@cnMinLevelValF = -600
;res@cnMaxLevelValF = 600 
;res@cnLevelSpacingF =100 
plot3(2)  = gsn_csm_contour_map(wks,Last2_Last1(2,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -60
;res@cnMaxLevelValF = 60 
;res@cnLevelSpacingF =10 
res@gsnCenterString="wbar DIC'"
plot3(3)  = gsn_csm_contour_map(wks, Last2_Last1(3,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -1200
;res@cnMaxLevelValF = 1200 
;res@cnLevelSpacingF =200
res@gsnCenterString="w' DICbar"
plot3(4)  = gsn_csm_contour_map(wks, Last2_Last1(4,:,:), res )   ; plaace holder
;res@cnMinLevelValF = -60
;res@cnMaxLevelValF = 60 
;res@cnLevelSpacingF =10
res@gsnCenterString="w' DIC'"
plot3(5)  = gsn_csm_contour_map(wks, Last2_Last1(5,:,:), res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 3
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.9
pres@gsnPanelLabelBar      = False
pres2=pres
pres3=pres
pres@gsnPanelTop=1.
pres@gsnPanelBottom=0.70
pres2@gsnPanelTop=0.69
pres2@gsnPanelBottom=0.39

pres3@gsnPanelTop=0.38
pres3@gsnPanelBottom=0.04
pres3@gsnPanelLeft=0.11
pres3@gsnPanelRight=0.89
pres3@gsnPanelLabelBar      = False
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.017
gsn_text_ndc(wks,"Positive emissions",0.06,0.84,txres1)
gsn_text_ndc(wks,"Negative emissions",0.06,0.53,txres1)
gsn_text_ndc(wks,"Zero emissions",0.06,0.22,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.84,0.05,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)
frame(wks)

end
