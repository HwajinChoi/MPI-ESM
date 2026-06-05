begin
dir1="/data/hjchoi/CMI/OBA/data/advection/"

f=addfile(dir1+"ECDA-COBALT_Oxygern_budget_advection_199001-201712.nc","r")
Oy=f->Oy
Ox=f->Ox
Ot=f->Ot
Oz=f->Oz

g=addfile(dir1+"ECDA-COBALT_dO_dt_100-300_advection_199001-201712.nc","r")
Ot_prime=g->Ot_prime
Ot_bar=g->Ot_bar

h=addfile(dir1+"ECDA-COBALT_dO_dy_100-300_advection_199001-201712.nc","r")
v_bar_O_prime=h->v_bar_O_prime
v_bar_O_bar=h->v_bar_O_bar
v_prime_O_prime=h->v_prime_O_prime
v_prime_O_bar=h->v_prime_O_bar

k=addfile(dir1+"ECDA-COBALT_dO_dx_100-300_advection_199001-201712.nc","r")
u_bar_O_prime=k->u_bar_O_prime
u_bar_O_bar=k->u_bar_O_bar
u_prime_O_prime=k->u_prime_O_prime
u_prime_O_bar=k->u_prime_O_bar

d=addfile(dir1+"ECDA-COBALT_dO_dz_all_depth_advection_199001-201712.nc","r")
w_bar_O_prime=d->w_bar_O_prime(:,:,:,1)
w_bar_O_bar=d->w_bar_O_bar(:,:,:,1)
w_prime_O_prime=d->w_prime_O_prime(:,:,:,1)
w_prime_O_bar=d->w_prime_O_bar(:,:,:,1)


;O_test=Ot-(Ot_prime+Ot_bar)
;printMinMax(Ot,0)
;printMinMax(O_test,0)

O_x_test=Ox-(u_bar_O_prime+u_bar_O_bar+u_prime_O_prime+u_prime_O_bar)

printMinMax(Ox,0)
print("O_x_test = ")
printMinMax(O_x_test,0)

O_y_test=Oy-(v_bar_O_prime+v_bar_O_bar+v_prime_O_prime+v_prime_O_bar)
printMinMax(Oy,0)
print("O_y_test = ")
printMinMax(O_y_test,0)

O_z_test=Oz-(w_bar_O_prime+w_bar_O_bar+w_prime_O_prime+w_prime_O_bar)
printMinMax(Oz,0)
print("O_z_test = ")
printMinMax(O_z_test,0)
end
