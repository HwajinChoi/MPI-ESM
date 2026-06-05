begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir1="/work/uo1451/m301158/MPI-ESM/image/"

f=addfile(dir0+"flat10_cdr_budget_terms_tsco212nat_1850_1999_bathy_timsum.nc","r")
avg_bathy=f->avg_bathy ; variable(tend ,adv, dif , gm, sosi, surf) * depth * lat * lon 
lon=f->lon
lat=f->lat
avg_bathy@lat2d=lat
avg_bathy@lon2d=lon

avg_bathy=avg_bathy*1000
dim=dimsizes(avg_bathy)

avg_bathy_sub=new((/4,dim(1),dim(2),dim(3)/),typeof(avg_bathy))
avg_bathy_sub(0,:,:,:)=avg_bathy(1,:,:,:)
avg_bathy_sub(1,:,:,:)=avg_bathy(2,:,:,:)
avg_bathy_sub(2,:,:,:)=avg_bathy(3,:,:,:)
avg_bathy_sub(3,:,:,:)=avg_bathy(5,:,:,:)

avg_bathy_sum=dim_sum_n_Wrap(avg_bathy_sub,0)

plot=new(3,graphic)
plot3=new(3,graphic)
plot2=new(3,graphic)

;do i =4,1
i=4

H1=500*(12-(3*i)+1)
H2=500*(12-(3*i)+2)
H3=500*(12-(3*i)+3)
h1=tostring(H1)
h2=tostring(H2)
h3=tostring(H3)

wks   = gsn_open_wks ("png", dir1+"Map_CDR_DICnat_sum_Positive_changes_sosi_other_terms_bathymetry_"+i )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
res@vpWidthF       = 0.9            ; Change the aspect ratio, but 
res@lbLabelFontHeightF  = 0.023
res@vpHeightF      = 0.8
res@gsnDraw                =       False
res@gsnFrame               =       False
res@cnLineLabelsOn         =       False
res@cnFillOn             = True                 ; turn on color fill
res@cnInfoLabelOn          =   False
res@sfYArray = lat
res@sfXArray=lon
res@gsnMajorLonSpacing = 60 

res@cnLinesOn=False
res@cnFillPalette        = "GMT_polar"
res@cnLevelSelectionMode   =       "ManualLevels"
;res@mpProjection ="Robinson"
res@mpMaxLatF=0
res@mpMinLatF=-90
res@mpPerimOn = False
res@mpCenterLonF =180
res@cnMissingValFillColor="gray"
res@mpLandFillColor    =   "gray"

res@gsnCenterStringFontHeightF= 0.045
res@gsnCenterStringOrthogonalPosF=0.05
res@tmXBLabelFontHeightF=0.04
res@tmYLLabelFontHeightF=0.04
res@tiYAxisFontHeightF=0.04
res@lbOrientation="vertical"

res@cnFillPalette        = "GMT_polar"
res@lbLabelBarOn           = True
res@gsnCenterString="Change"
res@gsnLeftString=""
res@gsnRightString=""
res@cnMaxLevelValF         =     0.000005
res@cnMinLevelValF         =     -0.000005
res@cnLevelSpacingF        =      0.000001
plot(0)  = gsn_csm_contour_map(wks, avg_bathy(0,3*i-1,:,:), res )   ; plaace holder
res@gsnCenterString="Adv+dif+GM+surf"
plot(1)  = gsn_csm_contour_map(wks, avg_bathy_sum(3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sinik"
plot(2)  = gsn_csm_contour_map(wks, avg_bathy(4,3*i-1,:,:),res )   ; plaace holder
res@gsnCenterString="Change"
plot2(0)  = gsn_csm_contour_map(wks, avg_bathy(0,3*i-2,:,:), res )   ; plaace holder
res@gsnCenterString="Adv+dif+GM+surf"
plot2(1)  = gsn_csm_contour_map(wks, avg_bathy_sum(3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sinik"
plot2(2)  = gsn_csm_contour_map(wks, avg_bathy(4,3*i-2,:,:),res )   ; plaace holder
res@gsnCenterString="Change"
plot3(0)  = gsn_csm_contour_map(wks, avg_bathy(0,3*i-3,:,:), res )   ; plaace holder
res@gsnCenterString="Adv+dif+GM+surf"
plot3(1)  = gsn_csm_contour_map(wks, avg_bathy_sum(3*i-3,:,:),res )   ; plaace holder
res@gsnCenterString="Source&sinik"
plot3(2)  = gsn_csm_contour_map(wks, avg_bathy(4,3*i-3,:,:),res )   ; plaace holder

pres                       =   True
pres@gsnFrame         = False
pres@gsnMaximize        =       True
pres@gsnPanelYWhiteSpacePercent = 2
pres@gsnPanelXWhiteSpacePercent = 1
pres@gsnPanelLeft=0.1
pres@gsnPanelRight=0.95
pres@gsnPanelLabelBar      = False
pres2=pres
pres3=pres
pres@gsnPanelTop=1.
pres@gsnPanelBottom=0.50
pres2@gsnPanelTop=0.78
pres2@gsnPanelBottom=0.32

pres3@gsnPanelTop=0.72
pres3@gsnPanelBottom=0.0
pres3@gsnPanelLeft=0.11
pres3@gsnPanelRight=0.94
pres3@gsnPanelLabelBar      = False
pres3@lbLabelFontHeightF  = 0.013
pres2@lbLabelStride     =   4
;pres@lbLabelStrings       = sprintf("%4.2f",levels)   ; Format the labels

txres1               = True
txres1@txAngleF=90
txres1@txFontHeightF = 0.014

gsn_text_ndc(wks,"H - "+h1+"m",0.06,0.79,txres1)
gsn_text_ndc(wks,"H - "+h2+"m",0.06,0.58,txres1)
gsn_text_ndc(wks,"H - "+h3+"m",0.06,0.40,txres1)
txres2=True
txres2@txFontHeightF = 0.014
gsn_text_ndc(wks,"[m mol/m~S~2~N~]",0.84,0.33,txres2)
txres2@txFontHeightF = 0.017
gsn_text_ndc(wks,"H : water column depth",0.84,0.88,txres2)
gsn_panel(wks,plot,(/2,3/),pres)
gsn_panel(wks,plot2,(/2,3/),pres2)
gsn_panel(wks,plot3,(/2,3/),pres3)

frame(wks)
;end do

end
