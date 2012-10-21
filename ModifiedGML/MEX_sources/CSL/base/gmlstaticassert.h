#ifndef __GMLSTATICASSERT_H__
#define __GMLSTATICASSERT_H__
//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlstaticassert.h,v 1.1 2004/06/22 15:05:37 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

// HP aCC cannot deal with missing names for template value parameters
template <bool x> struct STATIC_ASSERTION_FAILURE;
template <> struct STATIC_ASSERTION_FAILURE<true> { enum { value = 1 }; };
// HP aCC cannot deal with missing names for template value parameters
template<int x> struct static_assert_test{};

#define GML_STATIC_ASSERT( B ) \
   enum { gml_static_assert_enum_##__LINE__ \
      = sizeof(STATIC_ASSERTION_FAILURE< (bool)( B ) >) }

#endif