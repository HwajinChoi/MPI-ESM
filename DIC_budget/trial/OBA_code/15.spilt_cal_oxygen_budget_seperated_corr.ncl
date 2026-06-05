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

g=addfile(dir0+"ECDA-COBALT_dO_dx_100-300m_advection_199001-201712.nc","r")
u_bar_O_prime=g->u_bar_O_prime(:,{lat_s:lat_f},{lon_s:lon_f})
u_prime_O_bar=g->u_prime_O_bar(:,{lat_s:lat_f},{lon_s:lon_f})

h=addfile(dir0+"ECDA-COBALT_dO_dy_100-300m_advection_199001-201712.nc","r")
v_bar_O_prime=h->v_bar_O_prime(:,{lat_s:lat_f},{lon_s:lon_f})
v_prime_O_bar=h->v_prime_O_bar(:,{lat_s:lat_f},{lon_s:lon_f})

k=addfile(dir0+"ECDA-COBALT_dO_dz_100-300m_advection_199001-201712.nc","r")
w_bar_O_prime=k->w_bar_O_prime(:,{lat_s:lat_f},{lon_s:lon_f})
w_prime_O_bar=k->w_prime_O_bar(:,{lat_s:lat_f},{lon_s:lon_f})

m=addfile(dir0+"ECDA-COBALT_dO_dt_100-300m_advection_199001-201712.nc","r")
Ot_prime=m->Ot_prime(:,{lat_s:lat_f},{lon_s:lon_f})

lateral=u_bar_O_prime+u_prime_O_bar+v_bar_O_prime+v_prime_O_bar
vertical=w_bar_O_prime+w_prime_O_bar
copy_VarCoords(v_prime_O_bar,lateral)
copy_VarCoords(v_prime_O_bar,vertical)

dim1=dimsizes(u_bar_O_prime)
O_seperated=new((/3,dim1(0),dim1(1),dim1(2)/),"float")
O_seperated(0,:,:,:)=lateral
O_seperated(1,:,:,:)=vertical
O_seperated(2,:,:,:)=Ot_prime
copy_VarCoords(u_bar_O_prime,O_seperated(0,:,:,:))
O_seperated!0="variables"
O_seperated1=dim_avg_n_Wrap(O_seperated,2)
O_seperated2=dim_avg_n_Wrap(O_seperated1,2)
O_seperated2=O_seperated2*60*60*24*30
O_seperated2 := O_seperated2(time|:,variables|:)
O_seperated3=month_to_annual(O_seperated2,1)
O_seperated3 := O_seperated3(variables|:,year|:)
;-----------------------------------------------------------------------------
dim2=dimsizes(O_seperated3)
O_test=new((/dim2(0)-1,dim2(1)/),"float")
O_test=O_seperated3(0:dim2(0)-2,:)
O_test2=dim_sum_n_Wrap(O_test,0); Sum 
O_bio=O_seperated3(2,:)-O_test2
O_bio!0="year"
;-----------------------------------------------------------------------------
O_plot=new((/5,dim2(1)/),"float")
O_plot(0:2,:)=O_seperated3
O_plot(3,:)=O_test2
O_plot(4,:)=O_bio

corr=new(4,"float")
corr(0:1)=escorc(O_plot(2,:),O_plot(0:1,:))
corr(2)=escorc(O_plot(2,:),O_plot(3,:))
corr(3)=escorc(O_plot(2,:),O_plot(4,:))

;corr_test=escorc(O_plot(0,:),O_plot(1,:))
print(corr)    

end
