begin
dir1="/home/m/m300595/iScript/mask/GR15/"

f=addfile(dir1+"dissic_invent_global.nc","r")
dissic=f->dissic
print(dissic)
end
