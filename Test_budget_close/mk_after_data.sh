





ncatted -a coordinates,adv_UC,o,c,"lon lat" -a coordinates,adv_VC,o,c,"lon lat" -a coordinates,adv_WC,o,c,"lon lat" DIC_advection_terms_229901-229912.nc

cdo -s -f nc -remapbil,r192x96 -selindexbox,2,255,2,219 DIC_advection_terms_229901-229912.nc DIC_advection_terms_r192x96_229901-229912.nc
