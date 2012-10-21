//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlsmartobject.cpp,v 1.2 2004/06/15 15:29:14 ktosh Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

// gml includes
#include "gmlcommon.h"
#include "gmlsmartobject.h"

// windows includes
#include <windows.h>

using namespace gml;

#ifdef GML_THREAD_SAFE

//////////////////////////////////////////////////////////////////////////////
///
void SmartObject::AddRef() const 
  {
  ::InterlockedIncrement(&m_ref_count);
  }

//////////////////////////////////////////////////////////////////////////////
///
void SmartObject::Release() const
  {
  // should not be called neighter on deleted objects, nor in objects
  // without smart references
  ASSERT(m_ref_count > 0);  
  ::InterlockedDecrement(&m_ref_count);
  if (m_ref_count == 0)
    delete this;
  }

#endif

