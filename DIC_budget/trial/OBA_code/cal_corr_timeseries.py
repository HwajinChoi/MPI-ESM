import numpy as np
import pandas as pd
import xarray as xr
from scipy import stats

dir='/data/hjchoi/CMI/OBA/data/advection/new/'
dset1 = xr.open_dataset(dir+'ECDA-COBALT_dO_dx_100-300m_advection_199001-201712.nc')
dset2 = xr.open_dataset(dir+'ECDA-COBALT_dO_dy_100-300m_advection_199001-201712.nc')
dset3 = xr.open_dataset(dir+'ECDA-COBALT_dO_dz_100-300m_advection_199001-201712.nc')
dset4 = xr.open_dataset(dir+'ECDA-COBALT_dO_dt_100-300m_advection_199001-201712.nc')

min_lon=150
min_lat=-20
max_lat=20
max_lon=270

u_bar_O_prime=dset1.u_bar_O_prime.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
u_prime_O_bar=dset1.u_prime_O_bar.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
v_bar_O_prime=dset2.v_bar_O_prime.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
v_prime_O_bar=dset2.v_prime_O_bar.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
w_bar_O_prime=dset3.w_bar_O_prime.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
w_prime_O_bar=dset3.w_prime_O_bar.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
Ot_prime=dset4.Ot_prime.sel(yt_ocean=slice(min_lat,max_lat),xt_ocean=slice(min_lon,max_lon))
yt_ocean=dset1.yt_ocean.sel(yt_ocean=slice(min_lat,max_lat))

lateral=u_bar_O_prime+u_prime_O_bar+v_bar_O_prime+v_prime_O_bar
vertical=w_bar_O_prime+w_prime_O_bar

Late=lateral.groupby('time.year').mean('time')
Late=Late*60*60*24*30
Vert=vertical.groupby('time.year').mean('time')
Vert=Vert*60*60*24*30
Ot=Ot_prime.groupby('time.year').mean('time')
Ot=Ot*60*60*24*30
SUM=Late+Vert
Re=Ot-SUM
###################################################################################################################3
lat2d,imsi=np.meshgrid(yt_ocean,yt_ocean)
weights = np.cos(np.deg2rad(lat2d))
Late_ave = np.average(Late, weights=weights)
 
stats.linregress(Ot,Late)

