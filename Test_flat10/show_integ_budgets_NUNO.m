clear

% option detrend

dissic=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','dissic');

tsco212_tot=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_tot');

tsco212_adv=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_adv');

tsco212_gm=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_gm');

tsco212_dif=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_dif');

tsco212_surf=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_surf');

tsco212_sosi=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_sosi');

tsco212_tot=detrend(squeeze(tsco212_tot(90,110,1,:)));
tsco212_adv=detrend(squeeze(tsco212_adv(90,110,1,:)));
tsco212_gm=detrend(squeeze(tsco212_gm(90,110,1,:)));
tsco212_dif=detrend(squeeze(tsco212_dif(90,110,1,:)));
tsco212_surf=detrend(squeeze(tsco212_surf(90,110,1,:)));
tsco212_sosi=detrend(squeeze(tsco212_sosi(90,110,1,:)));

%tsco212_sum=tsco212_adv+tsco212_gm+tsco212_dif+tsco212_surf+tsco212_sosi;


figure(1);clf;plot([1:12],cumsum(tsco212_tot.*(365.25/12)*86400),'k',[1:12],cumsum(tsco212_adv.*(365.25/12)*86400+tsco212_gm.*(365.25/12)*86400),'b',[1:12],cumsum(tsco212_dif.*(365.25/12)*86400),'r',[1:12],cumsum(tsco212_surf.*(365.25/12)*86400),'g',[1:12],cumsum(tsco212_sosi.*(365.25/12)*86400),'y');hold on;plot([1:12],cumsum(tsco212_sosi.*0),'k--');axis([1 12 -.12 .12]);legend('tot','adv+gm','dif','sur','sosi');title('removed trend from budget terms');xlabel('time [months]');ylabel('DIC anomaly [mol m^-^3]');set(gca,'fontsize',14)
%hold on
%plot([1:12],cumsum(tsco212_sum.*(365.25/12)*86400),'c')

%-----------------------------------------------

% option demean

dissic=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','dissic');

tsco212_tot=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_tot');

tsco212_adv=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_adv');

tsco212_gm=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_gm');

tsco212_dif=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_dif');

tsco212_surf=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_surf');

tsco212_sosi=ncread('/work/uo1451/m301158/mpiesm-1.2.01p7_test/experiments/flat10_cdr_001/outdata/hamocc/flat10_cdr_001_hamocc_data_3d_mm_18770101_18771231.nc','tsco212_sosi');


tsco212_tot=squeeze(tsco212_tot(90,110,1,:))-mean(squeeze(tsco212_tot(90,110,1,:)));
tsco212_adv=squeeze(tsco212_adv(90,110,1,:))-mean(squeeze(tsco212_adv(90,110,1,:)));
tsco212_gm=squeeze(tsco212_gm(90,110,1,:))-mean(squeeze(tsco212_gm(90,110,1,:)));
tsco212_dif=squeeze(tsco212_dif(90,110,1,:))-mean(squeeze(tsco212_dif(90,110,1,:)));
tsco212_surf=squeeze(tsco212_surf(90,110,1,:))-mean(squeeze(tsco212_surf(90,110,1,:)));
tsco212_sosi=squeeze(tsco212_sosi(90,110,1,:))-mean(squeeze(tsco212_sosi(90,110,1,:)));

%tsco212_sum=tsco212_adv+tsco212_gm+tsco212_dif+tsco212_surf+tsco212_sosi;

figure(2);clf;plot([1:12],cumsum(tsco212_tot.*(365.25/12)*86400),'k',[1:12],cumsum(tsco212_adv.*(365.25/12)*86400+tsco212_gm.*(365.25/12)*86400),'b',[1:12],cumsum(tsco212_dif.*(365.25/12)*86400),'r',[1:12],cumsum(tsco212_surf.*(365.25/12)*86400),'g',[1:12],cumsum(tsco212_sosi.*(365.25/12)*86400),'y');hold on;plot([1:12],cumsum(tsco212_sosi.*0),'k--');axis([1 12 -.12 .12]);legend('tot','adv+gm','dif','sur','sosi');title('removed mean from budget terms');xlabel('time [months]');ylabel('DIC anomaly [mol m^-^3]');set(gca,'fontsize',14)
%hold on
%plot([1:12],cumsum(tsco212_sum.*(365.25/12)*86400),'c')


