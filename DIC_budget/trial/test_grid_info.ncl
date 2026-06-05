begin
dir1="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_pictrl_ver2_002_cfcs/outdata/mpiom/"

f=addfile(dir1+"test_pictrl_ver2_002_cfcs_mpiom_data_3d_mm_20000101_20001231.nc","r")
lat=f->lat
lat_2=f->lat_2
lat_3=f->lat_3
lat_vertices=f->lat_vertices

test_lat=lat(0,1)-lat(0,0)
test_lat_2=lat_2(0,1)-lat_2(0,0)
test_lat_3=lat_3(0,1)-lat_3(0,0)
test_lat_vertices=lat_vertices(0,1,0)-lat_vertices(0,0,0)

print(lat(0,0:2))
;print(test_lat)
print(lat_2(0,0:2))
;print(test_lat_2)
print(lat_3(0,0:2))
;print(test_lat_3)
print(lat_vertices(0,0:2,0))
;print(test_lat_vertices)
exit

end
