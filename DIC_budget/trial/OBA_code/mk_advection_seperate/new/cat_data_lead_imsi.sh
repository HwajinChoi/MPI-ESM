#!/bin/sh

dir0=/media/Backup_plus/OBA/data/advection/raw
dir1=/data/hjchoi/CMI/OBA/data/advection/new
for A in "2";do
# for v in "dz" ;do
for v in "dx" "dz" ;do

 a=`ls -rt ${dir0}/LT_${A}_dO_${v}_*m_advection_199${A}01-201712.nc | head -10`
 b=`ls -rt ${dir0}/LT_${A}_dO_${v}_[1-2]??m_advection_199${A}01-201712.nc`
 c=`ls -rt ${dir0}/LT_${A}_dO_${v}_2??.*m_advection_199${A}01-201712.nc`
 d=`ls -rt ${dir0}/LT_${A}_dO_${v}_[3-7]??.*m_advection_199${A}01-201712.nc`
 cdo -s -ensmean ${a} ${dir1}/LT_${A}_dO_${v}_0-100m_advection_199${A}01-201712.nc
 cdo -s -ensmean ${b} ${c} ${dir1}/LT_${A}_dO_${v}_100-300m_advection_199${A}01-201712.nc
 cdo -s -ensmean ${d} ${dir1}/LT_${A}_dO_${v}_300-800m_advection_199${A}01-201712.nc
 done
done
