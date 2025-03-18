program budget

IMPLICIT NONE

!INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=6000, nt=6000
INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=1200, nt=1200

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
!REAL                  :: no3a(lx,ly,lz,nt),ua(lx,ly,lz,nt),va(lx,ly,lz,nt),wta(lx,ly,lz,nt)
REAL                  :: no3(lx,ly,lz,lt)
REAL                  :: u(lx,ly,lz,lt), zadv(lx,ly,lz,lt)
REAL                  :: v(lx,ly,lz,lt), madv(lx,ly,lz,lt)
REAL                  :: wt(lx,ly,lz,lt), wt2(lx,ly,lz,lt), vadv(lx,ly,lz,lt)
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


DO it=1, lt
!read(1) no3a(:,:,:,:)
!read(2) ua(:,:,:,:)
!read(3) va(:,:,:,:)
!read(4) wta(:,:,:,:)
read(1,rec=it+4800) no3(:,:,:,it)
read(2,rec=it+4800) u(:,:,:,it)
read(3,rec=it+4800) v(:,:,:,it)
read(4,rec=it+4800) wt(:,:,:,it)
enddo

!no3(:,:,:,:)=no3a(:,:,:,1:lt)
!u(:,:,:,:)=ua(:,:,:,1:lt)
!v(:,:,:,:)=va(:,:,:,1:lt)
!wt(:,:,:,:)=wta(:,:,:,1:lt)

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
  zadv(i,j,k,it)=-u(i,j,k,it)*((no3(i+1,j,k,it)-no3(lx,j,k,it))/(2*cos(lat(j))*(pi*re/180)))
elseif (i==lx) then
  zadv(i,j,k,it)=-u(i,j,k,it)*((no3(1,j,k,it)-no3(i-1,j,k,it))/(2*cos(lat(j))*(pi*re/180)))
else
  zadv(i,j,k,it)=-u(i,j,k,it)*((no3(i+1,j,k,it)-no3(i-1,j,k,it))/(2*cos(lat(j))*(pi*re/180)))
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
  madv(i,j,k,it)=-v(i,j,k,it)*((no3(i,j+1,k,it)-no3(i,j,k,it))/(pi*re/180))
elseif (j==ly) then
  madv(i,j,k,it)=-v(i,j,k,it)*((no3(i,j,k,it)-no3(i,ly-1,k,it))/(pi*re/180))
else
  madv(i,j,k,it)=-v(i,j,k,it)*((no3(i,j-1,k,it)-no3(i,j+1,k,it))/(2*pi*re/180))
endif
else
madv(i,j,k,it)=undef
endif
ENDDO
ENDDO
ENDDO
ENDDO


DO it=1, lt
DO k=1, lz
DO j=1, ly
DO i=1, lx
if(k==lz) then
  wt2(i,j,k,it)=0.5*(wt(i,j,k,it)+0)
else
  wt2(i,j,k,it)=0.5*(wt(i,j,k+1,it)+wt(i,j,k,it))
endif

!where(COUNT(no3(:,:,:,:) .ne. undef, DIM=4) .ne. 0)
if(k==1) then
!  vadv(:,:,k,:)=-wt2(:,:,k,:)*((no3(:,:,k+1,:)-no3(:,:,k,:))/(lev(k)-lev(k+1)))
  vadv(i,j,k,it)=-wt2(i,j,k,it)*((no3(i,j,k+1,it)-no3(i,j,k,it))/(lev(k)-lev(k+1)))
elseif(k==lz) then
!  vadv(:,:,k,:)=-wt2(:,:,k,:)*((no3(:,:,k,:)-no3(:,:,k-1,:))/(lev(k-1)-lev(k)))
  vadv(i,j,k,it)=-wt2(i,j,k,it)*((no3(i,j,k,it)-no3(i,j,k-1,it))/(lev(k-1)-lev(k)))
else
!  vadv(:,:,k,:)=-wt2(:,:,k,:)*((no3(:,:,k+1,:)-no3(:,:,k-1,:))/(lev(k-1)-lev(k+1)))
  vadv(i,j,k,it)=-wt2(i,j,k,it)*((no3(i,j,k+1,it)-no3(i,j,k-1,it))/(lev(k-1)-lev(k+1)))
endif
!elsewhere
!vadv(:,:,k,:)=undef
!endwhere
ENDDO
ENDDO
ENDDO
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

open (21, file='zadv.1001-1500.gdat', form='unformatted', status='unknown')
write(21) zadv(:,:,:,1:lt)
close (21)

open (22, file='madv.1001-1500.gdat', form='unformatted', status='unknown')
write(22) madv(:,:,:,1:lt)
close (22)

open (19, file='vadv.1001-1500.gdat', form='unformatted', status='unknown')
write(19) vadv(:,:,:,1:lt)
close (19)


end program budget
