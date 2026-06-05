import numpy as np
import pandas as pd
import xarray as xr
from scipy import stats

dir='/data/hjchoi/CMI/PAPER/code/'
dset1 = xr.open_dataset(dir+'3components_oxygen_budget_1990-2017.nc')
O2=dset1.O2_budget.sel()
lateral=O2[0,1:28]
vertical=O2[1,1:28]
Ot_prime=O2[2,1:28]
SUM=O2[3,1:28]
residual=O2[4,1:28]

## reg,interc,corr,pval
Lateral_s = stats.linregress(Ot_prime,lateral)[0:4]
Vertical_s = stats.linregress(Ot_prime,vertical)[0:4]
sum_s = stats.linregress(Ot_prime,SUM)[0:4]
resi_s = stats.linregress(Ot_prime,residual)[0:4]

print('lateral & O2 (corr) = ')
print(Lateral_s[2])
print('lateral & O2 (pval) = ')
print(Lateral_s[3])

print('Vertical & O2 (corr) = ')
print(Vertical_s[2])
print('Vertical & O2 (pval) = ')
print(Vertical_s[3])

print('Sum & O2 (corr) = ')
print(sum_s[2])
print('Sum & O2 (pval) = ')
print(sum_s[3])

print('Residual & O2 (corr) = ')
print(resi_s[2])
print('Residual & O2 (pval) = ')
print(resi_s[3])
