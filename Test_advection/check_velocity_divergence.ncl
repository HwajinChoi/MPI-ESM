begin
  ;==========================================================
  ; 1. Input files
  ;==========================================================
  gridfile = "/work/uo1451/m301158/MPI-ESM/data/Test_budget_close/" + \
             "flat10_cdr_budget_002_mpiom_fx_18500101_18501231.nc"
  dir="/work/uo1451/m301158/MPI-ESM/data/Test_advection/"
  fu_file = addfile(dir+"uo_prime_185001.nc", "r")
  fv_file = addfile(dir+"vo_prime_185001.nc", "r")
  g       = addfile(gridfile, "r")

  ;==========================================================
  ; 2. Read velocity anomalies
  ;==========================================================
  u = todouble(fu_file->uo)   ; (time, depth, y_2, x_2)
  v = todouble(fv_file->vo)   ; (time, depth, y_3, x_3)

  ; Read horizontal grid distances
  dx = todouble(g->dlxu(0,0,:,:))
  dy = todouble(g->dlyv(0,0,:,:))

  print("=== Grid distances ===")
  printMinMax(dx, True)
  printMinMax(dy, True)

  print("=== Velocity anomalies ===")
  printMinMax(u, True)
  printMinMax(v, True)

  ;==========================================================
  ; 3. Dimensions
  ;==========================================================
  sz = dimsizes(u)

  nt = sz(0)
  nz = sz(1)
  ny = sz(2)
  nx = sz(3)

  ;==========================================================
  ; 4. Horizontal velocity divergence
  ;==========================================================
  dudx = new(sz, double, default_fillvalue("double"))
  dvdy = new(sz, double, default_fillvalue("double"))

  ; x-direction
  dudx(:,:,:,1:nx-1) = \
       (u(:,:,:,1:nx-1) - u(:,:,:,0:nx-2)) / \
       conform_dims((/nt,nz,ny,nx-1/), dx(:,1:nx-1), (/2,3/))

  ; y-direction
  dvdy(:,:,1:ny-1,:) = \
       (v(:,:,1:ny-1,:) - v(:,:,0:ny-2,:)) / \
       conform_dims((/nt,nz,ny-1,nx/), dy(1:ny-1,:), (/2,3/))

  ; Horizontal velocity divergence
  divH = dudx + dvdy

  ;==========================================================
  ; 5. Print results
  ;==========================================================
  print("=== dudx (s-1) ===")
  printMinMax(dudx, True)

  print("=== dvdy (s-1) ===")
  printMinMax(dvdy, True)

  print("=== Horizontal velocity divergence (s-1) ===")
  printMinMax(divH, True)

end
