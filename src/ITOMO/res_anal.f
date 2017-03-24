c***********************************************************************
c* Subroutine RES_ANAL  v2.3  (03/26/2003)
c* Purposes: Program produces resolution analysis
c*           for all points in the area of investigation
c* INPUT:    nmm=nm      - matrices dimensions
c*           xk1, xk2    - arrays, (nmm), contain local grid coordinates
c*           res         - Resolution matrix, (nmm,nmm)
c***********************************************************************
      SUBROUTINE RES_ANAL(nmm,xk1,yk1,res)
      IMPLICIT NONE
      include "tomo.h"
      include "line.h"
      integer*4 nmm
      real*8    xk1(nmm),yk1(nmm)
      real*8    xk,yk
      real*4    d_val(12)
      real*4    res(nmm,nmm)
      real*4    amp,tresh,s,s1,zmax
      integer*4 i,i1,imax,ierr,inarg,j,j1,k,l,lll,nlidd,n1,n2
      integer*4 lidd(NRAZ)
      real*4 sn1(NRAZ),sn2(NRAZ)
      real*4 ff(NRAZ),ff_comm(NRAZ),ff_mat(NRAZ)
      real*4 sig1(NRAZ),sig2(NRAZ),amp1(NRAZ)
c
c  Parameters
c
      inarg=0
      amp=1.0
      tresh=2000.0
      do i=1,nm
        ff_comm(i)=0.0
        sig1(i)=tresh
        sig2(i)=tresh
        amp1(i)=0.0
        sn1(i)=0.0
        sn2(i)=0.0
      enddo
c
c  Create inp/outp Gaussians.  Main LOOP by l
c
      do l=1,nm
        s=res(1,l)
        s1=0.0
        imax=1
        do i=1,nm
          ff(i)=0.0
          if(i.eq.l) ff(i)=1.0
          ff_mat(i)=res(i,l)*amp
          s1=s1+ff_mat(i)
          if(ff_mat(i).gt.s) then
            s=ff_mat(i)
            imax=i
          endif
        enddo
c
c  Check for maximum. If inarg == 1 print debug info.
c
        if(imax.ne.l) then
          if(inarg.eq.1) 
     +      write(*,'("ATTN l=",i5,2f8.2," imax=",i5,2f8.2,f9.5)') 
     +              l,xk1(l),yk1(l),imax,xk1(imax),yk1(imax),s
            endif
c
c  Build cone with radius sig1(l) and Gaussian shape with sig2(l)
c
        sig1(l) = -1.0
        sig2(l) = -1.0
        CALL RES_TRIA(lidd,nlidd,l,nm,ff_mat,amp1(l),sig1(l),sig2(l),n1,n2,
     +  tresh,ierr)
        sn1(l)=n1
        sn2(l)=n2
c
c  convert sig1(l) from degrre to km
c
        sig1(l)=sig1(l)*const*R
c
c  Added the next line at 08/13/99 - minimal sigma=2* cellsize
c
        if(sig2(l).lt.SNGL(dlincell)/2.0.and.sig2(l).gt.0.0) sig2(l)=SNGL(dlincell)/2.0
c
c  convert sig2(l) from degree to km
c
        sig2(l)=sig2(l)*const*R
c
c Cut sig1 & sig2 to range 50 - tresh km. tresh=4000 km
c
        if(sig1(l).lt.0.0.or.sig1(l).gt.tresh) sig1(l)=tresh
        if(sig2(l).lt.0.0.or.sig2(l).gt.tresh) sig2(l)=tresh
c
      enddo
c
c  End Main Loop by l
c  Output results in file xxx.rea
c
      do 120 k=1,nlat
      xk=ATAN(GEO*TAN((dlat0+(k-1)*s_lat)*const))
      xk=pi/2.0-xk
      do 120 j=1,nlon
      yk=(dlon0+(j-1)*s_lon)*const
      CALL EINTPOL (xk,yk,nm,sig1, d_val(1),ierr)
      if(ierr.eq.1) goto 120
      CALL EINTPOL (xk,yk,nm,sig2, d_val(2),ierr)
      if(ierr.eq.1) goto 120
      CALL EINTPOL (xk,yk,nm,amp1, d_val(3),ierr)
      if(ierr.eq.1) goto 120
      CALL EINTPOL (xk,yk,nm,sn1, d_val(4),ierr)
      if(ierr.eq.1) goto 120
      CALL EINTPOL (xk,yk,nm,sn2,d_val(5),ierr)
      if(ierr.eq.1) goto 120
      write(22,1005)dlon0+(j-1)*s_lon,dlat0+(k-1)*s_lat,
     *(d_val(lll),lll=1,5)
 1005 format(2f12.3,2f9.2,f9.5,3f7.1)
 120  continue
      close(22)
c
c  Compute assimmetry of resolution matrix
c
      zmax=-10000000.
      s1=0.0
      do i=1,nm
        do j=i,nm
          s=ABS(res(i,j)-res(j,i))
          s1=s1+s*s
          if(s.gt.zmax) then
            zmax=s
            i1=i
            j1=j
          endif
        enddo
      enddo
      write(*,*) "Matrix elements=", nm*nm,
     +", Maximal deviation =", SQRT(s1/FLOAT(nm*nm-1))
      write(8,*) "Matrix elements=", nm*nm,
     +", Maximal deviation =", SQRT(s1/FLOAT(nm*nm-1))
      return
      end
