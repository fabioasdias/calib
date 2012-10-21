//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlfunctioncallback.h,v 1.7 2005/02/11 09:12:35 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLFUNCTIONCALLBACK_H_
#define _GMLFUNCTIONCALLBACK_H_

#include "gmlcallback.h"

namespace gml
{
  /** @addtogroup Base
   *  @{
   */



  class  FunctionCallback : public Callback
  {
      /**<  Callback-wrapper for a C-function with no arguments
       and no return value:
       void func(); */

    public:

      FunctionCallback(void (*func) ()) : func_(func)
      {
        ASSERT(func != NULL);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual void Call()
      {
        (*func_) ();
      }
      //!<  See Callback::callback.

    private:
      void (*func_)();
  };

  template <class RETURN>
  class  FunctionCallbackR : public CallbackR<RETURN>
  {
      /**<  Callback-wrapper for a C-function with no arguments
      and a return value of type RETURN:
      RETURN func(); */
    public:

      FunctionCallbackR(RETURN(*func)()) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual RETURN Call()
      {
        return (*func_) ();
      }
      //!<  See CallbackR::callback.

    private:
      RETURN (*func_)();
  };

  template <class ARG1>
  class  FunctionCallback1 : public Callback1<ARG1>
  {
      /**<  Callback-wrapper for a C-function with one argument of
      type ARG1 and no return value:
      void func(ARG1 arg1); */
    public:

      FunctionCallback1(void (*func) (ARG1)) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual void Call(ARG1 arg1)
      {
        (*func_) (arg1);
      }
      //!<  See Callback1::callback.


    private:
      void (*func_)(ARG1);
  };

  template <class RETURN, class ARG1>
  class  FunctionCallbackR1 : public CallbackR1<RETURN, ARG1>
  {
      /**<  Callback-wrapper for a C-function with one argument of
      type ARG1 and a return value of type RETURN:
      RETURN func(ARG1 arg1); */
    public:

      FunctionCallbackR1(RETURN(*func)(ARG1)) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual RETURN Call(ARG1 arg1)
      {
        return (*func_) (arg1);
      }
      //!<  See CallbackR1::callback.



    private:
      RETURN (*func_)(ARG1);
  };

  template <class ARG1, class ARG2>
  class  FunctionCallback2 : public Callback2<ARG1, ARG2>
  {
      /**<  Callback-wrapper for a C-function with two arguments of
      type ARG1 and ARG2 and no return value:
      void func(ARG1 arg1, ARG2 arg2); */
    public:

      FunctionCallback2(void (*func) (ARG1, ARG2)) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual void Call(ARG1 arg1, ARG2 arg2)
      {
        (*func_) (arg1, arg2);
      }
      //!<  See Callback2::callback.


    private:
      void (*func_)(ARG1, ARG2);
  };

  template <class RETURN, class ARG1, class ARG2>
  class  FunctionCallbackR2 : public CallbackR2<RETURN, ARG1, ARG2>
  {
      /**<  Callback-wrapper for a C-function with two arguments of
      type ARG1 and ARG2 and a return value of type RETURN:
      RETURN func(ARG1 arg1, ARG2 arg2); */
    public:

      FunctionCallbackR2(RETURN(*func)(ARG1, ARG2)) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual RETURN Call(ARG1 arg1, ARG2 arg2)
      {
        return (*func_) (arg1, arg2);
      }
      //!<  See CallbackR2::callback.



    private:
      RETURN (*func_)(ARG1, ARG2);
  };

  template <class ARG1, class ARG2, class ARG3>
  class  FunctionCallback3 : public Callback3<ARG1, ARG2, ARG3>
  {
      /**<  Callback-wrapper for a C-function with three arguments of
      type ARG1, ARG2, and ARG3 and no return value:
      void func(ARG1 arg1, ARG2 arg2, ARG3); */
    public:

      FunctionCallback3(void (*func) (ARG1, ARG2, ARG3)) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual void Call(ARG1 arg1, ARG2 arg2, ARG3 arg3)
      {
        (*func_) (arg1, arg2, arg3);
      }
      //!<  See Callback2::callback.



    private:
      void (*func_)(ARG1, ARG2, ARG3);
  };

  template <class RETURN, class ARG1, class ARG2, class ARG3>
  class  FunctionCallbackR3 : public CallbackR3<RETURN, ARG1, ARG2, ARG3>
  {
      /**<  Callback-wrapper for a C-function with three arguments of
      type ARG1, ARG2, and ARG3 and a return value of type RETURN:
      RETURN func(ARG1 arg1, ARG2 arg2, ARG3 arg3); */
    public:

      FunctionCallbackR3(RETURN(*func)(ARG1, ARG2, ARG3)) : func_(func)
      {
        ASSERT(func);
      }
      /**<  The c'tor expects a function-pointer to a function
      of the appropriate type. */

      virtual RETURN Call(ARG1 arg1, ARG2 arg2, ARG3 arg3)
      {
        return (*func_) (arg1, arg2, arg3);
      }
      //!<  See CallbackR3::callback.


    private:
      RETURN (*func_)(ARG1, ARG2, ARG3);
  };


  /** @} */
}

#endif