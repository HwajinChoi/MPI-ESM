begin
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
dir="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/test_flat10_001_cfcs_ideal/outdata/jsbach/"
;----------------------------------1,2 Emission & Cumulative emission--------------------
f=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_2150.nc","r")
g=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_zec.nc","r")
h=addfile(dir0+"fld_sum_T63_carbon_emissions_esm-flat10_cdr.nc","r")

f10=f->carbon_emission(:,0,0)
f10_zec=g->carbon_emission(:,0,0)
f10_cdr=h->carbon_emission(:,0,0)

f10_cum=dim_cumsum_Wrap(f10,2)
f10_zec_cum=dim_cumsum_Wrap(f10_zec,2)
f10_cdr_cum=dim_cumsum_Wrap(f10_cdr,2)

E=new((/3,300/),typeof(f10))
E(0,:)=f10(0:299)
E(1,:)=f10_zec(0:299)
E(2,:)=f10_cdr(0:299)
E!0="Scenarios"

E_cum=new((/3,300/),typeof(f10))
E_cum(0,:)=f10_cum(0:299)
E_cum(1,:)=f10_zec_cum(0:299)
E_cum(2,:)=f10_cdr_cum(0:299)
E_cum!0="Scenarios"

delete([/f,g,h,dir0,f10,f10_zec,f10_cdr/])
;----------------------------------3 Atmospheric CO2--------------------
dir0="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_001_cfcs_ideal/echam6/plots/"
dir1="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_zec_001_cfcs_ideal/echam6/plots/"
dir2="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_cdr_001_cfcs_ideal/echam6/plots/"

f=addfile(dir0+"test_flat10_001_cfcs_ideal_echam6_tracer_gym.nc","r")
g=addfile(dir1+"test_flat10_zec_001_cfcs_ideal_echam6_tracer_gym.nc","r")
h=addfile(dir2+"test_flat10_cdr_001_cfcs_ideal_echam6_tracer_gym.nc","r")
f10=f->CO2(:,0,0,0)
f10_zec=g->CO2(:,0,0,0)
f10_cdr=h->CO2(:,0,0,0)
co2=new((/3,300/),typeof(f10))
co2(0,:)=f10
co2(1,:)=f10_zec
co2(2,:)=f10_cdr
co2!0="Scenarios"
co2@long_name="Atmospheric CO2"
delete([/f,g,h,dir0,dir1,dir2,f10,f10_zec,f10_cdr/])
;----------------------------------4 SST--------------------
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
f=addfile(dir0+"fldmean_test_flat10_001_cfcs_ideal_tos_18500101_21491231.nc","r")
g=addfile(dir0+"fldmean_test_flat10_zec_001_cfcs_ideal_tos_18500101_21491231.nc","r")
h=addfile(dir0+"fldmean_test_flat10_cdr_001_cfcs_ideal_tos_18500101_21491231.nc","r")

f10=f->tos(:,0,0,0)
f10_zec=g->tos(:,0,0,0)
f10_cdr=h->tos(:,0,0,0)

f10_2=month_to_annual(f10,1)
f10_zec_2=month_to_annual(f10_zec,1)
f10_cdr_2=month_to_annual(f10_cdr,1)

sst=new((/3,300/),typeof(f10))
sst(0,:)=f10_2
sst(1,:)=f10_zec_2
sst(2,:)=f10_cdr_2
sst!0="Scenarios"
delete([/f,g,h,dir0,f10,f10_zec,f10_cdr/])
;-----------------------------5 NPP----------------------------------------
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"

f=addfile(dir0+"fldmean_test_flat10_001_cfcs_ideal_r192x96_intpp_18500101_21491231.nc","r")
flt_npp=f->intpp(:,0,0,0)
g=addfile(dir0+"fldmean_test_flat10_zec_001_cfcs_ideal_r192x96_intpp_18500101_21491231.nc","r")
flt_zec_npp=g->intpp(:,0,0,0)
h=addfile(dir0+"fldmean_test_flat10_cdr_001_cfcs_ideal_r192x96_intpp_18500101_21491231.nc","r")
flt_cdr_npp=h->intpp(:,0,0,0)

flt_npp_an=month_to_annual(flt_npp,1)
flt_zec_npp_an=month_to_annual(flt_zec_npp,1) ;year x depth x lat
flt_cdr_npp_an=month_to_annual(flt_cdr_npp,1)
delete([/f,g,h,dir0/])
npp=new((/3,300/),typeof(flt_npp))
npp(0,:)=flt_npp_an
npp(1,:)=flt_zec_npp_an
npp(2,:)=flt_cdr_npp_an
npp!0="Scenarios"
npp=npp*12.01*31536000
npp@units="g C m^-2 yr^-1"
;------------6 DIC inventory -----------------------------------------------------------
dir0="/work/bm1030/m300595/hwajin/"
flt_dic_inv=asciiread(dir0+"dictot_invent_flat10",(/300/),"float")
flt_zec_dic_inv=asciiread(dir0+"dictot_invent_flat10_zec",(/300/),"float")
flt_cdr_dic_inv=asciiread(dir0+"dictot_invent_flat10_cdr",(/300/),"float")
flt_dic_inv!0="time"
flt_zec_dic_inv!0="time"
flt_cdr_dic_inv!0="time"

print(flt_dic_inv(0:3))

flt_dic_inv=flt_dic_inv*(10^(3))*12*(10^(-15)) 
flt_zec_dic_inv=flt_zec_dic_inv*(10^(3))*12*(10^(-15)) 
flt_cdr_dic_inv=flt_cdr_dic_inv*(10^(3))*12*(10^(-15))
flt_dic_inv@units="PgC"
flt_zec_dic_inv@units="PgC"
flt_cdr_dic_inv@units="PgC"

dic_inv=new((/3,300/),"float")
dic_inv(0,:)=flt_dic_inv
dic_inv(1,:)=flt_zec_dic_inv
dic_inv(2,:)=flt_cdr_dic_inv
dic_inv!0="Scenarios"
dic_inv!1="year"

print(flt_dic_inv(0:3))
exit

delete([/dir0/])
;------------------------7 AMOC------------------------------------------------------
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
u=addfile(dir0+"atlantic_moc_test_flat10_001_cfcs_ideal_mpiom_data_moc_mm_18500101_21491231.nc","r")
u1=addfile(dir0+"atlantic_moc_test_flat10_zec_001_cfcs_ideal_mpiom_data_moc_mm_18500101_21491231.nc","r")
u2=addfile(dir0+"atlantic_moc_test_flat10_cdr_001_cfcs_ideal_mpiom_data_moc_mm_18500101_21491231.nc","r")
flt_moc=u->atlantic_moc(:,{1000},{26},0)
flt_zec_moc=u1->atlantic_moc(:,{1000},{26},0)
flt_cdr_moc=u2->atlantic_moc(:,{1000},{26},0)

flt_moc_an=month_to_annual(flt_moc,1)
flt_zec_moc_an=month_to_annual(flt_zec_moc,1)
flt_cdr_moc_an=month_to_annual(flt_cdr_moc,1)

AMOC=new((/3,300/),typeof(flt_moc))
AMOC(0,:)=flt_moc_an
AMOC(1,:)=flt_zec_moc_an
AMOC(2,:)=flt_cdr_moc_an
AMOC = AMOC/(1025.*10^6)
AMOC@units="Sv (10^6 m^3/s)"
AMOC!0="Scenarios"
AMOC!1="year"
;-------------- 9 Land Carbon flus
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
f=addfile(dir0+"test_re_Land_flat10_flux_18500101_21491231.nc","r")
g=addfile(dir0+"test_re_Land_flat10_zec_flux_18500101_21491231.nc","r")
h=addfile(dir0+"test_re_Land_flat10_cdr_flux_18500101_21491231.nc","r")
fltC_land=f->var56(:,0,0)
fltC_zec_land=g->var56(:,0,0)
fltC_cdr_land=h->var56(:,0,0)

fltC_land_cum=dim_cumsum_Wrap(fltC_land,2)
fltC_zec_land_cum=dim_cumsum_Wrap(fltC_zec_land,2)
fltC_cdr_land_cum=dim_cumsum_Wrap(fltC_cdr_land,2)

LAND=new((/3,300/),"float")
LAND(0,:)=fltC_land_cum
LAND(1,:)=fltC_zec_land_cum
LAND(2,:)=fltC_cdr_land_cum
LAND!0="Scenarios"

;-----------------8 9 Ocean Carbon flux--------
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
f=addfile(dir0+"flat10_fgCO2_18500101_21491231.nc","r")
g=addfile(dir0+"flat10_zec_fgCO2_18500101_21491231.nc","r")
h=addfile(dir0+"flat10_cdr_fgCO2_18500101_21491231.nc","r")
flt_ocean=f->fgco2(:,0,0,0)
flt_zec_ocean=g->fgco2(:,0,0,0)
flt_cdr_ocean=h->fgco2(:,0,0,0)

f10_oce_cum=dim_cumsum_Wrap(flt_ocean,2)
f10_oce_zec_cum=dim_cumsum_Wrap(flt_zec_ocean,2)
f10_oce_cdr_cum=dim_cumsum_Wrap(flt_cdr_ocean,2)

OCE=new((/3,300/),typeof(flt_ocean))
OCE(0,:)=f10_oce_cum
OCE(1,:)=f10_oce_zec_cum
OCE(2,:)=f10_oce_cdr_cum

delete([/dir0/])
;-----------------10 2m temp--------
dir0="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_001_cfcs_ideal/echam6/plots/"
dir1="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_zec_001_cfcs_ideal/echam6/plots/"
dir2="/work/uo1451/m301158/mpiesm-1.2.01p7-levante-anthroco2_ver2/experiments/monitoring/test_flat10_cdr_001_cfcs_ideal/echam6/plots/"

f=addfile(dir0+"test_flat10_001_cfcs_ideal_echam6_BOT_gym.nc","r")
g=addfile(dir1+"test_flat10_zec_001_cfcs_ideal_echam6_BOT_gym.nc","r")
h=addfile(dir2+"test_flat10_cdr_001_cfcs_ideal_echam6_BOT_gym.nc","r")
flt_t=f->temp2(:,0,0)
flt_zec_t=g->temp2(:,0,0)
flt_cdr_t=h->temp2(:,0,0)

T=new((/3,300/),typeof(flt_t))
T@_FillValue=-9999 
T(0,:)=flt_t
T(1,:)=flt_zec_t
T(2,:)=flt_cdr_t
T!0="Scenarios"
;-------- OUTPUT-------
dir0="/work/uo1451/m301158/MPI-ESM/data/test_flat10/"
system("rm -f "+dir0+"for_figure1_variables_for_timeseries_for_300years.nc")
out=addfile(    dir0+"for_figure1_variables_for_timeseries_for_300years.nc","c")
out->sst=sst
out->co2=co2
out->OCE=OCE
out->LAND=LAND
out->E=E
out->E_cum=E_cum
out->npp=npp
out->AMOC=AMOC
out->dic_inv=dic_inv
out->T=T

end
