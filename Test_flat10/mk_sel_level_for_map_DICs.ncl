begin
dir1="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/"
dir2="/work/uo1451/m301158/MPI-ESM/data/flat10mip_with_pref/PI/"

f0=addfile(dir1+"dissic_flat10_cdr_1850-2299_an.nc","r")
dic=f0->dissic
lat=f0->lat
lon=f0->lon
f1=addfile(dir1+"dissicnat_flat10_cdr_1850-2299_an.nc","r")
dicnat=f1->dissicnat
f2=addfile(dir1+"dissicant_flat10_cdr_1850-2299_an.nc","r")
dicant=dic-dicnat
copy_VarCoords(dic,dicant)
f4=addfile(dir2+"dissic_test_pictrl_preform_001_spinup_8920-8949_an.nc","r")
dic_pi=f4->dissic

dic_0_1000m=dic(:,{0:1000},:,:)
dicnat_0_1000m=dicnat(:,{0:1000},:,:)
dicant_0_1000m=dicant(:,{0:1000},:,:)
dic_pi_0_1000m=dic_pi(:,{0:1000},:,:)
dic_2000_3000m=dic(:,{2000:3000},:,:)
dicnat_2000_3000m=dicnat(:,{2000:3000},:,:)
dicant_2000_3000m=dicant(:,{2000:3000},:,:)
dic_pi_2000_3000m=dic_pi(:,{2000:3000},:,:)

dic_3000_6000m=dic(:,{3000:6000},:,:)
dicnat_3000_6000m=dicnat(:,{3000:6000},:,:)
dicant_3000_6000m=dicant(:,{3000:6000},:,:)
dic_pi_3000_6000m=dic_pi(:,{3000:6000},:,:)
;-------------------------------------------------------------------
dic_pi_0_1000m_clim=dim_avg_n_Wrap(dic_pi_0_1000m,0)
dic_pi_2000_3000m_clim=dim_avg_n_Wrap(dic_pi_2000_3000m,0)
dic_pi_3000_6000m_clim=dim_avg_n_Wrap(dic_pi_3000_6000m,0)

dim=dimsizes(dic_0_1000m)
dim1=dimsizes(dic_2000_3000m)
dim2=dimsizes(dic_3000_6000m)

dic_pi_0_1000m_2=new((/450,dim(1),dim(2),dim(3)/),typeof(dic_0_1000m))
dic_pi_2000_3000m_2=new((/450,dim1(1),dim(2),dim(3)/),typeof(dic_2000_3000m))
dic_pi_3000_6000m_2=new((/450,dim2(1),dim(2),dim(3)/),typeof(dic_3000_6000m))

do i =0,450-1
 dic_pi_0_1000m_2(i,:,:,:)=dic_pi_0_1000m_clim
 dic_pi_2000_3000m_2(i,:,:,:)=dic_pi_2000_3000m_clim
 dic_pi_3000_6000m_2(i,:,:,:)=dic_pi_3000_6000m_clim
end do

dic_0_1000m_ano=dic_0_1000m-dic_pi_0_1000m_2
dic_2000_3000m_ano=dic_2000_3000m-dic_pi_2000_3000m_2
dic_3000_6000m_ano=dic_3000_6000m-dic_pi_3000_6000m_2

dicnat_0_1000m_ano=dicnat_0_1000m-dic_pi_0_1000m_2
dicnat_2000_3000m_ano=dicnat_2000_3000m-dic_pi_2000_3000m_2
dicnat_3000_6000m_ano=dicnat_3000_6000m-dic_pi_3000_6000m_2

copy_VarCoords(dic_0_1000m,dic_0_1000m_ano)
copy_VarCoords(dic_2000_3000m,dic_2000_3000m_ano)
copy_VarCoords(dic_3000_6000m,dic_3000_6000m_ano)

copy_VarCoords(dicnat_0_1000m,dicnat_0_1000m_ano)
copy_VarCoords(dicnat_2000_3000m,dicnat_2000_3000m_ano)
copy_VarCoords(dicnat_3000_6000m,dicnat_3000_6000m_ano)

;-----------------------------------------------------------
DIC_0_1000m=dim_avg_n_Wrap(dic_0_1000m_ano,1)
DIC_2000_3000m=dim_avg_n_Wrap(dic_2000_3000m_ano,1)
DIC_3000_6000m=dim_avg_n_Wrap(dic_3000_6000m_ano,1)

DICNAT_0_1000m=dim_avg_n_Wrap(dicnat_0_1000m_ano,1)
DICNAT_2000_3000m=dim_avg_n_Wrap(dicnat_2000_3000m_ano,1)
DICNAT_3000_6000m=dim_avg_n_Wrap(dicnat_3000_6000m_ano,1)

DICANT_0_1000m=dim_avg_n_Wrap(dicant_0_1000m,1)
DICANT_2000_3000m=dim_avg_n_Wrap(dicant_2000_3000m,1)
DICANT_3000_6000m=dim_avg_n_Wrap(dicant_3000_6000m,1)

system("rm -f "+dir1+"DICs_3diff_depth_avg_map_ano_1850-2299.nc")
out=addfile(    dir1+"DICs_3diff_depth_avg_map_ano_1850-2299.nc","c")
out->DIC_0_1000m=DIC_0_1000m
out->DIC_2000_3000m=DIC_2000_3000m
out->DIC_3000_6000m=DIC_3000_6000m
out->DICNAT_0_1000m=DICNAT_0_1000m
out->DICNAT_2000_3000m=DICNAT_2000_3000m
out->DICNAT_3000_6000m=DICNAT_3000_6000m
out->DICANT_0_1000m=DICANT_0_1000m
out->DICANT_2000_3000m=DICANT_2000_3000m
out->DICANT_3000_6000m=DICANT_3000_6000m
out->lon=lon
out->lat=lat

end
