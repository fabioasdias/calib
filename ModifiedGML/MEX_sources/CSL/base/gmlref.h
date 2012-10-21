//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlref.h,v 1.8 2004/06/11 14:45:39 04a_and Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLREF_H_
#define _GMLREF_H_

/** @file 
 *  @brief Definitions of smart reference
 *
 */

namespace gml
{
  /** @addtogroup Base
    *  @{
    */

  /**  
  @class Ref
  @brief Smart pointer class
  Smart pointers provide automatic memory management, so that programmer never cares on freeing
  memory. Smart pointers mechanism frees an object when there are no any references to it. 
  Smart pointers should be used instead of standard C pointers: 
  @code
  Object* obj; // standard pointer, should be deleted after use
  gml::Ref<Object> obj; // smart pointer frees memory when necessary
  @endcode
  @attention Smart pointers works only with objects that support AddRef() and Release() operations.
  It is assumed that object keeps a reference count (a number of smapt pointers pointing to it).
  This reference count is incremented in AddRef() command and decremented in Release(). Also
  Release()  performs check whether reference count is 0 and calls 'delete this'.
  GML provides special base class for this: gml::SmartObject. If you want to use smart pointers 
  either derive your object from this class or provide own implementation of AddRef() and Release()
  methods.
  1) initialization
  Smart pointers are initiliazed just like the standard pointers:
  @code
  gml::Ref<Object> obj =  new Object(1,2,3);
  @endcode
  @attention Smart pointers must never be defined like this: gml::Rev<Object>* obj; !!!
  2) use of smart pointers
  Smart pointers are dereferenced like normal pointers:
  @code
  gml::Ref<Object> obj =  new Object(1,2,3);
  obj->SomeMethod();
  (*obj).SomeMethod();
  @endcode
  3) smart pointers as parameters
  Smart pointers are implicitly casted to normal pointers:
  @code
  gml::Ref<Object> obj =  new Object(1,2,3);
  Object* obj1 =  obj;
  @endcode
  This operation is dangerous unless used properly. You should use it like follows. 
  Smart pointers may be passed to functions and returned from functions like normal pointers.
  @code
  ...
  Object* SomeMethod(Object* obj);
  ...
  gml::Ref<Object> obj =  new Object(1,2,3);
  gml::Ref<Object> obj1 = SomeMethod(obj);
  @endcode
  The general rule is this: 
  <b> Use ONLY smart pointers when storing objects. Use normals pointers when passing 
  smart pointers as parameters or return values </b>
  So the following is forbidden:
  @code
  class SomeClass
    {
    private:
      Object* obj;
    public:
      void CreateObject()
        {
        gml::Ref<Object> obj = new Object(1,2,3);
        m_obj = obj;
        } // at this point obj will be deleted, and m_obj will be undefined!!
    };
  @endcode
  Correct use:
  @code
  class SomeClass
    {
    private:
      gml::Ref<Object> obj;
    public:
      void CreateObject()
        {
        gml::Ref<Object> obj = new Object(1,2,3);
        m_obj = obj;
        } 
    };
  @endcode
  @note 
  Nevertheless, nobody restricts you from passing smart pointers as parameters and return values.
  Simple pointers are just have more natural interface.
  4) casting of smart pointers
  Since smart pointers are implicitly casted to C pointers, casting rules are the same as for C pointers.
  The only issue appears when use need to cast from one smart pointer to another. In this case you
  need to use gml::ConvRef() operation:
  @code
  gml::Ref<BaseObject> b;
  gml::Ref<DerivedObject> c;
  c = b; // this may not work in compilers which nor support template casting methods
  c = gml::ConvRef<DerivedObject>(b); // OK
  @endcode
  @attention
  This simple example not working (!) :
  @code
  Object* CreateObject()
    {
    gml::Ref<Object> obj = new Object;
    return obj; // at this point reference count of obj is 1, so the obj is deleted 
                // before returned from the function!
    }
  @endcode
  Correct use is one of the following:
  @code
  Object* CreateObject()
    {
    Object* obj = new Object;
    return obj; 
    }
  @endcode
  @code
  gml::Ref<Object> CreateObject()
    {
    gml::Ref<Object> obj = new Object;
    return obj; 
    }
  @endcode
  @warning It is forbidden to assign arrays created by new[] to smart pointers
  @code
  gml::Ref<Object> obj = new Object[10]; // result is undefined!!!!!
  @endcode
  @warning All smart object should be create by new operator!
  The following is <b> strictly forbidden </b>:
  @code
  Object obj;
  gml::Ref<Object> = &obj;
  @endcode
  */

  template <class T>
  class Ref
  {
    public:
      /// Default contructor
      Ref(T* real_ptr = NULL) : m_pointer(real_ptr)
      {
        Init();
      }

      /// Copy constructor
      Ref(const Ref& rhs) : m_pointer(rhs.m_pointer)
      {
        Init();
      }


      /// Destructor
      ~Ref()
      {
        if (m_pointer)
          m_pointer->Release();
      }

      /// Overloaded operator =
      Ref& operator=(const Ref& rhs)
      {
        if (m_pointer != rhs.m_pointer)
        {
          T* old_pointer = m_pointer;

          m_pointer = rhs.m_pointer;

          Init();

          if (old_pointer)
            old_pointer->Release();
        }
        return *this;
      }


      /// Overloaded operator
      T* operator->() const
      {
        // If you get this assertion, it means that you are
        // trying to call a class method via NULL pointer. 
        // If you continue, the program will crash for sure.
        ASSERT(m_pointer != NULL);

        return m_pointer;
      }
    
      //// Explicit return of the raw pointer (use with care!) 
      T* Get() const
         {return m_pointer;}

      /// Overloaded operator
      T& operator*() const
      {
        ASSERT(m_pointer != NULL);
        return *m_pointer;
      }


      /// Whether this pointer is not null
      int IsSet() const
      {
        return m_pointer != NULL;
      }

      /// Implicit conversion to C pointer
      operator T*() const
      {
        return m_pointer;
      }

#if (__BORLANDC__ >= 0x0550)
      /// Template conversion of smart pointers. Not supported by all the compilers
      template <class newT>
      operator Ref<newT>&()
      {
        return *(Ref<newT>*) (this);
      };
#endif

      /// @brief Forced assignment of C pointer to this reference
      /// @attention Danger function, use it carefully
      void Set(T* real_ptr)
      {
        m_pointer = real_ptr;
        Init();
      }

      /// Cleans this reference 
      void Clear()
      {
        if (m_pointer != NULL)
          m_pointer->Release();
        m_pointer = NULL;
      }


    private:
      /// Pointer to stored object
      T* m_pointer;

    private:
      void Init()
      {
        if (m_pointer == NULL)
          return;
        m_pointer->AddRef();
      }
  };

  /// @brief Casting & convertion of smart references
  /** @relates Ref
  */
  template <class newT, class oldT>
  inline Ref<newT>& ConvRef(const Ref<oldT>& old_ref)
  {
    return *(Ref<newT>*) (&old_ref);
  };

  /** @} */
}    

#endif