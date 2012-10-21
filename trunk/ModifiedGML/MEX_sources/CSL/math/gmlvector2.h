//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlvector2.h,v 1.28 2005/03/23 14:43:16 melamori Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.


#ifndef _GMLVECTOR_H_INCLUDED
#define _GMLVECTOR_H_INCLUDED

/** @file gmlvector2.h
*  @brief defines template gml::TVector2, gml::Math2 and typedefs with utility functions
*/

#include "gmlmath.h"
#include "gmlvector3.h"
#include "../base/gmlcommon.h"

#ifdef GML_USE_INTEL_LIB 
#include <cv.h>
#endif


#ifdef GML_USE_MFC
#include <afxwin.h>
#endif


#ifdef GML_USE_OWL
#include <windows.hpp>
#endif

namespace gml
{
  /** @addtogroup Math
  * @{
  */

  /** @addtogroup Math2
  * @{
  */

  /// Template class for 2D vectors
  /** 
  * @param T - template type of TVector elements
  * @warning Use it with some SIGNED integral type, or a real type
  */

  template <class T>
  class TVector2
  {
    public:

      union
      {
          struct
          {
              T c[2];
          };
          struct
          {
              T x, y;
          };
      };


    public:

      /// @name Constructors
      /// @{

      /// No initialization
      inline TVector2()
      {
      }
      /// Initialization by scalar
      explicit inline TVector2(double v)
      {
        x = y = (T) v;
      }
      /// Initialization by given components
      inline TVector2(double x0, double y0)
      {
        x = (T) x0; y = (T) y0;
      }
      explicit inline TVector2(const TVector3<T>& u)
      {
        x = (T) u.x; y = (T) u.y;
      };


      /// @}

      /// Direct comparison (warning -- works badly when comparing floats and doubles)
      /// @note However, without this operator VC converts vectors to T* and compares anyway
      inline bool operator==(const TVector2<T>& data) const
      {
        return x == data.x && y == data.y;
      }

      /// Direct comparison (warning -- works badly when comparing floats and doubles)
      /// @note However, without this operator VC converts vectors to T* and compares anyway
      inline bool operator != (const TVector2<T>& data) const
      {
        return !operator==(data);
      }

      /// @name Element access
      /// @{

      static inline GetDim()
      {
        return 2;
      }
      inline T& operator [](int i)
      {
        ASSERT((i >= 0) && (i < 2)); return (&x)[i];
      }
      inline const T& operator [](int i) const
      {
        ASSERT((i >= 0) && (i < 2)); return (&x)[i];
      }


      /// Set elements by 2 double components
      inline void SetValue(double x0, double y0)
      {
        x = (T) x0; y = (T) y0;
      }

      /// Set all the elements to the same T value
      inline void SetValue(double a)
      {
        x = y = (T) a;
      }

      /// @}    

      /// @name Conversions
      /// @{

      /// Convert a TVector to array of (2) elements
      inline operator T *()
      {
        return &x;
      }
      /// Convert a TVector to array of (2) elements
      inline operator const T *() const
      {
        return &x;
      }
      /// @}


      /// @name Binary operations
      /// @{

      inline TVector2<T>& operator +=(const TVector2<T>& u)
      {
        x += u.x; y += u.y; return *this;
      }

      inline TVector2<T>& operator -=(const TVector2<T>& u)
      {
        x -= u.x; y -= u.y; return *this;
      }

      inline TVector2<T> operator +(const TVector2<T>& u) const
      {
        return TVector2<T>(x + u.x, y + u.y);
      }

      inline TVector2<T> operator -(const TVector2<T>& u) const
      {
        return TVector2<T>(x - u.x, y - u.y);
      }

      inline TVector2<T>& operator *=(const double d)
      {
        x = (T) (x * d); y = (T) (y * d); return *this;
      }

      inline TVector2<T>& operator /=(const double d)
      {
        ASSERT(d != (T) 0.0);
        x = (T) (x / d);
        y = (T) (y / d);
        return *this;
      }

      /// Vector scaling (this vector is not modified)
      inline TVector2<T> MultVec(const TVector2<T>& u) const
      {
        return TVector2<T>(x * u.x, y * u.y);
      }

      /// Vector-by vector division (this vector is not modified)
      inline TVector2<T> DivVec(const TVector2<T>& u) const
      {
        ASSERT(!Math2<T>::NearZero(u));
        return TVector2<T>(x / u.x, y / u.y);
      }

      inline TVector2<T> operator *(const double d) const
      {
        return TVector2<T>(x * d, y * d);
      }

      inline TVector2<T> operator /(const double d) const
      {
        ASSERT(d != (T) 0); return TVector2<T>(x / d, y / d);
      }

      /// dot product
      inline double operator*(const TVector2<T>& rhs) const
      {
        return DotProduct(rhs);
      }

      /// cross product
      inline double operator^(const TVector2<T>& rhs) const
      {
        return CrossProduct(rhs);
      }    

      /// dot product
      inline double DotProduct(const TVector2<T>& rhs) const
      {
        return x * rhs.x + y * rhs.y;
      }

      /// cross product
      inline double CrossProduct(const TVector2<T>& rhs) const
      {
        return x * rhs.y - y * rhs.x;
      }    


      /// @}

      /// @name Unary operations
      /// @{

      /// Vector (self) negation
      inline void Negate()
      {
        x = -x; y = -y;
      }

      // unary negation operator
      inline TVector2<T> operator -() const
      {
        return TVector2<T>(-x, -y);
      }

      /// @}


      /// @name Service methods
      /// @{

      /// Clip elements of this TVector to constraints from vmin to vmax
      inline void Clip(double vmin, double vmax)
      {
        ASSERT(vmax >= vmin);
        gml::Clip(x, vmin, vmax);
        gml::Clip(y, vmin, vmax);
      }

      /// returns normalized vector (always double)
      inline TVector2<double> operator ~() const
      {
        double len = Length();

        if (MathD::AboutZero(len))
          return TVector2<double>(0, 0);
        else
          return TVector2<double>(x / len, y / len);
      };

      ///  Normalize this vector, return vector itself.
      inline TVector2<T>& Normalize()
      {
        TVector2<double> Temp = ~(*this);
        *this = TVector2<T>(Temp.x, Temp.y);
        return *this;
      }

      /// Test whether the TVector is normalized
      inline bool Normalized() const
      {
        return MathD::AboutEqual(Length(), 1);
      }


      /// Squared length of vector
      inline double SqrLength() const
      {
        return x * x + y * y;
      }

      /// Length of the vector
      inline double Length() const
      {
        return sqrt(SqrLength());
      }

      /// Return true if all components of this vector less of equal than \a u
      bool LessOrEqual(const TVector2<T>& u) const
      {
        return (x <= u.x) && (y <= u.y);
      }

      /// Length of the vector
      inline double operator !() const
      {
        return Length();
      };

      /// Returns normal N to this vector, such that DotProduct(*this, N) = 0
      /**
       @param def - vector returned if the length of this vector is near zero
       @note Projection of the resulting vector to the X axis will have the
             same sign that projection of this vector. If x = 0, then
             normal will be equal (1,0)
       */
      TVector2<T> NormalRight() const
      {
        return TVector2<T>(y, -x);
      } 
      /** @} */

      /// Treat array of (2) elements as a TVector
      inline static const TVector2<T>& Cast(const T* u)
      {
        return *(const TVector2<T>*) u;
      }
      /// Treat array of (2) elements as a TVector
      inline static TVector2<T>& Cast(T* u)
      {
        return *(TVector2<T>*) u;
      }

      /// @name MFC, VCL, OWL - specific functions (defined only if proper defines are found)
      /// @{

#ifdef GML_USE_OWL

      inline TVector2(const TPoint& p)
      {
        x = (T) p.x; y = (T) p.y;
      };

      inline TVector2<T>& operator =(const TPoint& p)
      {
        x = (double) p.x; y = (double) p.y; return *this;
      };

      operator TPoint()
      {
        return TPoint((int) x, (int) y);
      };
#endif

#ifdef GML_USE_MFC
      inline TVector2(const CPoint& p)
      {
        x = (T) p.x; y = (T) p.y;
      };
      inline TVector2(const POINT& p)
      {
        x = (T) p.x; y = (T) p.y;
      };
      inline TVector2(const CSize& p)
      {
        x = (T) p.cx; y = (T) p.cy;
      };

      inline TVector2<T>& operator =(const CPoint& p)
      {
        x = (T) p.x; y = (T) p.y; return *this;
      };
      inline TVector2<T>& operator =(const POINT& p)
      {
        x = (T) p.x; y = (T) p.y; return *this;
      };
      inline TVector2<T>& operator =(const CSize& p)
      {
        x = (T) p.cx; y = (T) p.cy;  return *this;
      };
      operator CPoint()
      {
        return CPoint((int) x, (int) y);
      };
#endif

#ifdef GML_USE_INTEL_LIB
      operator CvPoint()
      {
        return cvPoint((int) x, (int) y);
      };
      operator CvSize()
      {
        return cvSize((int) x, (int) y);
      };

      inline TVector2(const CvPoint& p)
      {
        x = (T) p.x; y = (T) p.y;
      };
      inline TVector2 operator =(const CvPoint& p)
      {
        x = (T) p.x; y = (T) p.y; return *this;
      };

#endif

      /// @}
  };  // class TVector2<T>

  // -----------------------------------------------------------------
  // Related template functions
  // -----------------------------------------------------------------


  /// Multiplication of scalar d by TVector u
  /** @relates TVector2
  */
  template <class T>
  inline TVector2<T> operator *(const double d, const TVector2<T>& u)
  {
    return u * d;
  }

  /// Squared length of given vector
  /** @relates TVector2
  */
  template <class T>
  inline double SqrLength(const TVector2<T>& u)
  {
    return u.SqrLength();
  }

  /// Length of the vector
  /** @relates TVector2
  */
  template <class T>
  inline double Length(const TVector2<T>& u)
  {
    return u.Length();
  }

  /// @brief Dot product 
  /// @deprecated use use DotProduct instead
  /** @relates TVector2
  */
  template <class T>
  inline double DotProd(const TVector2<T>& v1, const TVector2<T>& v2)
  {
    return v1 * v2;
  }

  /// Dot product
  /** @relates TVector2
  */
  template <class T>
  inline double DotProduct(const TVector2<T>& v1, const TVector2<T>& v2)
  {
    return v1 * v2;
  }


  /// @brief Cross product 
  /// @deprecated use CrossProduct instead
  /** @relates TVector2
  */
  template <class T>
  inline double CrossProd(const TVector2<T>& v1, const TVector2<T>& v2)
  {
    return v1 ^ v2;
  }

  /// Cross product
  /** @relates TVector2
  */
  template <class T>
  inline double CrossProduct(const TVector2<T>& v1, const TVector2<T>& v2)
  {
    return v1 ^ v2;
  }


  /// cos between two vectors
  /** @relates TVector2
  */
  template <class T>
  inline double Cos(const TVector2<T>& a, const TVector2<T>& b)
  {
    ASSERT(!MathD::AboutZero(SqrLength(a)) && !MathD::AboutZero(SqrLength(b)));
    return Clipped((a * b) / sqrt(SqrLength(a) * SqrLength(b)), -1, 1);
  }


  /// sin between two vectors
  /** @relates TVector2
  */
  template <class T>
  inline double Sin(const TVector2<T>& a, const TVector2<T>& b)
  {
    ASSERT(!MathD::AboutZero(SqrLength(a)) && !MathD::AboutZero(SqrLength(b)));
    return Clipped(fabs(a ^ b) / sqrt((SqrLength(a) * SqrLength(b))), 0, 1);
  }


  /// Convert TVector2<T_FROM> to TVector2<T_TO>
  /** @relates TVector2
  */
  template <class T_FROM, class T_TO>
  inline TVector2<T_TO> Conv(const TVector2<T_FROM>& u)
  {
    return TVector2<T_TO>(u.x, u.y);
  }


  /// Convert TVector2<T> to TVector2<float>
  /** @relates TVector2
  */
  template <class T>
  inline TVector2<float> ConvF(const TVector2<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TVector2<T> to TVector2<double>
  /** @relates TVector2
  */
  template <class T>
  inline TVector2<double> ConvD(const TVector2<T>& u)
  {
    return Conv<T, double>(u);
  }

  /// Convert TVector2<T> to TVector2<int>
  /** @relates TVector2
  */
  template <class T>
  inline TVector2<int> ConvI(const TVector2<T>& u)
  {
    return Conv<T, int>(u);
  }

  /// Convert TVector2<T> to TVector2<int>
  /** @relates TVector2
  */
  template <class T>
  inline TVector2<short> ConvS(const TVector2<T>& u)
  {
    return Conv<T, short>(u);
  }




  /// Comparison of 2D vectors with a tolerance
  /** @param T - some REAL type (float, double)
    *
    */
  template <class T>
  class Math2 : public Math<T>
  {
    public:

      inline static bool AboutZero(const TVector2<T>& v,
                                   const double tolerance)
      {
        return Math<T>::AboutZero(v.x, tolerance) &&
               Math<T>::AboutZero(v.y,
                                  tolerance);
      }
      inline static bool AboutZero(const TVector2<T>& v)
      {
        return AboutZero(v, TOLERANCE);
      }

      inline static bool NearZero(const TVector2<T>& v)
      {
        return AboutZero(v, EPSILON);
      }

      inline static bool AboutEqual(const TVector2<T>& v1,
                                    const TVector2<T>& v2,
                                    const double tolerance)
      {
        return AboutZero(v1 - v2, tolerance);
      }

      inline static bool AboutEqual(const TVector2<T>& v1,
                                    const TVector2<T>& v2)
      {
        return AboutZero(v1 - v2, TOLERANCE);
      }

      inline static bool NearEqual(const TVector2<T>& v1,
                                   const TVector2<T>& v2)
      {
        return AboutZero(v1 - v2, EPSILON);
      }
  };  // class Math2<T>

  // ----------------------------------------------------
  //             PREDEFINED TYPES
  // ----------------------------------------------------

  typedef TVector2<short> Vector2s;
  typedef TVector2<int> Vector2i;
  typedef TVector2<float> Vector2f;
  typedef TVector2<double> Vector2d;

  typedef Math2<float> Math2f;
  typedef Math2<double> Math2d;

  /* @} */

  /* @} */
  template <class T>
  inline Vector2i ToIntVector(TVector2<T> in_Vect)
  {
    return Vector2i(in_Vect.x, in_Vect.y);
  };
}


#endif