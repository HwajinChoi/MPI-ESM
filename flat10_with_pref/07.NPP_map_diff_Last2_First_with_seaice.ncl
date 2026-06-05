begin
dir0="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"
f1=addfile(dir0+"intpp_flat10_1850-1879.nc","r")
f2=addfile(dir0+"intpp_flat10_zec_1850-1879.nc","r")
f3=addfile(dir0+"intpp_flat10_cdr_1850-1879.nc","r")
npp_flat10_p1=f1->intpp(:,0,:,:)
lat=f1->lat
lon=f1->lon
npp_flat10_zec_p1=f2->intpp(:,0,:,:)
npp_flat10_cdr_p1=f3->intpp(:,0,:,:)
npp_flat10_p1@lat2d=lat
npp_flat10_p1@lon2d=lon
npp_flat10_zec_p1@lat2d=lat
npp_flat10_zec_p1@lon2d=lon
npp_flat10_cdr_p1@lat2d=lat
npp_flat10_cdr_p1@lon2d=lon

dim=dimsizes(npp_flat10_p1)
First=new((/3,dim(0),dim(1),dim(2)/),typeof(npp_flat10_p1))
First(0,:,:,:)=npp_flat10_p1
First(1,:,:,:)=npp_flat10_zec_p1
First(2,:,:,:)=npp_flat10_cdr_p1

g1=addfile(dir0+"intpp_flat10_2270-2299.nc","r")
g2=addfile(dir0+"intpp_flat10_zec_2270-2299.nc","r")
g3=addfile(dir0+"intpp_flat10_cdr_2270-2299.nc","r")
npp_flat10_p2=g1->intpp(:,0,:,:)
npp_flat10_zec_p2=g2->intpp(:,0,:,:)
npp_flat10_cdr_p2=g3->intpp(:,0,:,:)
npp_flat10_p2@lat2d=lat
npp_flat10_p2@lon2d=lon
npp_flat10_zec_p2@lat2d=lat
npp_flat10_zec_p2@lon2d=lon
npp_flat10_cdr_p2@lat2d=lat
npp_flat10_cdr_p2@lon2d=lon

k1=addfile(dir0+"siconc_flat10_r192x96_1850-1879.nc","r")
k2=addfile(dir0+"siconc_flat10_zec_r192x96_1850-1879.nc","r")
k3=addfile(dir0+"siconc_flat10_cdr_r192x96_1850-1879.nc","r")
sic_flat10_p1=k1->siconc(:,0,:,:)
sic_flat10_zec_p1=k2->siconc(:,0,:,:)
sic_flat10_cdr_p1=k3->siconc(:,0,:,:)
;sic_flat10_p1@lat2d=lat
;sic_flat10_p1@lon2d=lon
;sic_flat10_zec_p1@lat2d=lat
;sic_flat10_zec_p1@lon2d=lon
;sic_flat10_cdr_p1@lat2d=lat
;sic_flat10_cdr_p1@lon2d=lon

dim0=dimsizes(sic_flat10_p1)
First_sic=new((/3,dim0(0),dim0(1),dim0(2)/),typeof(sic_flat10_p1))
First_sic(0,:,:,:)=sic_flat10_p1
First_sic(1,:,:,:)=sic_flat10_zec_p1
First_sic(2,:,:,:)=sic_flat10_cdr_p1

d1=addfile(dir0+"siconc_flat10_r192x96_2270-2299.nc","r")
d2=addfile(dir0+"siconc_flat10_zec_r192x96_2270-2299.nc","r")
d3=addfile(dir0+"siconc_flat10_cdr_r192x96_2270-2299.nc","r")
sic_flat10_p2=d1->siconc(:,0,:,:)
sic_flat10_zec_p2=d2->siconc(:,0,:,:)
sic_flat10_cdr_p2=d3->siconc(:,0,:,:)
;sic_flat10_p2@lat2d=lat
;sic_flat10_p2@lon2d=lon
;sic_flat10_zec_p2@lat2d=lat
;sic_flat10_zec_p2@lon2d=lon
;sic_flat10_cdr_p2@lat2d=lat
;sic_flat10_cdr_p2@lon2d=lon

Last_sic=new((/3,dim0(0),dim0(1),dim0(2)/),typeof(sic_flat10_p1))
Last_sic(0,:,:,:)=sic_flat10_p2
Last_sic(1,:,:,:)=sic_flat10_zec_p2
Last_sic(2,:,:,:)=sic_flat10_cdr_p2

Last=new((/3,dim(0),dim(1),dim(2)/),typeof(npp_flat10_p1))
Last(0,:,:,:)=npp_flat10_p2
Last(1,:,:,:)=npp_flat10_zec_p2
Last(2,:,:,:)=npp_flat10_cdr_p2

First_sic_av=dim_avg_n_Wrap(First_sic,1)
Last_sic_av=dim_avg_n_Wrap(Last_sic,1)
First_sic_av!0="scenario"
Last_sic_av!0="scenario"

First_av=dim_avg_n_Wrap(First,1)
Last_av=dim_avg_n_Wrap(Last,1)
First_av!0="scenario"
Last_av!0="scenario"
First_av=First_av*12.01*31536000
First_av@units="g C m^-2 yr^-1"
Last_av=Last_av*12.01*31536000
Last_av@units="g C m^-2 yr^-1"

Diff=Last_av-First_av
Diff@lat2d=lat
Diff@lon2d=lon
copy_VarCoords(First_av,Diff)
printMinMax(First_av,0)
printMinMax(Diff,0)

plot=new(9,graphic)
plot1=new(3,graphic)
plot2=new(3,graphic)
 wks=gsn_open_wks("png",dir1+"NPP_map_First_Last_30yrs_with_SIC_cont")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False
 res@cnFillOn               =       True
 res@cnInfoLabelOn          =   False
 res@cnLinesOn              =       False
 res@gsnCenterStringFontHeightF= 0.028
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterStringOrthogonalPosF=0.05
 res@cnLineLabelsOn         =       False
 res@gsnCenterString=""
 resw=res
 res@mpLandFillColor    =   "black"
 res@mpProjection ="Robinson"
 res@mpPerimOn = False
 res@mpCenterLonF =0
 res@lbLabelFontHeightF  = 0.024
 res@gsnCenterString="(a) First 30 years"
 res@cnLevelSelectionMode   =       "ManualLevels"
 res2=res
 res@cnMaxLevelValF         =     600
 res@cnMinLevelValF         =     50
 res@cnLevelSpacingF        =      50
 res@cnFillPalette          =       "precip3_16lev"
 res@lbLabelBarOn           =      False
 plot(0)=gsn_csm_contour_map(wks,First_av(0,:,:),res)
 res@gsnCenterString="(b) Last 30 years"
 plot(1)=gsn_csm_contour_map(wks,Last_av(0,:,:),res)
 res@gsnCenterString=""
 plot(3)=gsn_csm_contour_map(wks,First_av(1,:,:),res)
 plot(4)=gsn_csm_contour_map(wks,Last_av(1,:,:),res)
 res@lbLabelBarOn           =      True
 plot(6)=gsn_csm_contour_map(wks,First_av(2,:,:),res)
 plot(7)=gsn_csm_contour_map(wks,Last_av(2,:,:),res)
 res2@gsnCenterString="(c) Diff"
 res2@cnLevelSelectionMode   =       "ManualLevels"
 ;res2@cnMaxLevelValF         =    200 
 ;res2@cnMinLevelValF         =     -200
 ;res2@cnLevelSpacingF        =      25
 res2@cnMaxLevelValF         =    150 
 res2@cnMinLevelValF         =     -150
 res2@cnLevelSpacingF        =      30
 res2@cnFillPalette          =       "temp_diff_18lev"
 res2@lbLabelBarOn           =      False
 plot(2)=gsn_csm_contour_map(wks,Diff(0,:,:),res2)
 res2@gsnCenterString=""
 res2@cnMaxLevelValF         =    150 
 res2@cnMinLevelValF         =     -150
 res2@cnLevelSpacingF        =      30
 plot(5)=gsn_csm_contour_map(wks,Diff(1,:,:),res2)
 ;res2@cnMaxLevelValF         =    40 
 ;res2@cnMinLevelValF         =     -40
 ;res2@cnLevelSpacingF        =      10
 res2@lbLabelBarOn           =      True
 plot(8)=gsn_csm_contour_map(wks,Diff(2,:,:),res2)

 resw@cnFillOn               = False
 resw@cnLinesOn		     = True
 resw@cnInfoLabelOn          = False
 resw@cnLineLabelsOn         = False
 resw@cnLevelSelectionMode   = "ExplicitLevels"     ; manual contour levels
 resw@cnLevels       =  0.6
 resw@cnLineThicknessF       = 4.0
 resw@cnMonoLevelFlag=True
 resw@cnLineColor    =   "magenta"
 resw@cnMonoLineDashPattern=True
 resw@cnLineDashPattern=0

 plot1(0)=gsn_csm_contour(wks,First_sic_av(0,:,:),resw)
 plot1(1)=gsn_csm_contour(wks,First_sic_av(1,:,:),resw)
 plot1(2)=gsn_csm_contour(wks,First_sic_av(2,:,:),resw)

 plot2(0)=gsn_csm_contour(wks,Last_sic_av(0,:,:),resw)
 plot2(1)=gsn_csm_contour(wks,Last_sic_av(1,:,:),resw)
 plot2(2)=gsn_csm_contour(wks,Last_sic_av(2,:,:),resw)

 overlay(plot(0),plot1(0))
 overlay(plot(3),plot1(1))
 overlay(plot(6),plot1(2))

 overlay(plot(1),plot2(0))
 overlay(plot(4),plot2(1))
 overlay(plot(7),plot2(2))

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnPanelLabelBar      = False
 pres@lbLabelFontHeightF  = 0.015
 pres@gsnPanelLeft=0.1
 pres@gsnMaximize        =       False
 pres@gsnPanelYWhiteSpacePercent = 8
 pres@lbLabelStride     =   4
 pres@gsnPanelMainString=""

 txres               = True                      ; text mods desired
 txres@txFontHeightF = 0.015                     ; text font height
 gsn_text_ndc(wks,"flat10",0.05,0.685,txres)
 gsn_text_ndc(wks,"flat10-zec",0.05,0.485,txres)
 gsn_text_ndc(wks,"flat10-cdr",0.05,0.285,txres)

 txres1               = True                      ; text mods desired
 txres1@txFontHeightF = 0.014                     ; text font height
 gsn_text_ndc(wks,"[ g C m~S~-2~N~ yr~S~-1~N~ ]",0.25,0.13,txres1)
 gsn_text_ndc(wks,"[ g C m~S~-2~N~ yr~S~-1~N~ ]",0.55,0.13,txres1)
 gsn_text_ndc(wks,"[ g C m~S~-2~N~ yr~S~-1~N~ ]",0.85,0.13,txres1)

 gsn_panel(wks,plot,(/3,3/),pres)
 frame(wks)
end
