//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlsmartobject_ts.h,v 1.1 2004/08/02 12:00:20 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLSMARTOBJECTSS_H_
#define _GMLSMARTOBJECTSS_H_

#include "gmlcommon.h"


/** @file
 *  @brief Definitions of Thread Safe smart object (which supports smart references)
 *
 */

namespace gml
{
  /** @addtogroup Base
   *  @{
   */

  /// @brief Base class for objects with support for reference counting
  /// @sa gml::Ref
  class SmartObjectTS
  {
    public:
      SmartObjectTS();

      SmartObjectTS(const SmartObjectTS& rhs);
 
      /// @brief Increment reference count
      /// @warning This function is used internally, you should never call it
      void AddRef() const;

      /// @brief Decrement reference count
      /// @warning This function is used internally, you should never call it
      void Release() const;

      /// Destructor is virtual
      virtual ~SmartObjectTS();

    private:
      mutable long m_ref_count;
  };

  /** @} */
}    

#endif