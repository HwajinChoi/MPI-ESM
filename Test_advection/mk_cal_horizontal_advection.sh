#!/bin/bash

for year in $(seq 1851 2299);do

cat << EOF > ./imsi.ncl

begin
  dir1 = "/work/uo1451/m301158/MPI-ESM/data/Test_advection/"

  gridfile = "/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/" + \
             "flat10_cdr_budget_002_mpiom_fx_18500101_18501231.nc"

  infile  = dir1 + "DIC_flux_decomposition_${year}01-${year}12.nc"
  outfile = dir1 + "DIC_horizontal_advection_${year}01-${year}12.nc"

  f = addfile(infile, "r")
  g = addfile(gridfile, "r")

  ; Grid distances (m)
  dx = g->dlxu(0,0,:,:)
  dy = g->dlyv(0,0,:,:)

  terms = (/"meanCprime", "primeCmean", "primeCprime"/)

  system("/bin/rm -f " + outfile)
  fo = addfile(outfile, "c")

; Define dimensions and coordinates
    filedimdef(fo, "time",  -1, True)
    filedimdef(fo, "depth", 40, False)
    filedimdef(fo, "y_2",  220, False)
    filedimdef(fo, "x_2",  256, False)

  ; Copy time and depth coordinates
    fo->time  = f->time
    fo->depth = f->depth

  ; Copy tracer-grid longitude and latitude
    fo->lon_2 = g->lon_2
    fo->lat_2 = g->lat_2

  do n = 0, dimsizes(terms)-1

    term = terms(n)

    fu = f->\$("uo_" + term)\$
    fv = f->\$("vo_" + term)\$

    ; Expected dimensions: time, depth, y, x
    sz = dimsizes(fu)
    nt = sz(0)
    nz = sz(1)
    ny = sz(2)
    nx = sz(3)

    ; Allocate arrays with missing values
    dudx = new(sz, double)
    dvdy = new(sz, double)
    ; Backward difference in x
    sz_x = (/nt, nz, ny, nx-1/)

    dudx(:,:,:,1:nx-1) = (fu(:,:,:,1:nx-1) - fu(:,:,:,0:nx-2)) / conform_dims(sz_x, dx(:,1:nx-1), (/2,3/))

    ; Backward difference in y
    sz_y = (/nt, nz, ny-1, nx/)

    dvdy(:,:,1:ny-1,:) = (fv(:,:,1:ny-1,:) - fv(:,:,0:ny-2,:)) / conform_dims(sz_y, dy(1:ny-1,:), (/2,3/))

    ; Horizontal advection tendency
    adv = -(dudx + dvdy)

    adv@long_name = "Approximate horizontal advection: " + term
    adv@units = "mol m-3 s-1"

    varname = "advH_" + term

    ; Set dimension names
    adv!0 = "time"
    adv!1 = "depth"
    adv!2 = "y_2"
    adv!3 = "x_2"

    ; Attach coordinate variables
    adv&time  = f->time
    adv&depth = f->depth

    ; Geographic coordinates for mapping
    adv@coordinates = "lon_2 lat_2"

    ; Save
    fo->\$varname\$ = adv

    print("Finished: " + varname)

    delete(fu)
    delete(fv)
    delete(dudx)
    delete(dvdy)
    delete(adv)

  end do

  print("Output: " + outfile)
end
EOF
 ncl   ./imsi.ncl
 rm -f ./imsi.ncl

done

