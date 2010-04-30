/*
! This file is part of P3DFFT library
!
! Version 2.3
!
! Copyright (C) 2006-2008 Dmitry Pekurovsky
!
!    P3DFFT is free software; you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation; either version 2 of the License, or
!    (at your option) any later version.

!    This program is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.

!    You should have received a copy of the GNU General Public License
!    along with this program; if not, write to the Free Software
!    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

!----------------------------------------------------------------------------
*/

#include <stdlib.h>

#ifdef IBM

#define FORT_MOD_NAME(NAME) __p3dfft_NMOD_##NAME
#define FORTNAME(NAME) NAME

#elif defined PGI

#define FORT_MOD_NAME(NAME) p3dfft_##NAME##_
#define FORTNAME(NAME) NAME##_

#elif defined GCC

#define FORT_MOD_NAME(NAME) __p3dfft__##NAME
#define FORTNAME(NAME) NAME##_

#else

#define FORT_MOD_NAME(NAME) p3dfft_mp_##NAME##_
#define FORTNAME(NAME) NAME##_

#endif

extern void FORT_MOD_NAME(p3dfft_setup)(int *dims,int *nx,int *ny,int *nz, int *ow);
extern void FORT_MOD_NAME(get_dims)(int *,int *,int *,int *);

#ifndef SINGLE_PREC
extern void FORT_MOD_NAME(p3dfft_ftran_r2c)(double *A,double *B);
extern void FORT_MOD_NAME(p3dfft_btran_c2r)(double *A,double *B);
#else
extern void FORT_MOD_NAME(p3dfft_ftran_r2c)(float *A,float *B);
extern void FORT_MOD_NAME(p3dfft_btran_c2r)(float *A,float *B);
#endif

extern void FORT_MOD_NAME(p3dfft_clean)();
extern void FORTNAME(abort)();

extern void p3dfft_setup(int *dims,int nx,int ny,int nz,int ovewrite);
extern void get_dims(int *,int *,int *,int );

#ifndef SINGLE_PREC
extern void p3dfft_ftran_r2c(double *A,double *B);
extern void p3dfft_btran_c2r(double *A,double *B);
#else
extern void p3dfft_ftran_r2c(float *A,float *B);
extern void p3dfft_btran_c2r(float *A,float *B);
#endif

extern void p3dfft_clean();

void p3dfft_setup(int *dims,int nx,int ny,int nz, int overwrite)
{
  FORT_MOD_NAME(p3dfft_setup)(dims,&nx,&ny,&nz,&overwrite);
}

void get_dims(int *start,int *end,int *size,int conf)
{
  FORT_MOD_NAME(get_dims)(start,end,size,&conf);
}

#ifndef SINGLE_PREC
void p3dfft_ftran_r2c(double *A,double *B)
{
  FORT_MOD_NAME(p3dfft_ftran_r2c)(A,B);
}
#else
void p3dfft_ftran_r2c(float *A,float *B)
{
  FORT_MOD_NAME(p3dfft_ftran_r2c)(A,B);
}

#endif

#ifndef SINGLE_PREC
void p3dfft_btran_c2r(double *A,double *B)
{
  FORT_MOD_NAME(p3dfft_btran_c2r)(A,B);
}
#else
void p3dfft_btran_c2r(float *A,float *B)
{
  FORT_MOD_NAME(p3dfft_btran_c2r)(A,B);
}
#endif

void p3dfft_clean()
{
  FORT_MOD_NAME(p3dfft_clean)();
}

void FORTNAME(abort)() 
{
  abort();
}