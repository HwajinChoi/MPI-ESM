begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_CFC/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"test_pictrl_ver2_002_r192x96_cfcs_20000101_20001231.nc","r")
cfc11_real=f->cfc11 ; time* time* lat* lon
cfc12_real=f->cfc12 ; kmol m-3
dep=f->depth
depth=dble2flt(dep)

g=addfile(dir1+"test_pictrl_ver2_002_r192x96_cfcs_ideal_20000101_20001231.nc","r")
cfc11_ideal=g->cfc11 ; time* time* lat* lon
cfc12_ideal=g->cfc12
printMinMax(cfc11_real,0)
printMinMax(cfc11_ideal,0)
printMinMax(cfc12_real,0)
printMinMax(cfc12_ideal,0)
dim0=dimsizes(cfc11_real)
dim=dimsizes(depth)
;-------- calculate weighted vertical depth 

th=new((/dim0(0),dim0(1),dim0(2),dim0(3)/),typeof(cfc11_real))
th(:,0,:,:)=((depth(1)-depth(0))/2)

do i=1,dim(0)-2
 th(:,i,:,:)=((depth(i)-depth(i-1))/2)+((depth(i+1)-depth(i))/2)
end do

th(:,dim(0)-1,:,:)=((depth(dim(0)-1)-depth(dim(0)-2))/2)
;------------------------------------------------------------------------------
cfc11_real_m=cfc11_real*th
copy_VarCoords(cfc11_real,cfc11_real_m)
cfc12_real_m=cfc12_real*th
copy_VarCoords(cfc12_real,cfc12_real_m)
cfc11_real_w_sum=dim_sum_n_Wrap(cfc11_real_m,1)
cfc12_real_w_sum=dim_sum_n_Wrap(cfc12_real_m,1)

cfc11_ideal_m=cfc11_ideal*th
copy_VarCoords(cfc11_ideal,cfc11_ideal_m)
cfc12_ideal_m=cfc12_ideal*th
copy_VarCoords(cfc12_ideal,cfc12_ideal_m)
cfc11_ideal_w_sum=dim_sum_n_Wrap(cfc11_ideal_m,1)
cfc12_ideal_w_sum=dim_sum_n_Wrap(cfc12_ideal_m,1)
;------------------------------------------------------------------------------
cfc11_real_w_sum=cfc11_real_w_sum*1000
cfc12_real_w_sum=cfc12_real_w_sum*1000
cfc11_ideal_w_sum=cfc11_ideal_w_sum*1000
cfc12_ideal_w_sum=cfc12_ideal_w_sum*1000
printMinMax(cfc11_ideal_w_sum,0)
;------------------------------------------------------------------------------
cfc11_real_w_sum_avg=dim_avg_n_Wrap(cfc11_real_w_sum,0)
cfc12_real_w_sum_avg=dim_avg_n_Wrap(cfc12_real_w_sum,0)
cfc11_ideal_w_sum_avg=dim_avg_n_Wrap(cfc11_ideal_w_sum,0)
cfc12_ideal_w_sum_avg=dim_avg_n_Wrap(cfc12_ideal_w_sum,0)

;------------------------------------------------------------------------------

plot=new(4,graphic)
 wks=gsn_open_wks("png",dir2+"CFCs_vertical_integration_in_2000")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 ;res@cnFillMode                =   "AreaFill"
 res@lbLabelBarOn           =      False
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@gsnCenterStringFontHeightF= 0.020
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@lbLabelBarOn           = True
 res@tmXBLabelFontHeightF  =       0.025
 res@tmYLLabelFontHeightF  =       0.025
 res@tmXBLabelStride     =       2
 res@tmYLLabelStride     =       2
 res@mpLandFillColor    =   "black"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnFillPalette          =       "BlAqGrYeOrRe"
 res@gsnCenterString="(a) realistic"
 res@cnMinLevelValF         =     1e-06
 res@cnMaxLevelValF         =     1.4e-05
 res@lbLabelFontHeightF  = 0.016
; res@cnLevelSpacingF        =       0.0003
 plot(0)=gsn_csm_contour_map(wks,cfc11_real_w_sum_avg,res)
 res@gsnCenterString="(b) idealized"
 plot(1)=gsn_csm_contour_map(wks,cfc11_ideal_w_sum_avg,res)
 res@cnMinLevelValF         =      5e-07
 res@cnMaxLevelValF         =     7.5e-06
; res@cnLevelSpacingF        =       0.0003
 res@gsnCenterString=""
 plot(2)=gsn_csm_contour_map(wks,cfc12_real_w_sum_avg,res)
 plot(3)=gsn_csm_contour_map(wks,cfc12_ideal_w_sum_avg,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 2
 pres@lbLabelStride     =   3
 pres@gsnPanelLeft=0.1
 pres@gsnPanelMainString="Cumulative CFCs in 2000"
 pres@gsnPanelMainFontHeightF=0.02
 ;pres@gsnPanelTop=1.
 ;spres@gsnPanelTop=0.4

 txres1               = True
 txres1@txFontHeightF = 0.014
 gsn_text_ndc(wks,"[mol/m~S~2~N~]",0.8,0.84,txres1)
 txres1@txFontHeightF = 0.016
 gsn_text_ndc(wks,"CFC11",0.05,0.68,txres1)
 gsn_text_ndc(wks,"CFC12",0.05,0.32,txres1)

 gsn_panel(wks,plot,(/2,2/),pres)
 frame(wks)

end
