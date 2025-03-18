#!/bin/sh

dir0=/data/hjchoi/CMI/OBA/data/advection/new/raw
dir1=/data/hjchoi/CMI/OBA/data/advection/new
for A in "1" "2";do
 for v in "dx" ;do
#for v in "dt" "dy" "dx" "dz" ;do

 a=`ls -rt ${dir0}/LT_${A}_dT_${v}_*m_advection_199${A}01-201712.nc | head -10`
 b=`ls -rt ${dir0}/LT_${A}_dT_${v}_[1-2]??m_advection_199${A}01-201712.nc`
 c=`ls -rt ${dir0}/LT_${A}_dT_${v}_2??.*m_advection_199${A}01-201712.nc`
 d=`ls -rt ${dir0}/LT_${A}_dT_${v}_[3-7]??.*m_advection_199${A}01-201712.nc`
 cdo -s -ensmean ${a} ${dir1}/LT_${A}_dT_${v}_0-100m_advection_199${A}01-201712.nc
 cdo -s -ensmean ${b} ${c} ${dir1}/LT_${A}_dT_${v}_100-300m_advection_199${A}01-201712.nc
 cdo -s -ensmean ${d} ${dir1}/LT_${A}_dT_${v}_300-800m_advection_199${A}01-201712.nc
 done
done
