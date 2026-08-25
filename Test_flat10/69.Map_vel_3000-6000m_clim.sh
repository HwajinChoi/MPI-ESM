#!/bin/bash

for i in $(seq 0 44); do

cat <<EOF > ./imsi.ncl
begin
dir0="/work/uo1451/m301158/MPI-ESM/image/velocity/"
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/raw/"

f=addfile(dir1+"flat10_cdr_001_vel_3000-6000m_avg_r192x96_1850-2299.nc","r")

u1=f->uo(10*${i}:10*${i}+9,:,:)
v1=f->vo(10*${i}:10*${i}+9,:,:)
u = u1*100
v = v1*100
copy_VarCoords(u1,u)
copy_VarCoords(v1,v)

u_clim=dim_avg_n_Wrap(u,0)
v_clim=dim_avg_n_Wrap(v,0)

Y1=1850+10*${i}
Y2=1850+10*${i}+9

wks = gsn_open_wks("png",dir0+"Map_Vector_10years_avg_"+${i})               ; send graphics to PNG file

vcres                         = True             ; plot mods desired
vcres@gsnFrame                = False            ; so we can draw time stamp
vcres@mpLandFillColor = "gray"
vcres@vcGlyphStyle            = "LineArrow"    ; turn on curly vectors
vcres@vcRefAnnoOrthogonalPosF = -1.0             ; move ref vector up
vcres@vcRefMagnitudeF         = 0.6             ; define vector ref mag
vcres@vcRefLengthF            = 0.022            ; define length of vec ref
vcres@vcMinDistanceF = 0.025
vcres@mpCenterLonF =180
vcres@vcLineArrowThicknessF      = 2
vcres@gsnCenterString=Y1+"_"+Y2
vcres@gsnRightString="cm/s"
vcres@gsnLeftString=""
;vcres@mpMinLatF = -60
;vcres@mpMaxLatF = 80

vector = gsn_csm_vector_map(wks,u_clim,v_clim,vcres)

frame(wks)

end
EOF

  ncl ./imsi.ncl
  rm -f ./imsi.ncl
done
