#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data/advection
dir2=/data/hjchoi/CMI/OBA/image

for v in "u" ;do
# for d in "0-100" "100-300" "300-800";do
 for d in "100-300" ;do

 if [ $v = "u" ];then
 a="x"
 A="ECDA-COBALT_dO_d${a}_${d}_advection_199001-201712.nc"
 elif [ $v = "v" ];then
 a="y"
 A="ECDA-COBALT_dO_d${a}_${d}_advection_199001-201712.nc"
 else
 a="z"
 fi

   cat <<EOF > ./map_clm_${v}.ncl

   begin

   f=addfile("${dir1}/${A}","r")
   ${v}_bar_O_prime=f->${v}_bar_O_prime
   ${v}_bar_O_prime=${v}_bar_O_prime*60*60*24*30
   ${v}_bar_O_prime2=dim_avg_n_Wrap(${v}_bar_O_prime,0)

   ${v}_prime_O_bar=f->${v}_prime_O_bar
   ${v}_prime_O_bar=${v}_prime_O_bar*60*60*24*30
   ${v}_prime_O_bar2=dim_avg_n_Wrap(${v}_prime_O_bar,0)

plot=new(2,graphic)
 wks=gsn_open_wks("x11","${dir2}/dO_d${a}_${d}_advection_annual_clm_1990-2017")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@cnLineLabelsOn         =       False
 res@lbLabelBarOn           =      False
 res@gsnCenterStringFontHeightF= 0.035
 res@gsnCenterStringOrthogonalPosF=0.1
 res@pmLabelBarOrthogonalPosF = 0.27
 res@lbLabelBarOn           = True
 res@tmXBLabelFontHeightF   =       0.02
 res@tmYLLabelFontHeightF   =       0.02
 res@mpMinLatF=-30
 res@mpMaxLatF=30
 res@mpMinLonF=120
 res@mpMaxLonF=300
 res@tmXBLabelStride     =       2   
 res@tmYLLabelStride     =       2   
 res@mpCenterLonF       =       180 
 res@mpLandFillColor    =   "white"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res@cnMaxLevelValF         =      0.000005 
 res@cnMinLevelValF         =      -0.000005
 res@cnLevelSpacingF        =       0.000001
 res@cnFillPalette          =       "temp_19lev"
 ;res@cnFillPalette          =       "matlab_jet"
 res@gsnRightString        =   ""  
 res@gsnLeftString        =   ""  
 res@gsnCenterString        =   ""
 plot(0)=gsn_csm_contour_map(wks,${v}_bar_O_prime2,res)
 res@gsnCenterString        =   ""  
 res@cnMaxLevelValF         =      0.00000005 
 res@cnMinLevelValF         =      -0.00000005
 res@cnLevelSpacingF        =       0.00000001
 plot(1)=gsn_csm_contour_map(wks,${v}_prime_O_bar2,res)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 10
 pres@lbLabelFontHeightF  = 0.010
 pres@lbLabelStride     =   2
 pres@gsnPanelTop       = 0.9
 pres@gsnPanelBottom       = 0.05
 pres@gsnPanelLeft     = 0.03
 ;pres@gsnPanelMainString     = "dO/dx (climatology;1990-2017)"
 gsn_panel(wks,plot,(/2,1/),pres)

 txres               = True                      ; text mods desired
 txres@txJust        = "CenterLeft"
 txres@txFuncCode    = ":"
 txres@txFontHeightF = 0.02
 ;eqn = ":F21:-:F21:u:H6::V10::F18:s:F21:O:B:2:N::H-40::V-1::F21:__:H-35::V-30::F18:s:F10:x";
 eqn = ":F21:-:F21:${v}:H6::V10::F18:s:F21:O:B:2:N::H-40::V-1::F21:__:H-35::V-30::F18:s:F10:${a}";
  gsn_text_ndc(wks,eqn,.48,.48,txres)
  gsn_text_ndc(wks,eqn,.48,.90,txres)
  gsn_text_ndc(wks,":F18:-",.488,.912,txres)
  gsn_text_ndc(wks,":F18:-",.53,.508,txres)
  gsn_text_ndc(wks,":F18:'",.546,.928,txres)
  gsn_text_ndc(wks,":F18:'",.505,.49,txres)
    frame(wks)
   end

EOF
 ncl ./map_clm_${v}.ncl
 rm -f ./map_clm_${v}.ncl

 done
done
