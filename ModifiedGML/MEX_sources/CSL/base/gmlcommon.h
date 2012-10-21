//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlcommon.h,v 1.19 2004/11/06 17:37:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLCOMMON_H_INCLUDED 
#define _GMLCOMMON_H_INCLUDED 

/** @file gmlcommon.h
 *  @brief General routines like ASSERT etc.
 */

#include <assert.h>

#ifdef _MSC_VER
// disable warning C4786: symbol greater than 255 character,
// disable warning C4386: identifier was truncated to '255' characters in the debug information
// okay to ignore
#pragma warning(disable : 4786 4386 4018)

#endif

/// custom assertion (DEBUG mode only)

#ifdef _DEBUG
#ifndef ASSERT
#define ASSERT(expr) assert(expr);
#endif
#define VERIFY(f)    ASSERT(f)
#else
#ifndef ASSERT
#define ASSERT(expr)
#define ASSERT_ex(expr)
#endif
#ifndef VERIFY
#define VERIFY(f)    ((void)(f))
#endif
#endif

#define NULL 0

typedef unsigned char BYTE;
typedef unsigned short WORD;
typedef unsigned long DWORD;

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

// For windows.h not to define min and max macros
#define NOMINMAX

namespace gml
{
  /** @addtogroup Base
   *  @{
   */


  /* @} */
}



#endif