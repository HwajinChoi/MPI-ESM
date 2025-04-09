begin
dir1="/work/bg1446/g260241/input/esm-flat10/"
dir2="/work/uo1451/m301158/MPI-ESM/image/"
f=addfile(dir1+"T63_carbon_emissions_esm-flat10.nc","r")

em=f->carbon_emission
print(em(:,50,50))
exit
x=ispan(1,151,1)
 plot=new(1,graphic)
 wks=gsn_open_wks("png",dir2+"test")
 res                        =   True
 res@gsnFrame               =       False
 res@gsnDraw                =       False

 plot=gsn_xy(wks,x,em(0:150,0,0),res)
 frame(wks)
 draw(plot)
end
