import numpy as np
import pandas as pd
import xarray as xr
from scipy import stats

dir='/data/hjchoi/CMI/OBA/code/'
dset1 = xr.open_dataset(dir+'Temp_predi_cobalt_15e_90w.nc')
Temp=dset1.T_budget.sel()
T_bio=dset1.T_bio.sel()
lateral=Temp[0,:]
vertical=Temp[1,:]
Tt_prime=Temp[2,:]

dset2 = xr.open_dataset(dir+'Temp_predi_lead_1_15e_90w.nc')
Temp_lt1=dset2.T_budget_lt1.sel()
T_bio_lt1=dset2.T_bio_lt1.sel()
lateral_lt1=Temp_lt1[0,:]
vertical_lt1=Temp_lt1[1,:]
Tt_prime_lt1=Temp_lt1[2,:]

dset3 = xr.open_dataset(dir+'Temp_predi_lead_2_15e_90w.nc')
Temp_lt2=dset3.T_budget_lt2.sel()
T_bio_lt2=dset3.T_bio_lt2.sel()
lateral_lt2=Temp_lt2[0,:]
vertical_lt2=Temp_lt2[1,:]
Tt_prime_lt2=Temp_lt2[2,:]

## reg,interc,corr,pval
Tt_lt1 = stats.linregress(Tt_prime[1:28],Tt_prime_lt1)[0:4]
Tt_lt2 = stats.linregress(Tt_prime[2:28],Tt_prime_lt2)[0:4]

lat_lt1 = stats.linregress(lateral[1:28],lateral_lt1)[0:4]
lat_lt2 = stats.linregress(lateral[2:28],lateral_lt2)[0:4]

vert_lt1 = stats.linregress(vertical[1:28],vertical_lt1)[0:4]
vert_lt2 = stats.linregress(vertical[2:28],vertical_lt2)[0:4]

T_bio_lt1 = stats.linregress(T_bio[1:28],T_bio_lt1)[0:4]
T_bio_lt2 = stats.linregress(T_bio[2:28],T_bio_lt2)[0:4]

print('Tt_prime, LT = 1 (corr) = ')
print(Tt_lt1[2])
print('Tt_prime, LT = 1 (pval) = ')
print(Tt_lt1[3])
print('Tt_prime, LT = 2 (corr) = ')
print(Tt_lt2[2])
print('Tt_prime, LT = 2 (pval) = ')
print(Tt_lt2[3])
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
print(T_bio_lt1[2])
print('Residual, LT = 1 (pval) = ')
print(T_bio_lt1[3])
print('Residual, LT = 2 (corr) = ')
print(T_bio_lt2[2])
print('Residual, LT = 2 (pval) = ')
print(T_bio_lt2[3])
