begin
dir1="/work/uo1451/m301158/MPI-ESM/data/input/"

f=addfile(dir1+"T63_carbon_emissions_esm-flat10_nz_1849-2298.nc","r")
E=f->carbon_emission
print(E(:,80,100))
exit
end
