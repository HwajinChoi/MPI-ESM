import numpy as np
import pandas as pd
import xarray as xr
from scipy import stats

dir='/data/hjchoi/CMI/OBA/code/'
dset1 = xr.open_dataset(dir+'Oxygen_predi_cobalt_15e_90w.nc')
O2=dset1.O_budget.sel()
O_bio=dset1.O_bio.sel()
lateral=O2[0,:]
vertical=O2[1,:]
Ot_prime=O2[2,:]

dset2 = xr.open_dataset(dir+'Oxygen_predi_lead_1_15e_90w.nc')
O2_lt1=dset2.O_budget_lt1.sel()
O_bio_lt1=dset2.O_bio_lt1.sel()
lateral_lt1=O2_lt1[0,:]
vertical_lt1=O2_lt1[1,:]
Ot_prime_lt1=O2_lt1[2,:]

dset3 = xr.open_dataset(dir+'Oxygen_predi_lead_2_15e_90w.nc')
O2_lt2=dset3.O_budget_lt2.sel()
O_bio_lt2=dset3.O_bio_lt2.sel()
lateral_lt2=O2_lt2[0,:]
vertical_lt2=O2_lt2[1,:]
Ot_prime_lt2=O2_lt2[2,:]

## reg,interc,corr,pval
Ot_lt1 = stats.linregress(Ot_prime[1:28],Ot_prime_lt1)[0:4]
Ot_lt2 = stats.linregress(Ot_prime[2:28],Ot_prime_lt2)[0:4]

lat_lt1 = stats.linregress(lateral[1:28],lateral_lt1)[0:4]
lat_lt2 = stats.linregress(lateral[2:28],lateral_lt2)[0:4]

vert_lt1 = stats.linregress(vertical[1:28],vertical_lt1)[0:4]
vert_lt2 = stats.linregress(vertical[2:28],vertical_lt2)[0:4]

O_bio_lt1 = stats.linregress(O_bio[1:28],O_bio_lt1)[0:4]
O_bio_lt2 = stats.linregress(O_bio[2:28],O_bio_lt2)[0:4]

print('Ot_prime, LT = 1 (corr) = ')
print(Ot_lt1[2])
print('Ot_prime, LT = 1 (pval) = ')
print(Ot_lt1[3])
print('Ot_prime, LT = 2 (corr) = ')
print(Ot_lt2[2])
print('Ot_prime, LT = 2 (pval) = ')
print(Ot_lt2[3])
print('---------------------------------------------------------------')
print('Lateral, LT = 1 (corr) = ')
print(lat_lt1[2])
print('Lateral, LT = 1 (pval) = ')
print(lat_lt1[3])
print('Lateral, LT = 2 (corr) = ')
print(lat_lt2[2])
print('Lateral, LT = 2 (pval) = ')
print(lat_lt2[3])
print('---------------------------------------------------------------')
print('Vertical, LT = 1 (corr) = ')
print(vert_lt1[2])
print('Vertical, LT = 1 (pval) = ')
print(vert_lt1[3])
print('Vertical, LT = 2 (corr) = ')
print(vert_lt2[2])
print('Vertical, LT = 2 (pval) = ')
print(vert_lt2[3])
print('---------------------------------------------------------------')
print('Residual, LT = 1 (corr) = ')
print(O_bio_lt1[2])
print('Residual, LT = 1 (pval) = ')
print(O_bio_lt1[3])
print('Residual, LT = 2 (corr) = ')
print(O_bio_lt2[2])
print('Residual, LT = 2 (pval) = ')
print(O_bio_lt2[3])
