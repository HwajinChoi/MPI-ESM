#!/bin/bash

for C in "11" "12" ;do

 if [ $C = "11" ];then
  A="res@trYMaxF       =  1550."
  B=5.62
 else
  A="res@trYMaxF	= 3000."
  B=4.95
 fi

cat << EOF > ./imsi.ncl
begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_CFC/"
dir2="/work/bm1030/m300595/hwajin/"
dir3="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir1+"CFC_Atm_Hist_1850-2000.nc","r") ; initial data for CFC experiment
g=addfile(dir2+"CFC_Atm_Hist_1850-2000_linear.nc","r") ; for idealized CFC experiment

cfc${C}_nh_reali=f->cfc${C}_nh(:,0,0) ; time(151)
cfc${C}_sh_reali=f->cfc${C}_sh(:,0,0)

cfc${C}_nh_ideal=g->cfc${C}_nh(:,0,0) ; time(151)
cfc${C}_sh_ideal=g->cfc${C}_sh(:,0,0)
dim=dimsizes(cfc${C}_nh_reali)

CFC_NH=new((/2,dim(0)/),typeof(cfc${C}_nh_reali))
CFC_NH(0,:)=cfc${C}_nh_reali
CFC_NH(1,:)=cfc${C}_nh_ideal
CFC_NH!0="exp"

CFC_SH=new((/2,dim(0)/),typeof(cfc${C}_sh_reali))
CFC_SH(0,:)=cfc${C}_sh_reali
CFC_SH(1,:)=cfc${C}_sh_ideal
CFC_SH!0="exp"
year=ispan(1850,2000,1)
;printMinMax(cfc${C}_nh_reali,0)

CFC_SH=CFC_SH*${B}
CFC_NH=CFC_NH*${B}

wks=gsn_open_wks("png",dir3+"prescribed_CFC${C}_1850_2000_timeseries")
 plot=new(2,graphic)
 res                =   True
 res@gsnMaximize    =   True
 res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.6            ; Change the aspect ratio, but 
 res@vpHeightF      = 0.4            ; make plot as large as possible.
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 ;res@trYMinF       =  -1.5 
 ;res@trYMaxF       =   1.5
 ;res@tmYLMode = "Mannual"
 res@tmYRMinorPerMajor=4
 res@tmYLTickSpacingF=1
 res@tmYLTickStartF=-2.0
 res@xyLineColors   = (/"red","blue"/)
 res@xyLineThicknessF= 5
 res@tiXAxisString       =       "Year"
 res@tiXAxisFontHeightF =0.02
 res@tiYAxisFontHeightF =0.02
 res@tiMainFontHeightF =0.02
 res@tiMainString       =   ""
 res@xyDashPatterns    =   (/0,0/)
 res@trXMinF             =       1850
 res@trXMaxF             =       2000
 res@gsnCenterStringFontHeightF=0.022
 res@gsnCenterString="NH"
 res@trYMinF       =  0.
 ${A}
 res@tiYAxisString       =       "ppt"
 res@gsnCenterStringOrthogonalPosF=0.06
 plot(0)=gsn_csm_xy(wks,year,CFC_NH,res)
 res@gsnCenterString="SH"
 plot(1)=gsn_csm_xy(wks,year,CFC_SH,res)

 gres = True
 gres@YPosPercent = 94.
 gres@XPosPercent = 4
 gres@ItemSpacePercent          = 6
 lineres = True
 lineres@lgLineColors =(/"red","blue"/)
 lineres@lgLineThicknesses = 4
 lineres@LineLengthPercent = 4.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"realistic","idealized"/)
 textres@lgLabelFontHeights   =(/0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4
 ;textres@lgLabelOffsetF=0.1
 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)
 gres@YPosPercent = 94.
 gres@XPosPercent = 63

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnPanelMainString="Atm. CFC${C} Concentration"
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 5
 pres@gsnPanelXWhiteSpacePercent = 5
 ;pres@gsnPanelLeft  =0.1
 gsn_panel(wks,plot,(/2,2/),pres)
frame(wks)
end

EOF
 ncl ./imsi.ncl
 rm -f ./imsi.ncl
done



