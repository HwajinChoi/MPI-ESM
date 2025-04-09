begin
dir1="/work/bg1446/g260241/input/esm-flat10/"
f=addfile(dir1+"T63_carbon_emissions_esm-flat10.nc","r")
emi=f->carbon_emission
printVarSummary(emi)
exit


end
