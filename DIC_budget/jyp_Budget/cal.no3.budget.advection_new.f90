program budget

IMPLICIT NONE

INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=6000, nt=6000
!INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=120, nt=6000

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
REAL                  :: no3(lx,ly,lz), no3t(lx,ly,lz)
REAL                  :: u(lx,ly,lz), zadv(lx,ly,lz)
REAL                  :: v(lx,ly,lz), madv(lx,ly,lz)
REAL                  :: wt(lx,ly,lz), wt2(lx,ly,lz), vadv(lx,ly,lz)
REAL                  :: mzadv(lx,ly,lz), mmadv(lx,ly,lz),mvadv(lx,ly,lz)
REAL                  :: lat(ly)
REAL                  :: lev(lz)

INTEGER               :: i, j, k, it
DATA   lev /5316.43, 4950.41, 4587.74, 4230.62, 3881.16, 3541.39, 3213.21, 2898.37, 2598.46, 2314.88, 2048.83, 1801.28, 1572.97, 1364.41, 1175.83, 1007.26, 858.422, 728.828, 617.736, 524.171, 446.937, 384.634, 335.676, 298.305, 270.621, 250.6, 236.123, 225, 215, 205, 195, 185, 175, 165, 155, 145, 135, 125, 115, 105, 95, 85, 75, 65, 55, 45, 35, 25, 15, 5/

!OPEN (1, file='/net2/jyp/Analysis_Cobalt/Data/fed.1001-1500.gdat',form='unformatted',access='stream', status='old')
!OPEN (2, file='/net2/jyp/Analysis_Cobalt/Data/u.1001-1500.gdat',form='unformatted',access='stream', status='old')
!OPEN (3, file='/net2/jyp/Analysis_Cobalt/Data/v.1001-1500.gdat',form='unformatted',access='stream', status='old')
!OPEN (4, file='/net2/jyp/Analysis_Cobalt/Data/wt.1001-1500.gdat',form='unformatted',access='stream', status='old')
OPEN (1, file='/net2/jyp/Analysis_Cobalt/Data/fed.1001-1500.gdat',form='unformatted',access='direct', recl=lx*ly*lz*4,status='old')
OPEN (2, file='/net2/jyp/Analysis_Cobalt/Data/u.1001-1500.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')
OPEN (3, file='/net2/jyp/Analysis_Cobalt/Data/v.1001-1500.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')
OPEN (4, file='/net2/jyp/Analysis_Cobalt/Data/wt.1001-1500.gdat',form='unformatted',access='direct',recl=lx*ly*lz*4, status='old')

!open (21, file='zadv.1001-1500a.gdat', form='unformatted', status='unknown')
!open (22, file='madv.1001-1500a.gdat', form='unformatted', status='unknown')
!open (19, file='vadv.1001-1500a.gdat', form='unformatted', status='unknown')
open (21, file='zadv.1001-1500b.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')
open (22, file='madv.1001-1500b.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')
open (19, file='vadv.1001-1500b.gdat', form='unformatted', access='direct',recl=lx*ly*lz*4, status='unknown')

DO it=1, lt
read(1,rec=it) no3t(:,:,:)
read(2,rec=it) u(:,:,:)
read(3,rec=it) v(:,:,:)
read(4,rec=it) wt(:,:,:)

no3(:,:,:)=no3t(:,:,:)*1e9

do j=1, ly
lat(j)=(j-90.5)*(pi/180)
!print*, cos(lat(j))
enddo

DO k=1, lz
DO j=1, ly
DO i=1, lx
if(no3(i,j,k) .ne. undef .and. no3(i+1,j,k) .ne. undef .and. no3(i-1,j,k) .ne. undef) then
if(i==1) then
  zadv(i,j,k)=-u(i,j,k)*((no3(i+1,j,k)-no3(lx,j,k))/(2*cos(lat(j))*(pi*re/180)))
elseif (i==lx) then
  zadv(i,j,k)=-u(i,j,k)*((no3(1,j,k)-no3(i-1,j,k))/(2*cos(lat(j))*(pi*re/180)))
else
  zadv(i,j,k)=-u(i,j,k)*((no3(i+1,j,k)-no3(i-1,j,k))/(2*cos(lat(j))*(pi*re/180)))
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
if(no3(i,j,k) .ne. undef .and. no3(i,j+1,k) .ne. undef .and. no3(i,j-1,k) .ne. undef) then
if(j==1) then
  madv(i,j,k)=-v(i,j,k)*((no3(i,j+1,k)-no3(i,j,k))/(pi*re/180))
elseif (j==ly) then
  madv(i,j,k)=-v(i,j,k)*((no3(i,j,k)-no3(i,ly-1,k))/(pi*re/180))
else
  madv(i,j,k)=-v(i,j,k)*((no3(i,j-1,k)-no3(i,j+1,k))/(2*pi*re/180))
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

!where(COUNT(no3(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
if(k==1) then
!  vadv(:,:,k,:)=-wt2(:,:,k,:)*((no3(:,:,k+1,:)-no3(:,:,k,:))/(lev(k)-lev(k+1)))
  vadv(i,j,k)=-wt2(i,j,k)*((no3(i,j,k+1)-no3(i,j,k))/(lev(k)-lev(k+1)))
elseif(k==lz) then
!  vadv(:,:,k,:)=-wt2(:,:,k,:)*((no3(:,:,k,:)-no3(:,:,k-1,:))/(lev(k-1)-lev(k)))
  vadv(i,j,k)=-wt2(i,j,k)*((no3(i,j,k)-no3(i,j,k-1))/(lev(k-1)-lev(k)))
else
!  vadv(:,:,k,:)=-wt2(:,:,k,:)*((no3(:,:,k+1,:)-no3(:,:,k-1,:))/(lev(k-1)-lev(k+1)))
  vadv(i,j,k)=-wt2(i,j,k)*((no3(i,j,k+1)-no3(i,j,k-1))/(lev(k-1)-lev(k+1)))
endif
!elsewhere
!vadv(:,:,k,:)=undef
!endwhere
ENDDO
ENDDO
ENDDO

!where(COUNT(zadv(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
!mzadv(:,:,:)=SUM(zadv(:,:,:,:), DIM=4) / COUNT(zadv(:,:,:,:) .ne. undef, DIM=4)
!elsewhere
!mzadv(:,:,:)=undef
!endwhere

!where(COUNT(madv(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
!mmadv(:,:,:)=SUM(madv(:,:,:,:), DIM=4) / COUNT(madv(:,:,:,:) .ne. undef, DIM=4)
!elsewhere
!mmadv(:,:,:)=undef
!endwhere

!where(COUNT(vadv(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
!mvadv(:,:,:)=SUM(vadv(:,:,:,:), DIM=4) / COUNT(vadv(:,:,:,:) .ne. undef, DIM=4)
!elsewhere
!mvadv(:,:,:)=undef
!endwhere

write(21,rec=it) zadv(:,:,:)

write(22,rec=it) madv(:,:,:)
!close (22)

write(19,rec=it) vadv(:,:,:)
!close (19)

ENDDO
close (21)
close (22)
close (19)

end program budget
