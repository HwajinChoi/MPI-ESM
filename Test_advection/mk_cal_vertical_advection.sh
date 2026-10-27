#!/bin/bash

for year in $(seq 1850 1850);do

cat << EOF > ./imsi2.ncl

begin
  dir1 = "/work/uo1451/m301158/MPI-ESM/data/Test_advection/"

  infile = dir1 + "DIC_vertical_flux_decomposition_${year}01-${year}12.nc"

  gridfile = "/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/" + \
             "flat10_cdr_budget_002_mpiom_fx_18500101_18501231.nc"

  outfile = dir1 + "DIC_vertical_advection_${year}01-${year}12.nc"

  f = addfile(infile, "r")
  g = addfile(gridfile, "r")

  ; Layer thickness (40 levels)
  dz = (/ g->ddpo(0,:,:,:) /)

  terms = (/"meanCprime", "primeCmean", "primeCprime"/)

  system("/bin/rm -f " + outfile)
  fo = addfile(outfile, "c")

  filedimdef(fo, "time", -1, True)
  filedimdef(fo, "depth", 40, False)
  filedimdef(fo, "y_2", 220, False)
  filedimdef(fo, "x_2", 256, False)

  fo->time = f->time
  fo->depth = f->depth
  fo->lon_2 = f->lon_2
  fo->lat_2 = f->lat_2

  do n = 0, dimsizes(terms)-1

    term = terms(n)
    varname = "wo_" + term

    flux = (/ f->\$varname\$ /)

    sz = dimsizes(flux)

    ; Initialize with missing values
    adv = new(sz, float, -9.e33)

    ; Distance between adjacent layer centers
    dzmid = 0.5 * (dz(0:38,:,:) + dz(1:39,:,:))

    ; Approximate derivative at levels 0-38
    adv(:,0:38,:,:) = - \
      (flux(:,1:39,:,:) - flux(:,0:38,:,:)) / \
      conform_dims((/sz(0),39,sz(2),sz(3)/), \
                   dzmid, (/1,2,3/))

    adv!0 = "time"
    adv!1 = "depth"
    adv!2 = "y_2"
    adv!3 = "x_2"

    adv&time = f->time
    adv&depth = f->depth

    adv@long_name = "Approximate vertical advection: " + term
    adv@units = "mol m-3 s-1"
    adv@coordinates = "lon_2 lat_2"

    outname = "advV_" + term
    fo->\$outname\$ = adv

    print("Finished: " + outname)

    delete(flux)
    delete(adv)

  end do

  print("Finished: " + outfile)
end
EOF
 ncl ./imsi2.ncl
 rm -f ./imsi2.ncl

done

