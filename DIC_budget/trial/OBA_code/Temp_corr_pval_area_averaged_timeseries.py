import numpy as np
import pandas as pd
import xarray as xr
from scipy import stats

dir='/data/hjchoi/CMI/OBA/code/'
dset1 = xr.open_dataset(dir+'3components_temperature_budget_1990-2017.nc')
T=dset1.T_plot.sel()
lateral=T[0,1:28]
vertical=T[1,1:28]
T_prime=T[2,1:28]
SUM=T[3,1:28]
residual=T[4,1:28]

## reg,interc,corr,pval
Lateral_s = stats.linregress(T_prime,lateral)[0:4]
Vertical_s = stats.linregress(T_prime,vertical)[0:4]
sum_s = stats.linregress(T_prime,SUM)[0:4]
resi_s = stats.linregress(T_prime,residual)[0:4]

print('lateral & T (corr) = ')
print(Lateral_s[2])
print('lateral & T (pval) = ')
print(Lateral_s[3])

print('Vertical & T (corr) = ')
print(Vertical_s[2])
print('Vertical & T (pval) = ')
print(Vertical_s[3])

print('Sum & T (corr) = ')
print(sum_s[2])
print('Sum & T (pval) = ')
print(sum_s[3])

print('Residual & T (corr) = ')
print(resi_s[2])
print('Residual & T (pval) = ')
print(resi_s[3])
