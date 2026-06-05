begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_budget/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"

A=60
B=120

f=addfile(dir1+"flat10_cdr_budget_tsco212_gasex_186001_186912.nc","r")
g=addfile(dir1+"flat10_cdr_budget_tsco212nat_gasex_186001_186912.nc","r")

tsco212_gasex=f->tsco212_gasex(:,0,:,:)
tsco212nat_gasex=g->tsco212nat_gasex(:,0,:,:)

a=addfile(dir1+"flat10_cdr_fgco2_186001_186912.nc","r")
b=addfile(dir1+"flat10_cdr_fgco2nat_186001_186912.nc","r")
fgco2=a->fgco2(:,0,:,:)
fgco2nat=b->fgco2nat(:,0,:,:)

f1=addfile(dir1+"flat10_cdr_budget_terms_tsco212_sosi_186001_186912.nc","r")
g1=addfile(dir1+"flat10_cdr_budget_terms_tsco212nat_sosi_186001_186912.nc","r")
tsco212_sosi=f1->tsco212_sosi
tsco212nat_sosi=g1->tsco212nat_sosi

dim=dimsizes(fgco2)
dic_sosi_c=new((/dim(0),dim(1),dim(2)/),typeof(fgco2))
dic_sosi_c=tsco212_sosi(:,0,:,:)-(2700*(fgco2/12))/12
copy_VarCoords(fgco2,dic_sosi_c)

dicnat_sosi_c=new((/dim(0),dim(1),dim(2)/),typeof(fgco2))
dicnat_sosi_c=tsco212nat_sosi(:,0,:,:)-(2700*(fgco2nat/12))/12
copy_VarCoords(fgco2,dicnat_sosi_c)

DIC=new((/2,dim(0),dim(1),dim(2)/),typeof(fgco2))
DIC(0,:,:,:)=dic_sosi_c
DIC(1,:,:,:)=-tsco212_gasex

DICnat=new((/2,dim(0),dim(1),dim(2)/),typeof(fgco2))
DICnat(0,:,:,:)=dicnat_sosi_c
DICnat(1,:,:,:)=-tsco212nat_gasex

year=ispan(1,120,1)
wks=gsn_open_wks("png",dir2+"CDR_air_sea_exchange_check")
plot=new(2,graphic)
 res                =   True
 res@gsnMaximize    =   True
 ;res@gsnPaperOrientation =       "portrait"
 res@vpWidthF       = 0.8            ; Change the aspect ratio, but 
 res@vpHeightF          =0.6
 res@gsnFrame            =       False
 res@gsnDraw             =       False
 res@tiMainFontThicknessF=10
 res@trXMinF             =       0
 res@trXMaxF             =       120

; res@trYMinF             =       -6
; res@trYMaxF             =       8
 res@tiXAxisString       =       "Simulation years"
 res@tiYAxisString       =       "[ mol m-3 s-1 ]"
 res@xyLineThicknessF= 4
 res@tiXAxisFontHeightF =0.03
 res@tiYAxisFontHeightF =0.03
 res@tiMainFontHeightF =0.04
 res@tmYRMinorPerMajor=4
 res@xyLineColors   = (/"blue","red"/)
 res@xyDashPatterns   =   (/0,0/)
 res@gsnLeftStringFontHeightF=0.05
 res@gsnCenterStringFontHeightF=0.035
 res@gsnLeftStringOrthogonalPosF=0.06
 res@gsnCenterString="DIC~B~tot~N~"
 res@tmXBLabelFontHeightF = 0.03
 res@tmYLLabelFontHeightF = 0.03
 plot(0)=gsn_csm_xy(wks,year,DIC(:,:,A,B),res)
 res@gsnCenterString="DIC~B~nat~N~"
 plot(1)=gsn_csm_xy(wks,year,DICnat(:,:,A,B),res)

 gres = True
 gres@YPosPercent = 94.
 gres@XPosPercent = 62
 gres@ItemSpacePercent          = 8
 lineres = True
 lineres@lgLineColors =(/"blue","red"/)
 lineres@lgLineThicknesses = (/6,6/)
 lineres@LineLengthPercent = 6.
 lineres@lgDashIndexes            = (/0,0/)
 textres = True
 textres@lgLabels = (/"gasex_recon","gasex"/)
 textres@lgLabelFontHeights   =(/0.025,0.025/)
 textres@lgPerimOn                = False
 textres@lgItemCount              = 4

 plot(0) = simple_legend(wks,plot(0),gres,lineres,textres)
 plot(1) = simple_legend(wks,plot(1),gres,lineres,textres)

 pres                       =   True
 pres@gsnFrame         = False
 pres@gsnMaximize        =       True
 pres@gsnPanelYWhiteSpacePercent = 4

 gsn_panel(wks,plot,(/2,1/),pres)

 frame(wks)





end
