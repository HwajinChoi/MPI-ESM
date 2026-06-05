program budget

IMPLICIT NONE

INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=240

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
REAL                  :: no3(lx,ly,lz,lt)
REAL                  :: u(lx,ly,lz,lt), zadv(lx,ly,lz,lt)
REAL                  :: v(lx,ly,lz,lt), madv(lx,ly,lz,lt)
REAL                  :: wt(lx,ly,lz,lt), wt2(lx,ly,lz,lt), vadv(lx,ly,lz,lt)
REAL                  :: diff(lx,ly,lz,lt)
REAL                  :: mzadv(lx,ly,lz), mmadv(lx,ly,lz),mvadv(lx,ly,lz)
REAL                  :: lat(ly)
REAL                  :: lev(lz)

INTEGER               :: i, j, k, it
DATA   lev /5316.43, 4950.41, 4587.74, 4230.62, 3881.16, 3541.39, 3213.21, 2898.37, 2598.46, 2314.88, 2048.83, 1801.28, 1572.97, 1364.41, 1175.83, 1007.26, 858.422, 728.828, 617.736, 524.171, 446.937, 384.634, 335.676, 298.305, 270.621, 250.6, 236.123, 225, 215, 205, 195, 185, 175, 165, 155, 145, 135, 125, 115, 105, 95, 85, 75, 65, 55, 45, 35, 25, 15, 5/

!OPEN (1, file='/net2/jyp/MOM5_SIS_COBALT/no3.1962-2007.core.gdat',form='unformatted',access='stream', status='old')
!OPEN (2, file='/net2/jyp/MOM5_SIS_COBALT/u.1962-2007.core.gdat',form='unformatted',access='stream', status='old')
!OPEN (3, file='/net2/jyp/MOM5_SIS_COBALT/v.1962-2007.core.gdat',form='unformatted',access='stream', status='old')
!OPEN (4, file='/net2/jyp/MOM5_SIS_COBALT/wt.1962-2007.core.gdat',form='unformatted',access='stream', status='old')
!OPEN (5, file='/net2/jyp/MOM5_SIS_COBALT/diff_cbt_t.1962-2007.core.gdat',form='unformatted',access='stream', status='old')
OPEN (1, file='/net2/jyp/MOM5_SIS_COBALT/no3.1962-2007.3Drelax.5dy.gdat',form='unformatted',access='stream', status='old')
OPEN (2, file='/net2/jyp/MOM5_SIS_COBALT/u.1962-2007.3Drelax.5dy.gdat',form='unformatted',access='stream', status='old')
OPEN (3, file='/net2/jyp/MOM5_SIS_COBALT/v.1962-2007.3Drelax.5dy.gdat',form='unformatted',access='stream', status='old')
OPEN (4, file='/net2/jyp/MOM5_SIS_COBALT/wt.1962-2007.3Drelax.5dy.gdat',form='unformatted',access='stream', status='old')
OPEN (5, file='/net2/jyp/MOM5_SIS_COBALT/diff_cbt_t.1962-2007.3Drelax.5dy.gdat',form='unformatted',access='stream', status='old')

!OPEN (1, file='/net2/jyp/MOM5_SIS_COBALT/no3.1962-2007.core.gdat',form='unformatted',access='direct', recl=lx*ly*4, status='old')
!OPEN (2, file='/net2/jyp/MOM5_SIS_COBALT/u.1962-2007.core.gdat',form='unformatted',access='direct', recl=lx*ly*lz*lt*4, status='old')
!OPEN (3, file='/net2/jyp/MOM5_SIS_COBALT/v.1962-2007.core.gdat',form='unformatted',access='direct', recl=lx*ly*lz*lt*4, status='old')
!OPEN (4, file='/net2/jyp/MOM5_SIS_COBALT/wt.1962-2007.core.gdat',form='unformatted',access='direct', recl=lx*ly*lz*lt*4, status='old')

!DO it=1, lt
read(1) no3(:,:,:,:)
read(2) u(:,:,:,:)
read(3) v(:,:,:,:)
read(4) wt(:,:,:,:)
read(5) diff(:,:,:,:)
!enddo

do j=1, ly
lat(j)=(j-90.5)*(pi/180)
!print*, cos(lat(j))
enddo

DO it=1, lt
DO k=1, lz
DO j=1, ly
DO i=1, lx
if(no3(i,j,k,it) .ne. undef .and. no3(i+1,j,k,it) .ne. undef .and. no3(i-1,j,k,it) .ne. undef) then
if(i==1) then
  zadv(i,j,k,it)=diff(i,j,k,it)*((no3(i+1,j,k,it)-2*no3(i,j,k,it)+no3(lx,j,k,it))/((cos(lat(j))*(pi*re/180))**2))
elseif (i==lx) then
  zadv(i,j,k,it)=diff(i,j,k,it)*((no3(1,j,k,it)-2*no3(i,j,k,it)+no3(i-1,j,k,it))/((cos(lat(j))*(pi*re/180))**2))
else
  zadv(i,j,k,it)=diff(i,j,k,it)*((no3(i+1,j,k,it)-2*no3(i,j,k,it)+no3(i-1,j,k,it))/((cos(lat(j))*(pi*re/180))**2))
endif
else
zadv(i,j,k,it)=undef
endif
ENDDO
ENDDO
ENDDO
ENDDO

DO it=1, lt
DO k=1, lz
DO j=1, ly
DO i=1, lx
if(no3(i,j,k,it) .ne. undef .and. no3(i,j+1,k,it) .ne. undef .and. no3(i,j-1,k,it) .ne. undef) then
if(j==1) then
  madv(i,j,k,it)=diff(i,j,k,it)*((no3(i,j+2,k,it)-2*no3(i,j+1,k,it)+no3(i,j,k,it))/((pi*re/180)**2))
elseif (j==ly) then
  madv(i,j,k,it)=diff(i,j,k,it)*((no3(i,j,k,it)-2*no3(i,j-1,k,it)+no3(i,j-2,k,it))/((pi*re/180)**2))
else
  madv(i,j,k,it)=diff(i,j,k,it)*((no3(i,j+1,k,it)-2*no3(i,j,k,it)+no3(i,j-1,k,it))/((pi*re/180)**2))
endif
else
madv(i,j,k,it)=undef
endif
ENDDO
ENDDO
ENDDO
ENDDO


DO k=1, lz
if(k==lz) then
  wt2(:,:,k,:)=0.5*(wt(:,:,k,:)+0)
else
  wt2(:,:,k,:)=0.5*(wt(:,:,k+1,:)+wt(:,:,k,:))
endif

!where(COUNT(no3(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
if(k==1) then
  vadv(:,:,k,:)=diff(:,:,k,:)*((no3(:,:,k+2,:)-2*no3(:,:,k+1,:)+no3(:,:,k,:))/((lev(k)-lev(k+1))*(lev(k+1)-lev(k+2))))
elseif(k==lz) then
  vadv(:,:,k,:)=diff(:,:,k,:)*((no3(:,:,k,:)-2*no3(:,:,k-1,:)+no3(:,:,k-2,:))/((lev(k-2)-lev(k-1))*(lev(k-1)-lev(k))))
else
  vadv(:,:,k,:)=diff(:,:,k,:)*((no3(:,:,k+1,:)-2*no3(:,:,k,:)+no3(:,:,k-1,:))/((lev(k-1)-lev(k))*(lev(k)-lev(k+1))))
endif
!elsewhere
!vadv(:,:,k,:)=undef
!endwhere
ENDDO

where(COUNT(zadv(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
mzadv(:,:,:)=SUM(zadv(:,:,:,:), DIM=4) / COUNT(zadv(:,:,:,:) .ne. undef, DIM=4)
elsewhere
mzadv(:,:,:)=undef
endwhere

where(COUNT(madv(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
mmadv(:,:,:)=SUM(madv(:,:,:,:), DIM=4) / COUNT(madv(:,:,:,:) .ne. undef, DIM=4)
elsewhere
mmadv(:,:,:)=undef
endwhere

where(COUNT(vadv(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
mvadv(:,:,:)=SUM(vadv(:,:,:,:), DIM=4) / COUNT(vadv(:,:,:,:) .ne. undef, DIM=4)
elsewhere
mvadv(:,:,:)=undef
endwhere

!open (11, file='zdif.core.gdat', form='unformatted', status='unknown')
open (11, file='zdif.core.3Drelax.5dy.gdat', form='unformatted', status='unknown')
write(11) mzadv
close (11)
!open (12, file='mdif.core.gdat', form='unformatted', status='unknown')
open (12, file='mdif.core.3Drelax.5dy.gdat', form='unformatted', status='unknown')
write(12) mmadv
close (12)
!open (13, file='vdif.core.gdat', form='unformatted', status='unknown')
open (13, file='vdif.core.3Drelax.5dy.gdat', form='unformatted', status='unknown')
write(13) mvadv
close (13)

end program budget
