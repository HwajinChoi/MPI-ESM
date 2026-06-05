program read_netcdf
  use netcdf          ! NetCDF 모듈
  implicit none

  integer :: ncid, varid, retval
  integer :: dim1, dim2
  real, dimension(:,:), allocatable :: data

  ! open a NetCDF file 
  retval = nf90_open("", NF90_NOWRITE, ncid)
  if (retval /= nf90_noerr) then
     print *, 'Error opening file: ', trim(nf90_strerror(retval))
     stop
  end if

  ! 변수 ID 얻기 (예: "temperature"라는 변수)
  retval = nf90_inq_varid(ncid, "temperature", varid)

  ! 변수 차원 정보 얻고, 필요한 크기로 allocate
  ! 여기서는 간단화를 위해 크기 고정 예시
  allocate(data(100, 50))

  ! 데이터 읽기
  retval = nf90_get_var(ncid, varid, data)

  ! 파일 닫기
  retval = nf90_close(ncid)

  ! 데이터 출력 (예시)
  print *, data(1,1)

end program read_netcdf

