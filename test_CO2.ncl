begin
dir1="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2/experiments/monitoring/test_pictrl003/echam6/plots"

f=addfile(dir1+"/test_pictrl003_echam6_tracer_gym.nc","r")
co2=f->CO2(0:49,0,0,0)
co2_avg=dim_avg_n_Wrap(co2,0)
print(co2_avg)
exit
end
