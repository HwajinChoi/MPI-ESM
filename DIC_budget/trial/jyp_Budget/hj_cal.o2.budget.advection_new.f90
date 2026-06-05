program budget

IMPLICIT NONE

INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=336, nt=6000
!INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=120, nt=6000

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
REAL                  :: o2(lx,ly,lz), o2t(lx,ly,lz)
REAL                  :: u(lx,ly,lz), zadv(lx,ly,lz)
REAL                  :: v(lx,ly,lz), madv(lx,ly,lz)
REAL                  :: wt(lx,ly,lz), wt2(lx,ly,lz), vadv(lx,ly,lz)
REAL                  :: mzadv(lx,ly,lz), mmadv(lx,ly,lz),mvadv(lx,ly,lz)
REAL                  :: lat(ly)
REAL                  :: lev(lz)
INTEGER               :: i, j, k, it
DATA   lev /5316.43, 4950.41, 4587.74, 4230.62, 3881.16, 3541.39, 3213.21, 2898.37, 2598.46, 2314.88, 2048.83, 1801.28, 1572.97, 1364.41, 1175.83, 1007.26, 858.422, 728.828, 617.736, 524.171, 446.937, 384.634, 335.676, 298.305, 270.621, 250.6, 236.123, 225, 215, 205, 195, 185, 175, 165, 155, 145, 135, 125, 115, 105, 95, 85, 75, 65, 55, 45, 35, 25, 15, 5/

OPEN (1, file='/data/hjchoi/CMI/OBA/data/gdata/o2_199001-201712.gdat',form='unformatted',access='direct', recl=lx*ly*lz*4,status='old')
OPEN (2, file='/data/hjchoi/CMI/OBA/data/gdata/u_199001-201712.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')
OPEN (3, file='/data/hjchoi/CMI/OBA/data/gdata/v_199001-201712.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')
OPEN (4, file='/data/hjchoi/CMI/OBA/data/gdata/wt_199001-201712.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')

open (21, file='/data/hjchoi/CMI/OBA/data/gdata/o2.zadv.199001-201712.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')
open (22, file='/data/hjchoi/CMI/OBA/data/gdata/o2.madv.199001-201712.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')
open (19, file='/data/hjchoi/CMI/OBA/data/gdata/o2.vadv.199001-201712.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')

DO it=1, lt
read(1,rec=it) o2(:,:,:)
read(2,rec=it) u(:,:,:)
read(3,rec=it) v(:,:,:)
read(4,rec=it) wt(:,:,:)

!o2(:,:,:)=o2t(:,:,:)*1e6

do j=1, ly
lat(j)=(j-90.5)*(pi/180)
enddo

DO k=1, lz
DO j=1, ly
DO i=1, lx
if(o2(i,j,k) .ne. undef .and. o2(i+1,j,k) .ne. undef .and. o2(i-1,j,k) .ne. undef) then
if(i==1) then
  zadv(i,j,k)=-u(i,j,k)*((o2(i+1,j,k)-o2(lx,j,k))/(2*cos(lat(j))*(pi*re/180)))
elseif (i==lx) then
  zadv(i,j,k)=-u(i,j,k)*((o2(1,j,k)-o2(i-1,j,k))/(2*cos(lat(j))*(pi*re/180)))
else
  zadv(i,j,k)=-u(i,j,k)*((o2(i+1,j,k)-o2(i-1,j,k))/(2*cos(lat(j))*(pi*re/180)))
endif
else
zadv(i,j,k)=undef
endif
ENDDO
ENDDO
ENDDO

DO k=1, lz
DO j=1, ly
DO i=1, lx
if(o2(i,j,k) .ne. undef .and. o2(i,j+1,k) .ne. undef .and. o2(i,j-1,k) .ne. undef) then
if(j==1) then
  madv(i,j,k)=-v(i,j,k)*((o2(i,j+1,k)-o2(i,j,k))/(pi*re/180))
elseif (j==ly) then
  madv(i,j,k)=-v(i,j,k)*((o2(i,j,k)-o2(i,ly-1,k))/(pi*re/180))
else
  madv(i,j,k)=-v(i,j,k)*((o2(i,j-1,k)-o2(i,j+1,k))/(2*pi*re/180))
endif
else
madv(i,j,k)=undef
endif
ENDDO
ENDDO
ENDDO


DO k=1, lz
DO j=1, ly
DO i=1, lx
if(k==lz) then
  wt2(i,j,k)=0.5*(wt(i,j,k)+0)
else
  wt2(i,j,k)=0.5*(wt(i,j,k+1)+wt(i,j,k))
endif

if(k==1) then
  vadv(i,j,k)=-wt2(i,j,k)*((o2(i,j,k+1)-o2(i,j,k))/(lev(k)-lev(k+1)))
elseif(k==lz) then
  vadv(i,j,k)=-wt2(i,j,k)*((o2(i,j,k)-o2(i,j,k-1))/(lev(k-1)-lev(k)))
else
  vadv(i,j,k)=-wt2(i,j,k)*((o2(i,j,k+1)-o2(i,j,k-1))/(lev(k-1)-lev(k+1)))
endif
ENDDO
ENDDO
ENDDO

write(21,rec=it) zadv(:,:,:)
write(22,rec=it) madv(:,:,:)
write(19,rec=it) vadv(:,:,:)

ENDDO
close (21)
close (22)
close (19)

end program budget
