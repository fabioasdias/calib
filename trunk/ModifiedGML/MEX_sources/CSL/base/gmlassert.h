#ifndef __GMLASSERT_H__
#define __GMLASSERT_H__
//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlassert.h,v 1.2 2005/02/11 09:12:16 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#include "gmlcommon.h"

#if defined(_DEBUG)
    #undef  ASSERT
		#define ASSERT(exp) do { if (!(exp) && _assert_ex(#exp, __FILE__, __LINE__, "assertion failed")) {__asm{int 3}} } while (0)
		#define ASSERT_ex(exp, info) do { if (!(exp) && _assert_ex(#exp, __FILE__, __LINE__, info)) {__asm{int 3}} } while (0)
		#define ASSERT_trace1(exp, format, parameter1) do { if (!(exp) && _assert_trace(#exp, __FILE__, __LINE__, format, parameter1)) {__asm{int 3}} } while (0)
		#define ASSERT_trace2(exp, format, parameter1, parameter2) do { if (!(exp) && _assert_trace(#exp, __FILE__, __LINE__, format, parameter1, parameter2)) {__asm{int 3}} } while (0)
		#define ASSERT_trace3(exp, format, parameter1, parameter2, parameter3) do { if (!(exp) && _assert_trace(#exp, __FILE__, __LINE__, format, parameter1, parameter2, parameter3)) {__asm{int 3}} } while (0)
#else
    #undef  ASSERT
	  #define ASSERT(exp)	((void)0)
  	#define ASSERT_ex(exp, info)	((void)0)
  	#define ASSERT_trace1(exp, format, parameter1)	((void)0)
	  #define ASSERT_trace2(exp, format, parameter1, parameter2)	((void)0)
	  #define ASSERT_trace3(exp, format, parameter1, parameter2, parameter3)	((void)0)
#endif

bool _assert_ex(char* in_Expression, char* in_FileName, int in_iLine, 
								char* in_Info);
bool _assert_trace(char* in_Expression, char* in_FileName, int in_iLine, char* in_Format, ...);

#endif //__GMLASSERT_H__