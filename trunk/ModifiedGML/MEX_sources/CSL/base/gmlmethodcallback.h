//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlmethodcallback.h,v 1.8 2005/02/11 09:13:01 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLMETHODCALLBACK_H_
#define _GMLMETHODCALLBACK_H_

#include "gmlcallback.h"

namespace gml
{
  /** @addtogroup Base
   *  @{
   */


  template <class CLASS>
  class  MethodCallback : public Callback
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with no arguments and no return value:
      void CLASS::func();
      void CLASS::func() const; */
    public: 
      typedef void (CLASS::*ConstMethod)() const;

      MethodCallback(CLASS* obj, void (CLASS::* meth) ()) : obj_(obj),
                                                            meth_((ConstMethod)
                                                                  meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);
      }
      MethodCallback(const CLASS* obj, void (CLASS::* meth) () const) : obj_(obj),
                                                                        meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual void Call()
      {
        (obj_->*meth_) ();
      }
      //!<  See Callback::callback.

      
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }



    private:
      const CLASS* obj_;
      void (CLASS::*meth_)() const;
  };

  template <class CLASS, class RETURN>
  class  MethodCallbackR : public CallbackR<RETURN>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with no arguments and a return value of type RETURN:
      RETURN CLASS::func();
      RETURN CLASS::func() const; */
    public:
      typedef RETURN (CLASS::*ConstMethod)() const;

      MethodCallbackR(CLASS* obj, RETURN(CLASS::* meth)()) : obj_(obj),
                                                             meth_((ConstMethod)
                                                                   meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallbackR(const CLASS* obj, RETURN(CLASS::* meth)() const) : obj_(obj),
                                                                         meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual RETURN Call()
      {
        return (obj_->*meth_) ();
      }
      //!<  See CallbackR::callback.

          
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

    private:
      const CLASS* obj_;
      RETURN (CLASS::*meth_)() const;
  };

  template <class CLASS, class ARG1>
  class  MethodCallback1 : public Callback1<ARG1>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with one argument of type ARG1 and no return value:
      void CLASS::func(ARG1 arg1);
      void CLASS::func(ARG1 arg1) const; */
    public:
      typedef void (CLASS::*ConstMethod)(ARG1) const;

      MethodCallback1(CLASS* obj, void (CLASS::* meth) (ARG1)) : obj_(obj),
                                                                 meth_((ConstMethod)
                                                                       meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallback1(const CLASS* obj, void (CLASS::* meth) (ARG1) const) : obj_(obj),
                                                                             meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual void Call(ARG1 arg1)
      {
        (obj_->*meth_) (arg1);
      }
      //!<  See Callback1::callback.

    
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

            /// Return a pointer to stored method
      void (CLASS::* GetMethod() const )(ARG1) const
      {
        return meth_;
      }

    private:
      const CLASS* obj_;
      void (CLASS::*meth_)(ARG1) const;
  };

  template <class CLASS, class RETURN, class ARG1>
  class  MethodCallbackR1 : public CallbackR1<RETURN, ARG1>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with one argument of type ARG1 and a return value
      of type RETURN:
      RETURN CLASS::func(ARG1 arg1);
      RETURN CLASS::func(ARG1 arg1) const; */
    public:
      typedef RETURN (CLASS::*ConstMethod)(ARG1) const;

      MethodCallbackR1(CLASS* obj, RETURN(CLASS::* meth)(ARG1)) : obj_(obj),
                                                                  meth_((ConstMethod)
                                                                        meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallbackR1(const CLASS* obj, RETURN(CLASS::* meth)(ARG1) const) : obj_(obj),
                                                                              meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual RETURN Call(ARG1 arg1)
      {
        return (obj_->*meth_) (arg1);
      }
      //!<  See CallbackR1::callback.


          
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

      
      /// Return a pointer to stored method
      void (CLASS::* GetMethod() const )(ARG1) const
      {
        return meth_;
      }

    private:
      const CLASS* obj_;
      RETURN (CLASS::*meth_)(ARG1) const;
  };

  template <class CLASS, class ARG1, class ARG2>
  class  MethodCallback2 : public Callback2<ARG1, ARG2>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with two arguments of type ARG1 and ARG2 and no return value:
      void CLASS::func(ARG1 arg1, ARG2 arg2);
      void CLASS::func(ARG1 arg1, ARG2 arg2) const; */
    public:
      typedef void (CLASS::*ConstMethod)(ARG1, ARG2) const;

      MethodCallback2(CLASS* obj, void (CLASS::* meth) (ARG1, ARG2)) : obj_(obj),
                                                                       meth_((ConstMethod)
                                                                             meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallback2(const CLASS* obj,
                      void (CLASS::* meth) (ARG1, ARG2) const) : obj_(obj),
                                                                 meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual void Call(ARG1 arg1, ARG2 arg2)
      {
        (obj_->*meth_) (arg1, arg2);
      }
      //!<  See Callback2::callback.


          
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

      /// Return a pointer to stored method
      void (CLASS::* GetMethod() const )(ARG1) const
      {
        return meth_;
      }

    private:
      const CLASS* obj_;
      void (CLASS::*meth_)(ARG1, ARG2) const;
  };

  template <class CLASS, class RETURN, class ARG1, class ARG2>
  class  MethodCallbackR2 : public CallbackR2<RETURN, ARG1, ARG2>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with two arguments of type ARG1 and ARG2 and a return
      value of type RETURN:
      RETURN CLASS::func(ARG1 arg1, ARG2 arg2);
      RETURN CLASS::func(ARG1 arg1, ARG2 arg2) const; */
    public:
      typedef RETURN (CLASS::*ConstMethod)(ARG1, ARG2) const;

      MethodCallbackR2(CLASS* obj, RETURN(CLASS::* meth)(ARG1, ARG2)) : obj_(obj),
                                                                        meth_((ConstMethod)
                                                                              meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallbackR2(const CLASS* obj,
                       RETURN(CLASS::* meth)(ARG1, ARG2) const) : obj_(obj),
                                                                  meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual RETURN Call(ARG1 arg1, ARG2 arg2)
      {
        return (obj_->*meth_) (arg1, arg2);
      }
      //!<  See CallbackR2::callback.

          
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

      /// Return a pointer to stored method
      void (CLASS::* GetMethod() const )(ARG1) const
      {
        return meth_;
      }

    private:
      const CLASS* obj_;
      RETURN (CLASS::*meth_)(ARG1, ARG2) const;
  };

  template <class CLASS, class ARG1, class ARG2, class ARG3>
  class  MethodCallback3 : public Callback3<ARG1, ARG2, ARG3>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with three arguments of type ARG1, ARG2, and ARG3 and no return value:
      void CLASS::func(ARG1 arg1, ARG2 arg2, ARG3 arg3);
      void CLASS::func(ARG1 arg1, ARG2 arg2, ARG3 arg3) const; */
    public:
      typedef void (CLASS::*ConstMethod)(ARG1, ARG2, ARG3) const;

      MethodCallback3(CLASS* obj, void (CLASS::* meth) (ARG1, ARG2, ARG3)) : obj_(obj),
                                                                             meth_((ConstMethod)
                                                                                   meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallback3(const CLASS* obj,
                      void (CLASS::* meth) (ARG1, ARG2, ARG3) const) : obj_(obj),
                                                                       meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual void Call(ARG1 arg1, ARG2 arg2, ARG3 arg3)
      {
        (obj_->*meth_) (arg1, arg2, arg3);
      }
      //!<  See Callback3::callback.


          
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

      /// Return a pointer to stored method
      void (CLASS::* GetMethod() const )(ARG1) const
      {
        return meth_;
      }

    private:
      const CLASS* obj_;
      void (CLASS::*meth_)(ARG1, ARG2, ARG3) const;
  };

  template <class CLASS, class RETURN, class ARG1, class ARG2, class ARG3>
  class  MethodCallbackR3 : public CallbackR3<RETURN, ARG1, ARG2, ARG3>
  {
      /**<  Callback-wrapper for a C++-method of a class CLASS
      with three arguments of type ARG1, ARG2, and ARG3 and a return
      value of type RETURN:
      RETURN CLASS::func(ARG1 arg1, ARG2 arg2, ARG3 arg3);
      RETURN CLASS::func(ARG1 arg1, ARG2 arg2, ARG3 arg3) const; */
    public:
      typedef RETURN (CLASS::*ConstMethod)(ARG1, ARG2, ARG3) const;

      MethodCallbackR3(CLASS* obj, RETURN(CLASS::* meth)(ARG1, ARG2, ARG3)) : obj_(obj),
                                                                              meth_((ConstMethod)
                                                                                    meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      MethodCallbackR3(const CLASS* obj,
                       RETURN(CLASS::* meth)(ARG1, ARG2, ARG3) const) : obj_(obj),
                                                                        meth_(meth)
      {
        ASSERT(obj);
        // this command is commented out because VC6 is crashes during
        // compiling, when MethodCallback is used in the class derived
        // from two parent classes...
        //ASSERT(meth);

      }
      /**<  The c'tor expects a pointer to an object of type CLASS
      and a method-pointer to a method of the appropriate type.
      Non-const- and const-methods are supported!
      Note that the object-pointer will be stored in a normal
      pointer (not a SO<CLASS>-pointer)! */

      virtual RETURN Call(ARG1 arg1, ARG2 arg2, ARG3 arg3)
      {
        return (obj_->*meth_) (arg1, arg2, arg3);
      }
      //!<  See CallbackR2::callback.

          
      /// Return a pointer to stored object
      const CLASS* GetObj() const
      {
        return obj_;
      }

      /// Return a pointer to stored method
      void (CLASS::* GetMethod() const )(ARG1) const
      {
        return meth_;
      }
    private:
      const CLASS* obj_;
      RETURN (CLASS::*meth_)(ARG1, ARG2, ARG3) const;
  };


  /** @} */
}

#endif