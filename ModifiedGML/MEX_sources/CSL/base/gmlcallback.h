//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlcallback.h,v 1.7 2004/04/26 09:13:50 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLCALLBACK_H_
#define _GMLCALLBACK_H_

/** @file gmlcallback.h
 *  @brief Definitions of callback helpers
 *
 */

#include "gmlsmartobject.h"

namespace gml
{
  /** @addtogroup Base
   *  @{
   */

  ///  Base class for callback with no arguments and no return value.  
  class Callback: public gml::SmartObject
  {
    public:

      virtual void Call() = 0;

      /// Callback method
      /**  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */

      void Call() const
      {
        ((Callback *) this)->Call();
      }
  };


  template <class RETURN>
  class  CallbackR: public gml::SmartObject
  {
      /**<  Base class for callback with no arguments and a return value
      of type RETURN. */
    public:

      virtual RETURN Call() = 0;
      RETURN Call() const
      {
        return(((CallbackR *) this)->Call());
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };

  template <class ARG1>
  class  Callback1: public gml::SmartObject
  {
      /**<  Base class for callback with one argument of type ARG1
      and no return value. */
    public:

      virtual void Call(ARG1 arg1) = 0;
      void Call(ARG1 arg1) const
      {
        ((Callback1 *) this)->Call(arg1);
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };
  template <class RETURN, class ARG1>
  class  CallbackR1: public gml::SmartObject
  {
      /**<  Base class for callback with one argument of type ARG1
      and a return value of type RETURN. */
    public:

      virtual RETURN Call(ARG1 arg1) = 0;
      RETURN Call(ARG1 arg1) const
      {
        return(((CallbackR1 *) this)->Call(arg1));
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };

  template <class ARG1, class ARG2>
  class  Callback2: public gml::SmartObject
  {
      /**<  Base class for callback with two arguments of type ARG1 and ARG2
      and no return value. */
    public:

      virtual void Call(ARG1 arg1, ARG2 arg2) = 0;
      void Call(ARG1 arg1, ARG2 arg2) const
      {
        ((Callback2 *) this)->Call(arg1, arg2);
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };

  template <class RETURN, class ARG1, class ARG2>
  class  CallbackR2: public gml::SmartObject
  {
      /**<  Base class for callback with two arguments of type ARG1 and ARG2
      and a return value of type RETURN. */
    public:

      virtual RETURN Call(ARG1 arg1, ARG2 arg2) = 0;
      RETURN Call(ARG1 arg1, ARG2 arg2) const
      {
        return(((CallbackR2 *) this)->Call(arg1, arg2));
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };

  template <class ARG1, class ARG2, class ARG3>
  class  Callback3: public gml::SmartObject
  {
      /**<  Base class for callback with three arguments of type ARG1, ARG2, and ARG3
      and no return value. */
    public:

      virtual void Call(ARG1 arg1, ARG2 arg2, ARG3 arg3) = 0;
      void Call(ARG1 arg1, ARG2 arg2, ARG3 arg3) const
      {
        ((Callback3 *)this)->Call(arg1, arg2, arg3);
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };

  template <class RETURN, class ARG1, class ARG2, class ARG3>
  class  CallbackR3: public gml::SmartObject
  {
      /**<  Base class for callback with three arguments of type ARG1, ARG2, and ARG3
      and a return value of type RETURN. */
    public:

      virtual RETURN Call(ARG1 arg1, ARG2 arg2, ARG3 arg3) = 0;
      RETURN Call(ARG1 arg1, ARG2 arg2, ARG3 arg3) const
      {
        return(((CallbackR3 *)this)->Call(arg1, arg2, arg3));
      }
      /**<  This method will be called for the callback
      with the appropriate arguments and must be
      defined by a derived class. */
  };

  /** @} */
}    

#include "gmlfunctioncallback.h"
#include "gmlmethodcallback.h"

#endif