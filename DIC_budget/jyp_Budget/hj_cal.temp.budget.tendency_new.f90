program budget

IMPLICIT NONE

INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=336, nt=6000

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
REAL                  :: temp(lx,ly,lz),tempa(lx,ly,lz),tempaa(lx,ly,lz)
REAL                  :: ten(lx,ly,lz)
REAL                  :: lat(ly)
REAL                  :: lev(lz)

INTEGER               :: i, j, k, it
DATA   lev /5316.43, 4950.41, 4587.74, 4230.62, 3881.16, 3541.39, 3213.21, 2898.37, 2598.46, 2314.88, 2048.83, 1801.28, 1572.97, 1364.41, 1175.83, 1007.26, 858.422, 728.828, 617.736, 524.171, 446.937, 384.634, 335.676, 298.305, 270.621, 250.6, 236.123, 225, 215, 205, 195, 185, 175, 165, 155, 145, 135, 125, 115, 105, 95, 85, 75, 65, 55, 45, 35, 25, 15, 5/

OPEN (1, file='/data/hjchoi/CMI/OBA/data/gdata/new_temp_199001-201712.gdat',form='unformatted',access='direct', recl=lx*ly*lz*4,status='old')

open (21, file='/data/hjchoi/CMI/OBA/data/gdata/new_DT_dt_199001-201712.gdat', form='unformatted', access='direct', recl=lx*ly*lz*4, status='unknown')

DO it=1, lt
if(it==lt) then
read(1,rec=it-1) tempa(:,:,:)
read(1,rec=it) tempaa(:,:,:)
elseif(it==1) then
read(1,rec=it) tempa(:,:,:)
read(1,rec=it+1) tempaa(:,:,:)
else
read(1,rec=it-1) tempa(:,:,:)
read(1,rec=it) temp(:,:,:)
read(1,rec=it+1) tempaa(:,:,:)
endif


do j=1, ly
lat(j)=(j-90.5)*(pi/180)
!print*, cos(lat(j))
enddo

DO k=1, lz
DO j=1, ly
DO i=1, lx
!print*, k,j,i,"32232"
if(tempa(i,j,k) .ne. undef) then

if(it==lt) then
ten(i,j,k)=(tempaa(i,j,k)-tempa(i,j,k))/(86400*30.5)
elseif(it==1) then
ten(i,j,k)=(tempaa(i,j,k)-tempa(i,j,k))/(86400*30.5)
else
ten(i,j,k)=(tempaa(i,j,k)-tempa(i,j,k))/(86400*61)
endif

else 
ten(i,j,k)=undef 
endif
ENDDO
ENDDO
ENDDO
write(21,rec=it) ten(:,:,:)

ENDDO
close (21)

end program budget
