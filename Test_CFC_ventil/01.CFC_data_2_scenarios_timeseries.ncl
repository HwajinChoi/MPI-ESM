begin
dir1="/pool/data/MPIOM/input/r0014/CFC/"
f=addfile(dir1+"CFC_Atm_Hist_2015.nc","r")
cfc11_nh=f->cfc11_nh(:,0,0) ; time(251,)
cfc12_nh=f->cfc12_nh(:,0,0)
cfc11_sh=f->cfc11_sh(:,0,0)
cfc12_sh=f->cfc12_sh(:,0,0)
printVarSummary(cfc11_nh)
exit


end
