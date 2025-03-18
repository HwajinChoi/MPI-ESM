begin
dir1="/data/hjchoi/CMI/OBA/data/spilt_levels/"
dir2="/data/hjchoi/CMI/OBA/data/"
lat_s=-20
lat_f=20
lon_s=150
lon_f=270

name1="wt_*m_COBALT.199001-201712.nc"
files=systemfunc("ls -rt "+dir1+name1+" | head -34")
d=asciiread(dir2+"sw_ocean",-1,"string")
depth=d(0:33)

f=addfiles(files,"r")
ListSetType(f,"join")
wt0=f[:]->wt
wt=wt0(:,:,0,:,:)
wt!0="depth"
wt&depth=depth
wt := wt(time|:,depth|:,yt_ocean|:,xt_ocean|:)
wt := wt(:,:,{lat_s:lat_f},{lon_s:lon_f})
wt_clim=dim_avg_n_Wrap(wt,0);depth*lat*lon
dim=dimsizes(wt_clim)
wt_lat_clim=dim_avg_n_Wrap(wt_clim,2)
wt_lon_clim=dim_avg_n_Wrap(wt_clim,1)

wt_lat_clim_2=generate_2d_array(20,20,,,0,(/dim(0),dim(1)/))
wt_lon_clim_2=generate_2d_array(20,20,,,0,(/dim(0),dim(2)/))

wks   = gsn_open_wks ("x11", "W_vertical_profile" )          ; send graphics to PNG file
res                      = True                 ; plot mods desired
;res@cnLevelSelectionMode = "ManualLevels"       ; manually select levels
;res@cnLevelSpacingF      = 5.0                  ; contour spacing
;res@cnMinLevelValF       = -50.                 ; min level
;res@cnMaxLevelValF       =  50.                 ; max level
res@tmYLMode            =   "Mannual"
res@tmYLTickStartF          =   0
res@tmYLTickEndF          =   1000
res@tmYLTickSpacingF       =20
res@cnLineLabelsOn       = True                 ; turn on line labels
res@cnFillOn             = True                 ; turn on color fill
res@cnFillPalette        = "BlWhRe"
;res@sfXArray            =   wt&yt_ocean
;res@sfYArray            =   depth
;res@gsnYAxisIrregular2Linear = True
res@tiMainString        =   ""
plot  = gsn_csm_contour(wks, wt_lat_clim, res )   ; plaace holder





end
