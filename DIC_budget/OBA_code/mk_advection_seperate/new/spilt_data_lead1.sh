#!/bin/bash
dir0=/data/hjchoi/CMI/data/predict/imsi
dir1=/data/hjchoi/CMI/OBA/data
dir2=/data/hjchoi/CMI/OBA/data/spilt_levels

for v in "u" "o2" "v" "temp" "wt" ;do
#for v in "o2" "temp";do
 if [ ${v} = "wt" ] ;then
   w="sw_ocean"
   a0="xt_ocean=f->xt_ocean"
   a1="yt_ocean=f->yt_ocean"
   a2="st_ocean=f->sw_ocean"
   b0="out->yt_ocean=yt_ocean"
   b1="out->xt_ocean=xt_ocean"
 elif [ ${v} = "o2" ]  || [  ${v} = "temp" ] ;then
   w="st_ocean"
   a0="xt_ocean=f->xt_ocean"
   a1="yt_ocean=f->yt_ocean"
   a2="st_ocean=f->st_ocean"
   b0="out->yt_ocean=yt_ocean"
   b1="out->xt_ocean=xt_ocean"
 else
   w="st_ocean"
   a0="xu_ocean=f->xu_ocean"
   a1="yu_ocean=f->yu_ocean"
   a2="st_ocean=f->st_ocean"
   b0="out->yu_ocean=yu_ocean"
   b1="out->xu_ocean=xu_ocean"
 fi
 B=${dir1}/${w}
    for i in "1" ;do # Leadtime
        for n in `seq 1991 ${i} 2017` ;do 
        echo "####################################################################"
        echo "# Input : ${v}.ensmean.${n}01.nc"
        echo "# Lead time : ${i} year"
        echo "####################################################################"
        cat <<EOF > ./mk_predict_vari.ncl
        begin
        f=addfile("${dir0}/${v}.ensmean.${n}01.nc","r")
        g=asciiread("${B}",(/50/),"string")
        do k=0,49
        print(g(k))
        ${v}=f->${v}(0:11,{g(k)},:,:)
        ${a0}
        ${a1}
        ${a2}
        time=f->time(0:11)

        system("rm -f ${dir2}/${v}_"+g(k)+"m_lead_${i}_${n}.nc")
        out=addfile( "${dir2}/${v}_"+g(k)+"m_lead_${i}_${n}.nc","c")
        out->${v}=${v}
        ${b0}
        ${b1}
        out->time=time
        print("Accomplished ${v}_"+g(k)+"m_lead_${i}_${n}.nc")
        end do
        end
EOF
    ncl ./mk_predict_vari.ncl
    rm -f ./mk_predict_vari.ncl
    done
 done
done



