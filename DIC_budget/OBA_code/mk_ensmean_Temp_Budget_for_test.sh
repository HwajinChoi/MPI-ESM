#!/bin/bash
dir1=/data/hjchoi/CMI/OBA/data/advection/new/raw

for n in "dt" "dx" "dy" "dz";do

A1=ECDA-COBALT_dT_${n}_5m_advection_199001-201712.nc
A2=ECDA-COBALT_dT_${n}_15m_advection_199001-201712.nc
A3=ECDA-COBALT_dT_${n}_25m_advection_199001-201712.nc
A4=ECDA-COBALT_dT_${n}_35m_advection_199001-201712.nc
A5=ECDA-COBALT_dT_${n}_45m_advection_199001-201712.nc
A6=ECDA-COBALT_dT_${n}_5-45m_advection_199001-201712.nc

cdo -s -ensmean ${dir1}/${A1} ${dir1}/${A2} ${dir1}/${A3} ${dir1}/${A4} ${dir1}/${A5} ${dir1}/${A6}
echo "Accomplished ${A6}"

done
