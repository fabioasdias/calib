//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlsmartobject.h,v 1.15 2004/06/15 15:29:14 ktosh Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLSMARTOBJECT_H_
#define _GMLSMARTOBJECT_H_

#include "gmlcommon.h"


#ifdef GML_THREAD_SAFE
#pragma message("gml::SmartObject is in thread-safe configuration")
#else
#endif

/** @file
 *  @brief Definitions of smart object (which supports smart references)
 *
 */

namespace gml
{
  /** @addtogroup Base
   *  @{
   */

  /// @brief Base class for objects with support for reference counting
  /// @sa gml::Ref
  class SmartObject
  {
    public:
      SmartObject() : m_ref_count(0)
      {
      }

      SmartObject(const SmartObject& rhs)
      : m_ref_count(0)
      {
      
      }
 
#if defined GML_THREAD_SAFE
      /// @brief Increment reference count
      /// @warning This function is used internally, you should never call it
      void AddRef() const;

      /// @brief Decrement reference count
      /// @warning This function is used internally, you should never call it
      void Release() const;
#else

      /// @brief Increment reference count
      /// @warning This function is used internally, you should never call it
      void AddRef() const
        {
        ++m_ref_count;
        }

      /// @brief Decrement reference count
      /// @warning This function is used internally, you should never call it
      void Release() const
        {
        // should not be called neighter on deleted objects, nor in objects
        // without smart references
        ASSERT(m_ref_count > 0);  
        if (--m_ref_count == 0)
          delete this;
        }

#endif
      /// Destructor is virtual
      virtual ~SmartObject()
      {
        // If this assertion is fired, this mean that you have deleted
        // a pointer to this object while somewhere else there is a 
        // smart reference also keeping this object.
        // It also may fire if you are trying to delete already deleted
        // object
        ASSERT(m_ref_count == 0); 
      }

    private:
      mutable long m_ref_count;
  };

  /** @} */
}    

#endif