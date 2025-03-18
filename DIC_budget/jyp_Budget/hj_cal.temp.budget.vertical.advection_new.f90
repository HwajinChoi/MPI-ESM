program budget

IMPLICIT NONE
INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=336, nt=6000

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
REAL                  :: temp(lx,ly,lz), tempt(lx,ly,lz)
REAL                  :: wt(lx,ly,lz), wt2(lx,ly,lz), vadv(lx,ly,lz)
REAL                  :: mvadv(lx,ly,lz)
REAL                  :: lat(ly)
REAL                  :: lev(lz)
INTEGER               :: i, j, k, it
DATA   lev /5316.43, 4950.41, 4587.74, 4230.62, 3881.16, 3541.39, 3213.21, 2898.37, 2598.46, 2314.88, 2048.83, 1801.28, 1572.97, 1364.41, 1175.83, 1007.26, 858.422, 728.828, 617.736, 524.171, 446.937, 384.634, 335.676, 298.305, 270.621, 250.6, 236.123, 225, 215, 205, 195, 185, 175, 165, 155, 145, 135, 125, 115, 105, 95, 85, 75, 65, 55, 45, 35, 25, 15, 5/

OPEN (1, file='/data/hjchoi/CMI/OBA/data/gdata/new_temp_199001-201712.gdat',form='unformatted',access='direct', recl=lx*ly*lz*4,status='old')
OPEN (4, file='/data/hjchoi/CMI/OBA/data/gdata/new_wt_199001-201712.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')
open (19, file='/data/hjchoi/CMI/OBA/data/gdata/new.temp.vadv.199001-201712.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')

DO it=1, lt
read(1,rec=it) temp(:,:,:)
read(4,rec=it) wt(:,:,:)

DO k=1, lz
DO j=1, ly
DO i=1, lx
if(k==lz) then
  wt2(i,j,k)=0.5*(wt(i,j,k)+0)
else
  wt2(i,j,k)=0.5*(wt(i,j,k+1)+wt(i,j,k))
endif

!where(COUNT(temp(:,:,:) .ne. undef) .ne. 0)
if(k==1) then
  vadv(i,j,k)=-wt2(i,j,k)*((temp(i,j,k+1)-temp(i,j,k))/(lev(k)-lev(k+1)))
elseif(k==lz) then
  vadv(i,j,k)=-wt2(i,j,k)*((temp(i,j,k)-temp(i,j,k-1))/(lev(k-1)-lev(k)))
else
  vadv(i,j,k)=-wt2(i,j,k)*((temp(i,j,k+1)-temp(i,j,k-1))/(lev(k-1)-lev(k+1)))
endif
!elsewhere
!vadv(:,:,k)=undef
!endwhere

ENDDO
ENDDO
ENDDO

write(19,rec=it) vadv(:,:,:)

ENDDO
close (19)

end program budget
