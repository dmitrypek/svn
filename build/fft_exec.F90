! This file is part of P3DFFT library
!
!    P3DFFT
!
!    Software Framework for Scalable Fourier Transforms in Three Dimensions
!
!    Copyright (C) 2006-2014 Dmitry Pekurovsky
!    Copyright (C) 2006-2014 University of California
!    Copyright (C) 2010-2011 Jens Henrik Goebbert
!
!    This program is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    This program is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
!
!----------------------------------------------------------------------------

! This file contains routines for executing pre-initialized 1D FFT operations

      subroutine ftran_y_zplane(In,z_in,xsize_in,zsize_in,stride1_in, &
         stride2_in, Out,z_out,xsize_out,zsize_out,stride1_out,stride2_out, &
         ny,m)

      use p3dfft
      implicit none

      integer xsize_in,zsize_in,xsize_out,zsize_out,stride1_in,stride2_in
      integer stride1_out,stride2_out,ny,m,z_in,z_out
      complex(mytype) In(xsize_in,ny,0:zsize_in-1),Out(xsize_out,ny,0:zsize_out-1)

      call exec_f_c1(In(1,1,z_in),stride1_in,stride2_in,Out(1,1,z_out),stride1_out,stride2_out,ny,m)

      return
      end


      subroutine btran_y_zplane(In,z_in,xsize_in,zsize_in,stride1_in, &
         stride2_in, Out,z_out,xsize_out,zsize_out,stride1_out,stride2_out, &
         ny,m)

      use p3dfft
      implicit none

      integer xsize_in,zsize_in,xsize_out,zsize_out,stride1_in,stride2_in
      integer stride1_out,stride2_out,ny,m,z_in,z_out
      complex(mytype) In(xsize_in,ny,0:zsize_in-1),Out(xsize_out,ny,0:zsize_out-1)

      call exec_b_c1(In(1,1,z_in),stride1_in,stride2_in,Out(1,1,z_out),stride1_out,stride2_out,ny,m)

      return
      end


! Execute backward complex-to-complex 1D FFT

      subroutine exec_b_c1(X,stride_x1,stride_x2,Y,stride_y1, &
          stride_y2,N,m)

      use fft_spec
      use p3dfft
      implicit none

      integer stride_x1,stride_x2,stride_y1,stride_y2,N,m
      complex(mytype) X(N*stride_x1+m*stride_x2),Y(N*stride_y1+m*stride_y2)

#ifdef FFTW
#ifndef SINGLE_PREC
         call dfftw_execute_dft(plan1_bc,X,Y)
#else
         call sfftw_execute_dft(plan1_bc,X,Y)
#endif
#elif defined ESSL

#ifndef SINGLE_PREC
      call dcft (0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,-1,1.0d0, &
              caux1,cnaux,caux2,cnaux)       
#else
      call scft (0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,-1,1.0, &
              caux1,cnaux,caux2,cnaux)       
#endif

#else
      Error: undefined FFT library
#endif
      return
      end

      subroutine exec_b_c2_same(X,stride_x1,stride_x2,Y,stride_y1, &
          stride_y2,N,m)

      use fft_spec
      use p3dfft
      implicit none

      integer stride_x1,stride_x2,stride_y1,stride_y2,N,m
      complex(mytype) X(N*stride_x1+m*stride_x2),Y(N*stride_y1+m*stride_y2)

#ifdef FFTW
#ifndef SINGLE_PREC
         call dfftw_execute_dft(plan2_bc_same,X,Y)
#else
         call sfftw_execute_dft(plan2_bc_same,X,Y)
#endif
#elif defined ESSL

#ifndef SINGLE_PREC
      call dcft (0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,-1,1.0d0, &
              caux1,cnaux,caux2,cnaux)       
#else
      call scft (0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,-1,1.0, &
              caux1,cnaux,caux2,cnaux)       
#endif

#else
      Error: undefined FFT library
#endif
      return
      end

      subroutine exec_b_c2_dif(X,stride_x1,stride_x2,Y,stride_y1, &
          stride_y2,N,m)

      use fft_spec
      use p3dfft
      implicit none

      integer stride_x1,stride_x2,stride_y1,stride_y2,N,m
      complex(mytype) X(N*stride_x1+m*stride_x2),Y(N*stride_y1+m*stride_y2)

#ifdef FFTW
#ifndef SINGLE_PREC
         call dfftw_execute_dft(plan2_bc_dif,X,Y)
#else
         call sfftw_execute_dft(plan2_bc_dif,X,Y)
#endif
#elif defined ESSL

#ifndef SINGLE_PREC
      call dcft (0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,-1,1.0d0, &
              caux1,cnaux,caux2,cnaux)       
#else
      call scft (0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,-1,1.0, &
              caux1,cnaux,caux2,cnaux)       
#endif

#else
      Error: undefined FFT library
#endif
      return
      end

! Execute backward complex-to-real 1D FFT

      subroutine exec_b_c2r(X,dimx,Y,dimy,N,m)

      use fft_spec
      use p3dfft
      implicit none

      integer dimx,dimy,N,m
      complex(mytype) X((N/2+1)*m)
      real(mytype) Y(N*m)

#ifdef FFTW
#ifndef SINGLE_PREC
      call dfftw_execute_dft_c2r(plan1_bcr,X,Y)
#else
      call sfftw_execute_dft_c2r(plan1_bcr,X,Y)
#endif

#elif defined ESSL

#ifndef SINGLE_PREC
      call dcrft(0,X,dimx,Y,dimy,N,m,-1,1.0d0, &
            raux1, rnaux1,raux2,rnaux2,raux3,1)  
#else
      call scrft(0,X,dimx,Y,dimy,N,m,-1,1.0, &
            raux1, rnaux1,raux2,rnaux2,raux3,1)  
#endif
#else
      Error: unknown FFT library
#endif

      return
      end

! Execute forward complex-to-complex 1D FFT

      subroutine exec_f_c1(X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m) 

      use fft_spec
      use p3dfft
      implicit none

      integer N,m,stride_x1,stride_x2,stride_y1,stride_y2
      complex(mytype) X(N*stride_x1+m*stride_x2),Y(N*stride_y1+m*stride_y2)


#ifdef FFTW
#ifndef SINGLE_PREC
      call dfftw_execute_dft(plan1_fc,X,Y)
#else
      call sfftw_execute_dft(plan1_fc,X,Y)
#endif

#elif defined ESSL

#ifndef SINGLE_PREC
      call dcft(0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,1,1.0d0,&
              caux1,cnaux,caux2,cnaux)
#else
      call scft(0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,1,1.0,  &
              caux1,cnaux,caux2,cnaux)
#endif
#else
      Error: undefined FFT library 
#endif

      return
      end

      subroutine exec_f_c2_same(X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m) 

      use fft_spec
      use p3dfft
      implicit none

      integer N,m,stride_x1,stride_x2,stride_y1,stride_y2
      complex(mytype) X(N*stride_x1+m*stride_x2),Y(N*stride_y1+m*stride_y2)

#ifdef FFTW
#ifndef SINGLE_PREC
      call dfftw_execute_dft(plan2_fc_same,X,Y)
#else
      call sfftw_execute_dft(plan2_fc_same,X,Y)
#endif

#elif defined ESSL

#ifndef SINGLE_PREC
      call dcft(0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,1,1.0d0, &
              caux1,cnaux,caux2,cnaux)
#else
      call scft(0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,1,1.0,  &
              caux1,cnaux,caux2,cnaux)
#endif
#else
      Error: undefined FFT library 
#endif

      return
      end

      subroutine exec_f_c2_dif(X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m) 

      use fft_spec
      use p3dfft
      implicit none

      integer N,m,stride_x1,stride_x2,stride_y1,stride_y2
      complex(mytype) X(N*stride_x1+m*stride_x2),Y(N*stride_y1+m*stride_y2)

#ifdef FFTW
#ifndef SINGLE_PREC
      call dfftw_execute_dft(plan2_fc_dif,X,Y)
#else
      call sfftw_execute_dft(plan2_fc_dif,X,Y)
#endif

#elif defined ESSL

#ifndef SINGLE_PREC
      call dcft(0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,1,1.0d0, &
              caux1,cnaux,caux2,cnaux)
#else
      call scft(0,X,stride_x1,stride_x2,Y,stride_y1,stride_y2,N,m,1,1.0,  &
              caux1,cnaux,caux2,cnaux)
#endif
#else
      Error: undefined FFT library 
#endif

      return
      end

! Execute forward real-to-complex 1D FFT

      subroutine exec_f_r2c(X,dimx,Y,dimy,N,m)

      use fft_spec
      use p3dfft

      integer dimx,dimy,N,m
      real(mytype) X(N*m)
      complex(mytype) Y((N/2+1)*m)

#ifdef FFTW

#ifndef SINGLE_PREC
      call dfftw_execute_dft_r2c(plan1_frc,X,Y)
#else
      call sfftw_execute_dft_r2c(plan1_frc,X,Y)
#endif

#elif defined ESSL

#ifndef SINGLE_PREC
      call drcft(0,X,dimx,Y,dimy,N,m,1,1.0d0, &
            raux1, rnaux1,raux2,rnaux2,raux3,1)     
#else
      call srcft(0,X,dimx,Y,dimy,N,m,1,1.0, &
            raux1, rnaux1,raux2,rnaux2,raux3,1)     
#endif
#else
      Error: undefined FFT library
#endif

      return
      end

! --------------------------------------
!
!  exec_ctrans_r2(..)
!  cosinus transform
! --------------------------------------
subroutine exec_ctrans_r2_same (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_ctrans_same, X, Y)
#else
    call sfftw_execute_r2r (plan_ctrans_same, X, Y)
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dcosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call scosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

subroutine exec_ctrans_r2_dif (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_ctrans_dif, X, Y)
#else
    call sfftw_execute_r2r (plan_ctrans_dif, X, Y)
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dcosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call scosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

! --------------------------------------
subroutine exec_ctrans_r2_complex_same (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_ctrans_same, X, Y)
    call dfftw_execute_r2r (plan_ctrans_same, X(2), Y(2))
#else
    call sfftw_execute_r2r (plan_ctrans_same, X, Y)
    call sfftw_execute_r2r (plan_ctrans_same, X(2), Y(2))
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dcosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
    call dcosf (0, X(2), stride_x1, stride_x2, &
                   Y(2), stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call scosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
!    call scosf (0, X(2), stride_x1, stride_x2, &
!                   Y(2), stride_y1, stride_y2, &
!                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

! --------------------------------------
subroutine exec_ctrans_r2_complex_dif (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_ctrans_dif, X, Y)
    call dfftw_execute_r2r (plan_ctrans_dif, X(2), Y(2))
#else
    call sfftw_execute_r2r (plan_ctrans_dif, X, Y)
    call sfftw_execute_r2r (plan_ctrans_dif, X(2), Y(2))
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dcosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
    call dcosf (0, X(2), stride_x1, stride_x2, &
                   Y(2), stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call scosf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
!    call scosf (0, X(2), stride_x1, stride_x2, &
!                   Y(2), stride_y1, stride_y2, &
!                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end


! --------------------------------------
!
!  exec_strans_r2(..)
!  sinus transform
! --------------------------------------
subroutine exec_strans_r2_same (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_strans_same, X, Y)
#else
    call sfftw_execute_r2r (plan_strans_same, X, Y)
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dsinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call ssinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

subroutine exec_strans_r2_dif (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_strans_dif, X, Y)
#else
    call sfftw_execute_r2r (plan_strans_dif, X, Y)
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dsinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call ssinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

! --------------------------------------
subroutine exec_strans_r2_complex_same (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_strans_same, X, Y)
    call dfftw_execute_r2r (plan_strans_same, X(2), Y(2))
#else
    call sfftw_execute_r2r (plan_strans_same, X, Y)
    call sfftw_execute_r2r (plan_strans_same, X(2), Y(2))
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dsinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
    call dsinf (0, X(2), stride_x1, stride_x2, &
                   Y(2), stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call ssinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
    call ssinf (0, X(2), stride_x1, stride_x2, &
                   Y(2), stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

! --------------------------------------
subroutine exec_strans_r2_complex_dif (X, stride_x1, stride_x2, Y, stride_y1, stride_y2, N, m)
    use fft_spec
    use p3dfft
    implicit none
 
    integer :: stride_x1, stride_x2, stride_y1, stride_y2, N, m
    real (mytype) :: X (N*m), Y (N*m)
    integer :: nm2
 
#ifdef FFTW
 
#ifndef SINGLE_PREC
    call dfftw_execute_r2r (plan_strans_dif, X, Y)
    call dfftw_execute_r2r (plan_strans_dif, X(2), Y(2))
#else
    call sfftw_execute_r2r (plan_strans_dif, X, Y)
    call sfftw_execute_r2r (plan_strans_dif, X(2), Y(2))
#endif
#elif defined ESSL
    nm2 = (N-1) * 2
 
#ifndef SINGLE_PREC
    call dsinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
    call dsinf (0, X(2), stride_x1, stride_x2, &
                   Y(2), stride_y1, stride_y2, &
                   nm2, m, 2.0d0, caux1, cnaux, caux2, cnaux)
#else
    call ssinf (0, X, stride_x1, stride_x2, &
                   Y, stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
    call ssinf (0, X(2), stride_x1, stride_x2, &
                   Y(2), stride_y1, stride_y2, &
                   nm2, m, 2.0, caux1, cnaux, caux2, cnaux)
#endif
 
#else
    Error: undefined FFT library
#endif
    return
end

