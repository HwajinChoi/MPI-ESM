program budget

IMPLICIT NONE

INTEGER, PARAMETER    :: lx=360, ly=180, lz=50, lt=6000, nt=6000

REAL, PARAMETER       :: pi=3.141592, re=6370000, undef=-9.99e8
REAL                  :: no3(lx,ly,lz),no3a(lx,ly,lz),no3aa(lx,ly,lz)
REAL                  :: ten(lx,ly,lz)
REAL                  :: lat(ly)
REAL                  :: lev(lz)

INTEGER               :: i, j, k, it
DATA   lev /5316.43, 4950.41, 4587.74, 4230.62, 3881.16, 3541.39, 3213.21, 2898.37, 2598.46, 2314.88, 2048.83, 1801.28, 1572.97, 1364.41, 1175.83, 1007.26, 858.422, 728.828, 617.736, 524.171, 446.937, 384.634, 335.676, 298.305, 270.621, 250.6, 236.123, 225, 215, 205, 195, 185, 175, 165, 155, 145, 135, 125, 115, 105, 95, 85, 75, 65, 55, 45, 35, 25, 15, 5/

OPEN (1, file='/net2/jyp/Analysis_Cobalt/Data/fed.1001-1500.gdat',form='unformatted',access='direct', recl=lx*ly*lz*4,status='old')

open (21, file='fedten.1001-1500b.gdat', form='unformatted', access='direct', recl=lx*ly*lz*4, status='unknown')

DO it=1, lt
if(it==lt) then
read(1,rec=it-1) no3a(:,:,:)
read(1,rec=it) no3aa(:,:,:)
elseif(it==1) then
read(1,rec=it) no3a(:,:,:)
read(1,rec=it+1) no3aa(:,:,:)
else
read(1,rec=it-1) no3a(:,:,:)
read(1,rec=it) no3(:,:,:)
read(1,rec=it+1) no3aa(:,:,:)
endif

do j=1, ly
lat(j)=(j-90.5)*(pi/180)
!print*, cos(lat(j))
enddo

DO k=1, lz
DO j=1, ly
DO i=1, lx
!print*, k,j,i,"32232"
if(no3a(i,j,k) .ne. undef) then

if(it==lt) then
ten(i,j,k)=(no3aa(i,j,k)-no3a(i,j,k))/(86400*30.5)
elseif(it==1) then
ten(i,j,k)=(no3aa(i,j,k)-no3a(i,j,k))/(86400*30.5)
else
ten(i,j,k)=(no3aa(i,j,k)-no3a(i,j,k))/(86400*61)
endif

else 
ten(i,j,k)=undef 
endif
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

write(21,rec=it) ten(:,:,:)

ENDDO
close (21)

end program budget
