begin
;--------------------------------------------
; EQUATOR : 150E-90E (270), 20S-20N
; SP region : 160W-110W, 15S-10S
;--------------------------------------------
dir0="/data/hjchoi/CMI/OBA/data/advection/new/"
dir1="/data/hjchoi/CMI/OBA/data/advection/"
dir2="/data/hjchoi/CMI/OBA/image/"
lat_s=-20
lat_f=20
lon_s=150
lon_f=270

g=addfile(dir0+"ECDA-COBALT_dT_dx_100-300m_advection_199001-201712.nc","r")
u_bar_T_prime=g->u_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_T_bar=g->u_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h=addfile(dir0+"ECDA-COBALT_dT_dy_100-300m_advection_199001-201712.nc","r")
v_bar_T_prime=h->v_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_T_bar=h->v_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k=addfile(dir0+"ECDA-COBALT_dT_dz_100-300m_advection_199001-201712.nc","r")
w_bar_T_prime=k->w_bar_T_prime(:,{lat_s:lat_f},{lon_s:lon_f})
w_prime_T_bar=k->w_prime_T_bar(:,{lat_s:lat_f},{lon_s:lon_f})

m=addfile(dir0+"ECDA-COBALT_dT_dt_100-300m_advection_199001-201712.nc","r")
Tt_prime=m->Tt_prime(:,{lat_s:lat_f},{lon_s:lon_f})

lateral=u_bar_T_prime+u_prime_T_bar+v_bar_T_prime+v_prime_T_bar
vertical=w_bar_T_prime+w_prime_T_bar
copy_VarCoords(v_prime_T_bar,lateral)
copy_VarCoords(v_prime_T_bar,vertical)

dim1=dimsizes(u_bar_T_prime)
T_seperated=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
T_seperated(0,:,:,:)=lateral
T_seperated(1,:,:,:)=vertical
T_seperated(2,:,:,:)=Tt_prime
copy_VarCoords(u_bar_T_prime,T_seperated(0,:,:,:))
T_seperated!0="variables"
T_seperated1=dim_avg_n_Wrap(T_seperated,2)
T_seperated2=dim_avg_n_Wrap(T_seperated1,2)
T_seperated2=T_seperated2*60*60*24*30
T_seperated2 := T_seperated2(time|:,variables|:)
T_seperated3=month_to_annual(T_seperated2,1)
T_seperated3 := T_seperated3(variables|:,year|:)
;-----------------------------------------------------------------------------
dim2=dimsizes(T_seperated3)
T_test=new((/dim2(0)-1,dim2(1)/),"float")
T_test=T_seperated3(0:dim2(0)-2,:)
T_test2=dim_sum_n_Wrap(T_test,0); Sum 

T_bio=T_seperated3(2,:)-T_test2
T_bio!0="year"
;-----------------------------------------------------------------------------
T_plot=new((/5,dim2(1)/),"float")
T_plot(0:2,:)=T_seperated3
T_plot(3,:)=T_test2
T_plot(4,:)=T_bio

corr=new(4,"float")
corr(0:1)=escorc(T_plot(2,:),T_plot(0:1,:))
corr(2)=escorc(T_plot(2,:),T_plot(3,:))
corr(3)=escorc(T_plot(2,:),T_plot(4,:))
print(corr)

end
