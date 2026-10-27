#!/bin/bash

for year in $(seq 1851 2299);do

cat << EOF > ./imsi3.ncl

begin
  dir1 = "/work/uo1451/m301158/MPI-ESM/data/Test_advection/"

  cfile = dir1 + "dissicnat_${year}01-${year}12.nc"
  wfile = dir1 + "velocity_${year}01-${year}12.nc"

  cmfile = dir1 + "dissicnat_flat10_cdr_mean_1850-2299.nc"
  wmfile = dir1 + "velocity_mean_1850-2299.nc"

  outfile = dir1 + "DIC_vertical_flux_decomposition_${year}01-${year}12.nc"

  fc = addfile(cfile, "r")
  fw = addfile(wfile, "r")
  fcm = addfile(cmfile, "r")
  fwm = addfile(wmfile, "r")

  C = (/fc->dissicnat/)
  Cmean = (/fcm->dissicnat/)

; Read raw arrays without coordinate metadata
  w = (/ fw->wo /)
  wmean = (/ fwm->wo /)

  print("C dimensions: " + dimsizes(C))
  print("w dimensions: " + dimsizes(w))

  ; wo: 41 interfaces -> 40 layer centers
  wcenter = 0.5 * (w(:,0:39,:,:) + w(:,1:40,:,:))
  wmcenter = 0.5 * (wmean(:,0:39,:,:) + wmean(:,1:40,:,:))

  sz = dimsizes(C)

  ; Broadcast 450-year means across 12 months
  Cm = conform_dims(sz, Cmean(0,:,:,:), (/1,2,3/))
  wm = conform_dims(sz, wmcenter(0,:,:,:), (/1,2,3/))

  Cp = C - Cm
  wp = wcenter - wm

  ; Three time-varying flux terms
  meanCprime = wm * Cp
  primeCmean = wp * Cm
  primeCprime = wp * Cp

  ; Output
  system("/bin/rm -f " + outfile)
  fo = addfile(outfile, "c")

  filedimdef(fo, "time", -1, True)
  filedimdef(fo, "depth", 40, False)
  filedimdef(fo, "y_2", 220, False)
  filedimdef(fo, "x_2", 256, False)

  fo->time = fc->time
  fo->depth = fc->depth

  ; Copy tracer-grid coordinates
  gridfile = "/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/" + \
             "flat10_cdr_budget_002_mpiom_fx_18500101_18501231.nc"
  fg = addfile(gridfile, "r")

  lon = fg->lon_2
  lat = fg->lat_2
  if (isatt(lon, "bounds")) then
    delete(lon@bounds)
  end if
  if (isatt(lat, "bounds")) then
    delete(lat@bounds)
  end if

  fo->lon_2 = lon
  fo->lat_2 = lat

  meanCprime!0 = "time"
  meanCprime!1 = "depth"
  meanCprime!2 = "y_2"
  meanCprime!3 = "x_2"

  primeCmean!0 = "time"
  primeCmean!1 = "depth"
  primeCmean!2 = "y_2"
  primeCmean!3 = "x_2"

  primeCprime!0 = "time"
  primeCprime!1 = "depth"
  primeCprime!2 = "y_2"
  primeCprime!3 = "x_2"

  meanCprime&time = fc->time
  meanCprime&depth = fc->depth
  primeCmean&time = fc->time
  primeCmean&depth = fc->depth
  primeCprime&time = fc->time
  primeCprime&depth = fc->depth

  meanCprime@units = "mol m-2 s-1"
  primeCmean@units = "mol m-2 s-1"
  primeCprime@units = "mol m-2 s-1"

  meanCprime@coordinates = "lon_2 lat_2"
  primeCmean@coordinates = "lon_2 lat_2"
  primeCprime@coordinates = "lon_2 lat_2"

  fo->wo_meanCprime = meanCprime
  fo->wo_primeCmean = primeCmean
  fo->wo_primeCprime = primeCprime

  print("Finished: " + outfile)
end
EOF
 ncl ./imsi3.ncl
 rm -f ./imsi3.ncl

done
