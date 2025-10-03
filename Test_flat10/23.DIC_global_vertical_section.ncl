begin
dir1="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissic_1850_2149.nc","r")
g=addfile(dir1+"test_flat10_001_cfcs_ideal_r192x96_dissicnat_1850_2149.nc","r")

tot=f->dissic
nat=g->dissicnat
depth=f->depth
dim=dimsizes(depth)
tot1=dim_avg_n_Wrap(tot,2)
tot2=dim_avg_n_Wrap(tot1,2); time * depth
tot2=tot2*(10^(6)/1035)

nat1=dim_avg_n_Wrap(nat,2)
nat2=dim_avg_n_Wrap(nat1,2); time * depth
nat2=nat2*(10^(6)/1035)

DIC=new((/2,dim(0)/),"float")
DIC(0,:)=tot2(299,:)
DIC(1,:)=nat2(299,:)

wks   = gsn_open_wks ("png",dir2+"vert_glb_avg_DIC_flat10_last_year")                  ; send graphics to PNG file
res                   = True                       ; plot mods desired
res@tiMainString      = ""             ; add title
res@trYReverse        = True                       ; reverse Y-axis
res@xyDashPatterns    = (/0,0/) 
res@xyLineThicknesses=(/4,4/)
res@xyLineColors=(/"black","blue"/)
res@tiXAxisString="DIC [micro mol kg-1]"
res@tiYAxisString="Depth [m]"
res@trXMinF=0
res@trXMaxF=2300
plot  = gsn_csm_xy (wks,DIC,depth,res) ; create plot

end
