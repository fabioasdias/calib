//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlvector4.h,v 1.15 2004/06/07 04:14:29 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.


#ifndef _GMLVECTOR4_H_INCLUDED
#define _GMLVECTOR4_H_INCLUDED

/** @file gmlvector4.h
*  @brief defines template gml::TVector4, gml::Math3 and typedefs with utility functions
*/

#include "gmlvector3.h"

namespace gml
{
  /** @addtogroup Math
  * @{
  */

  /** @addtogroup Math4
  * @{
  */

  /// Template class for 4D geometric vectors
  /** 
  * @param T - template type of TVector elements
  * @warning Use it with some SIGNED integral type, or a real type
  */

  template <class T>
  class TVector4
  {
    public:

      union
      {
          struct
          {
              T c[4];
          };
          struct
          {
              T x, y, z, w;
          };
      };

    public:

      /// @name Constructors
      /// @{

      /// No initialization
      inline TVector4()
      {
      }
      /// Initialization by scalar
      explicit inline TVector4(double v)
      {
        x = y = z = w = (T) v;
      }

      /// Initialization by given components
      inline TVector4(double x0, double y0, double z0, double w0)
      {
        x = (T) x0; y = (T) y0; z = (T) z0; w = (T) w0;
      }

      /// Initialization by given 3d-vector (w become equal to 1)
      inline TVector4(const TVector3<T>& v, double w0 = 1)
      {
        x = v.x; y = v.y; z = v.z; w = w0;
      }


      /// @}

      /// Direct comparison (warning -- works badly when comparing floats and doubles)
      /// @note However, without this operator VC converts vectors to T* and compares anyway
      inline bool operator==(const TVector4<T>& data)
      {
        return x == data.x && y == data.y && z == data.z && w == data.w;
      }

      /// Direct comparison (warning -- works badly when comparing floats and doubles)
      /// @note However, without this operator VC converts vectors to T* and compares anyway
      inline bool operator != (const TVector4<T>& data)
      {
        return !operator==(data);
      }

      /// @name Element access
      /// @{
      inline T& operator [](int i)
      {
        ASSERT((i >= 0) && (i < 4)); return (&x)[i];
      }
      inline const T& operator [](int i) const
      {
        ASSERT((i >= 0) && (i < 4)); return (&x)[i];
      }


      /// Set elements by 3 double components
      inline void SetValue(double x0, double y0, double z0, double w0)
      {
        x = (T) x0; y = (T) y0; z = (T) z0; w = (T) w0;
      }

      /// Set all the elements to the same T value
      inline void SetValue(double a)
      {
        x = y = z = w = (T) a;
      }

      /// @}    

      /// @name Conversions
      /// @{

      /// Convert a TVector to array of (3) elements
      inline operator T *()
      {
        return &x;
      }
      /// Convert a TVector to array of (3) elements
      inline operator const T *() const
      {
        return &x;
      }
      /// @}


      /// @name Binary operations
      /// @{

      inline TVector4<T>& operator +=(const TVector4<T>& u)
      {
        x += u.x; y += u.y; z += u.z; w += u.w; return *this;
      }

      inline TVector4<T>& operator -=(const TVector4<T>& u)
      {
        x -= u.x; y -= u.y; z -= u.z; w -= u.w; return *this;
      }

      inline TVector4<T> operator +(const TVector4<T>& u) const
      {
        return TVector4<T>(x + u.x, y + u.y, z + u.z, w + u.w);
      }

      inline TVector4<T> operator -(const TVector4<T>& u) const
      {
        return TVector4<T>(x - u.x, y - u.y, z - u.z, w - u.w);
      }

      inline TVector4<T>& operator *=(const double d)
      {
        x = (T) (x * d); y = (T) (y * d); z = (T) (z * d); w = (T) (w * d); return *this;
      }

      inline TVector4<T>& operator /=(const double d)
      {
        ASSERT(d != (T) 0.0);
        x = (T) (x / d);
        y = (T) (y / d);
        z = (T) (z / d);
        w = (T) (w / d);
        return *this;
      }

      /// Vector scaling (this vector is not modified)
      inline TVector4<T> MultVec(const TVector4<T>& u) const
      {
        return TVector3<T>(x * u.x, y * u.y, z * u.z, w * u.w);
      }

      /// Vector-by vector division (this vector is not modified)
      inline TVector4<T> DivVec(const TVector4<T>& u) const
      {
        ASSERT(!Math4<T>::NearZero(u));
        return TVector3<T>(x / u.x, y / u.y, z / u.z, w / u.w);
      }

      inline TVector4<T> operator *(const double d) const
      {
        return TVector4<T>(x * d, y * d, z * d, w * d);
      }

      inline TVector4<T> operator /(const double d) const
      {
        ASSERT(d != (T) 0); return TVector4<T>(x / d, y / d, z / d, w / d);
      }

      /// dot product
      inline double operator*(const TVector4<T>& rhs) const
      {
        return DotProduct(rhs);
      }

      /// dot product
      inline double DotProduct(const TVector4<T>& rhs) const
      {
        return x * rhs.x + y * rhs.y + z * rhs.z + w * rhs.w;
      }


      /// @}

      /// @name Unary operations
      /// @{

      /// Vector (self) negation
      inline void Negate()
      {
        x = -x; y = -y; z = -z; w = -w;
      }

      /// Unary negation operator
      inline TVector4<T> operator -() const
      {
        return TVector4<T>(-x, -y, -z, -w);
      }

      /// returns normalized vector (always double)
      inline TVector4<double> operator ~() const
      {
        double len = Length();

        if (MathD::AboutZero(len))
          return TVector4<double>(0, 0, 0, 0);
        else
          return TVector4<double>(x / len, y / len, z / len, w / len);
      };

      ///  Normalize this vector, return vector itself.
      inline TVector4<T>& Normalize()
      {
        *this = Conv<double, T>(~(*this));
        return *this;
      }

      /// Length of the vector
      inline double Length() const
      {
        return sqrt(SqrLength());
      }

      /// Length of the vector
      inline double operator !() const
      {
        return Length();
      };

      /// @}


      /// @name Service methods
      /// @{

      /// Clip elements of this TVector to constraints from vmin to vmax
      inline void Clip(double vmin, double vmax)
      {
        ASSERT(vmax >= vmin);
        gml::Clip(x, vmin, vmax);
        gml::Clip(y, vmin, vmax);
        gml::Clip(z, vmin, vmax);
        gml::Clip(w, vmin, vmax);
      }



      /// Test whether the TVector is normalized
      inline bool Normalized() const
      {
        return MathD::AboutEqual(Length(), 1);
      }


      /// Squared length of vector
      inline double SqrLength() const
      {
        return x * x + y * y + z * z + w * w;
      }


      /// Return true if all components of this vector less of equal than \a u
      bool LessOrEqual(const TVector4<T>& u) const
      {
        return (x <= u.x) && (y <= u.y) && (z <= u.z) && (w <= u.z);
      }

      /// Return true if all components of this vector less of equal than \a u
      bool LessOrEqual(const TVector3<T>& u) const
      {
        return (x <= u.x) && (y <= u.y) && (z <= u.z);
      }

      /// Return C-norm of the vector (maximal value among coords)
      T MaxValue() const
      {
        return Max(Max3(x, y, z), w);
      }

      inline TVector3<double> Homogenize()
      {
        TVector3<double> rt;
        ASSERT(v.z != (T) 0.0);
        rt.x = v.x / v.w;
        rt.y = v.y / v.w;
        rt.z = v.z / v.w;
        return rt;
      }

      /** @} */

      /// Treat array of (3) elements as a TVector
      inline static const TVector4<T>& Cast(const T* u)
      {
        return *(const TVector4<T>*) u;
      }
      /// Treat array of (3) elements as a TVector
      inline static TVector4<T>& Cast(T* u)
      {
        return *(TVector4<T>*) u;
      }

      /// @name MFC, VCL, OWL - specific functions (defined only if proper defines are found)
      /// @{

#ifdef GML_USE_OWL

      inline TVector4(const TPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = w = 0;
      };

      inline TVector4<T>& operator =(const TPoint& p)
      {
        x = (double) p.x; y = (double) p.y; z = w = 0;return *this;
      };

      operator TPoint()
      {
        return TPoint((int) x, (int) y);
      };
#endif

#ifdef GML_USE_MFC
      inline TVector4(const CPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = w = 0;
      };
      inline TVector4(const CSize& p)
      {
        x = (T) p.cx; y = (T) p.cy; z = w = 0;
      };

      inline TVector4<T>& operator =(const CPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = w = 0; return *this;
      };
      inline TVector4<T>& operator =(const CSize& p)
      {
        x = (T) p.cx; y = (T) p.cy; z = w = 0; return *this;
      };
      operator CPoint()
      {
        return CPoint((int) x, (int) y);
      };
#endif

#ifdef GML_USE_INTEL_LIB
      operator CvPoint()
      {
        CvPoint Temp; 
        Temp.x = (int) x; 
        Temp.y = (int) y; 
        return Temp;
      };
      inline TVector4(const CvPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = w = 0;
      };
      inline TVector4 operator =(const CvPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = w = 0; return *this;
      };

#endif

      /// @}
  };  // class TVector4<T>

  // -----------------------------------------------------------------
  // Related template functions
  // -----------------------------------------------------------------


  /// Multiplication of scalar d by TVector u
  /** @relates TVector4
  */
  template <class T>
  inline TVector4<T> operator *(const double d, const TVector4<T>& u)
  {
    return u * d;
  }

  /// Squared length of given vector
  /** @relates TVector4
  */
  template <class T>
  inline double SqrLength(const TVector4<T>& u)
  {
    return u.SqrLength();
  }

  /// Length of the vector
  /** @relates TVector4
  */
  template <class T>
  inline double Length(const TVector4<T>& u)
  {
    return u.Length();
  }

  /// Dot product
  /** @relates TVector4
  */
  template <class T>
  inline double DotProduct(const TVector4<T>& v1, const TVector4<T>& v2)
  {
    return v1 * v2;
  }



  /// Convert TVector4<T_FROM> to TVector4<T_TO>
  /** @relates TVector4
  */
  template <class T_FROM, class T_TO>
  inline TVector4<T_TO> Conv(const TVector4<T_FROM>& u)
  {
    return TVector4<T_TO>(u.x, u.y, u.z, u.w);
  }


  /// Convert TVector4<T> to TVector4<float>
  /** @relates TVector4
  */
  template <class T>
  inline TVector4<float> ConvF(const TVector4<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TVector4<T> to TVector4<double>
  /** @relates TVector4
  */
  template <class T>
  inline TVector4<double> ConvD(const TVector4<T>& u)
  {
    return Conv<T, double>(u);
  }

  /// Convert TVector4<T> to TVector4<int>
  /** @relates TVector4
  */
  template <class T>
  inline TVector4<int> ConvI(const TVector4<T>& u)
  {
    return Conv<T, int>(u);
  }

  /// Convert TVector4<T> to TVector4<int>
  /** @relates TVector4
  */
  template <class T>
  inline TVector4<short> ConvS(const TVector4<T>& u)
  {
    return Conv<T, short>(u);
  }



  /// Comparison of 4D vectors with a tolerance
  /** @param T - some REAL type (float, double)
    *
    */
  template <class T>
  class Math4 : public Math<T>
  {
    public:

      inline static bool AboutZero(const TVector4<T>& v,
                                   const double tolerance)
      {
        return Math<T>::AboutZero(v.x, tolerance) &&
               Math<T>::AboutZero(v.y,
                                  tolerance) &&
               Math<T>::AboutZero(v.z,
                                  tolerance) &&
               Math<T>::AboutZero(v.w,
                                  tolerance);
      }
      inline static bool AboutZero(const TVector4<T>& v)
      {
        return AboutZero(v, TOLERANCE);
      }

      inline static bool NearZero(const TVector4<T>& v)
      {
        return AboutZero(v, EPSILON);
      }

      inline static bool AboutEqual(const TVector4<T>& v1,
                                    const TVector4<T>& v2,
                                    const double tolerance)
      {
        return AboutZero(v1 - v2, tolerance);
      }

      inline static bool AboutEqual(const TVector4<T>& v1,
                                    const TVector4<T>& v2)
      {
        return AboutZero(v1 - v2, TOLERANCE);
      }

      inline static bool NearEqual(const TVector4<T>& v1,
                                   const TVector4<T>& v2)
      {
        return AboutZero(v1 - v2, EPSILON);
      }
  };  // class Math2<T>

  // ----------------------------------------------------
  //             PREDEFINED TYPES
  // ----------------------------------------------------

  typedef TVector4<short> Vector4s;
  typedef TVector4<int> Vector4i;
  typedef TVector4<float> Vector4f;
  typedef TVector4<double> Vector4d;

  typedef Math4<float> Math4f;
  typedef Math4<double> Math4d;

  /* @} */

  /* @} */
}

#endif