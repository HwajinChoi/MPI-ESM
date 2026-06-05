#!/bin/sh

dir0=/data/hjchoi/CMI/OBA/data/advection/new/raw
dir1=/data/hjchoi/CMI/OBA/data/advection/new

for v in "dz" ;do
#for v in "dt" "dy" "dx" ;do

 a=`ls -rt ${dir0}/ECDA-COBALT_dT_${v}_*m_advection_199001-201712.nc | head -10`
 b=`ls -rt ${dir0}/ECDA-COBALT_dT_${v}_[1-2]??m_advection_199001-201712.nc`
 c=`ls -rt ${dir0}/ECDA-COBALT_dT_${v}_2??.*m_advection_199001-201712.nc`
 d=`ls -rt ${dir0}/ECDA-COBALT_dT_${v}_[3-7]??.*m_advection_199001-201712.nc`
 cdo -s -ensmean ${a} ${dir1}/ECDA-COBALT_dT_${v}_0-100m_advection_199001-201712.nc
 cdo -s -ensmean ${b} ${c} ${dir1}/ECDA-COBALT_dT_${v}_100-300m_advection_199001-201712.nc
 cdo -s -ensmean ${d} ${dir1}/ECDA-COBALT_dT_${v}_300-800m_advection_199001-201712.nc
done
