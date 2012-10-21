//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlsmartobject_ts.cpp,v 1.1 2004/08/02 12:00:20 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

// gml includes
#include "gmlcommon.h"
#include "gmlsmartobject_ts.h"

// windows includes
#include <windows.h>

using namespace gml;

//////////////////////////////////////////////////////////////////////////////
///
SmartObjectTS::SmartObjectTS()
 : m_ref_count(0)
{
}

//////////////////////////////////////////////////////////////////////////////
///
SmartObjectTS::SmartObjectTS(const SmartObjectTS& rhs)
 : m_ref_count(0)
 {
 }

//////////////////////////////////////////////////////////////////////////////
///
void SmartObjectTS::AddRef() const
  {
  InterlockedIncrement(&m_ref_count);
  }

//////////////////////////////////////////////////////////////////////////////
///
SmartObjectTS::~SmartObjectTS()
{

}
//////////////////////////////////////////////////////////////////////////////
///
void SmartObjectTS::Release() const
  {

  InterlockedDecrement(&m_ref_count);

  if (m_ref_count == 0)
    delete this;

  }

