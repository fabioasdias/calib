//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlvector3.h,v 1.24 2005/03/11 09:26:59 melamori Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.


#ifndef _GMLVECTOR3_H_INCLUDED
#define _GMLVECTOR3_H_INCLUDED

/** @file gmlvector3.h
*  @brief defines template gml::TVector3, gml::Math3 and typedefs with utility functions
*/

#include "gmlmath.h"

#ifdef GML_USE_MFC
#include <afxwin.h>
#endif

#ifdef GML_USE_INTEL_LIB 
#include <cv.h>
#endif

#ifdef GML_USE_OWL
#include <windows.hpp>
#endif

namespace gml
{
  /** @addtogroup Math
  * @{
  */

  /** @addtogroup Math3
  * @{
  */

  /// Template class for 3D geometric vectors
  /** 
  * @param T - template type of TVector elements
  * @warning Use it with some SIGNED integral type, or a real type
  */

  template <class T>
  class TVector3
  {
    public:

      union
      {
          struct
          {
              T c[3];
          };
          struct
          {
              T x, y, z;
          };
      };

    public:

      /// @name Constructors
      /// @{

      /// No initialization
      inline TVector3()
      {
      }
      /// Initialization by scalar
      explicit inline TVector3(double v)
      {
        x = y = z = (T) v;
      }
      /// Initialization by given components
      inline TVector3(double x0, double y0, double z0)
      {
        x = (T) x0; y = (T) y0; z = (T) z0;
      }

      inline TVector3(T* data)
      {
        x = data[0]; y = data[1]; z = data[2];
      }

      inline TVector3(const TVector3<T>& data)
      {
        x = data[0]; y = data[1]; z = data[2];
      }

      /// Direct comparison (warning -- works badly when comparing floats and doubles)
      /// @note However, without this operator VC converts vectors to T* and compares anyway
      inline bool operator==(const TVector3<T>& data)
      {
        return x == data.x && y == data.y && z == data.z;
      }

      /// Direct comparison (warning -- works badly when comparing floats and doubles)
      /// @note However, without this operator VC converts vectors to T* and compares anyway
      inline bool operator != (const TVector3<T>& data)
      {
        return !operator==(data);
      }

      /// @}

      /// @name Element access
      /// @{
      static inline GetDim()
      {
        return 3;
      }

      inline T& operator [](int i)
      {
        ASSERT((i >= 0) && (i < 3));
        return (&x)[i];
      }
      inline const T& operator [](int i) const
      {
        ASSERT((i >= 0) && (i < 3));
        return (&x)[i];
      }


      /// Set elements by 3 double components
      inline void SetValue(double x0, double y0, double z0)
      {
        x = (T) x0; y = (T) y0; z = (T) z0;
      }

      /// Set all the elements to the same T value
      inline void SetValue(double a)
      {
        x = y = z = (T) a;
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

      inline TVector3<T>& operator +=(const TVector3<T>& u)
      {
        x += u.x; y += u.y; z += u.z; return *this;
      }

      inline TVector3<T>& operator -=(const TVector3<T>& u)
      {
        x -= u.x; y -= u.y; z -= u.z; return *this;
      }

      inline TVector3<T> operator +(const TVector3<T>& u) const
      {
        return TVector3<T>(x + u.x, y + u.y, z + u.z);
      }

      inline TVector3<T> operator -(const TVector3<T>& u) const
      {
        return TVector3<T>(x - u.x, y - u.y, z - u.z);
      }

      inline TVector3<T>& operator *=(const double d)
      {
        x = (T) (x * d); y = (T) (y * d); z = (T) (z * d);return *this;
      }

      /// Vector scaling (this vector is not modified)
      inline TVector3<T> MultVec(const TVector3<T>& u) const
      {
        return TVector3<T>(x * u.x, y * u.y, z * u.z);
      }

      /// Vector-by vector division (this vector is not modified)
      inline TVector3<T> DivVec(const TVector3<T>& u) const
      {
        ASSERT(!Math3<T>::NearZero(u));
        return TVector3<T>(x / u.x, y / u.y, z / u.z);
      }


      inline TVector3<T>& operator /=(const double d)
      {
        ASSERT(d != (T) 0.0);

        x = (T) (x / d);
        y = (T) (y / d);
        z = (T) (z / d);

        return *this;
      }


      inline TVector3<T> operator *(const double d) const
      {
        return TVector3<T>(x * d, y * d, z * d);
      }

      inline TVector3<T> operator /(const double d) const
      {
        ASSERT(d != (T) 0);
        return TVector3<T>(x / d, y / d, z / d);
      }

      //*********************************************************
      inline TVector3<T> operator /(const TVector3<T> v) const
      {
        TVector3<T> v1;

        if (v.x != 0.0)
          v1.x = x / v.x;
        else
          v1.x = x;
        if (v.y != 0.0)
          v1.y = y / v.y;
        else
          v1.y = y;
        if (v.z != 0.0)
          v1.z = z / v.z;
        else
          v1.z = z;

        return v1;
      }
      //*********************************************************

      /// dot product
      inline double operator*(const TVector3<T>& rhs) const
      {
        return DotProduct(rhs);
      }

      /// cross product
      inline TVector3<T> operator^(const TVector3<T>& rhs) const
      {
        return CrossProduct(rhs);
      }    

      /// dot product
      inline double DotProduct(const TVector3<T>& rhs) const
      {
        return x * rhs.x + y * rhs.y + z * rhs.z;
      }

      /// cross product
      inline TVector3<T> CrossProduct(const TVector3<T>& rhs) const
      {
        return TVector3<T>(y * rhs.z - z * rhs.y,
                           z * rhs.x - x * rhs.z,
                           x * rhs.y - y * rhs.x);
      }

      /// @}

      /// @name Unary operations
      /// @{

      /// Vector (self) negation
      inline void Negate()
      {
        x = -x; y = -y; z = -z;
      }

      /// Unary negation operator
      inline TVector3<T> operator -() const
      {
        return TVector3<T>(-x, -y, -z);
      }

      /// returns normalized vector (always double)
      inline TVector3<double> operator ~() const
      {
        double len = Length();

        if (MathD::AboutZero(len))
          return TVector3<double>(0, 0, 0);
        else
          return TVector3<double>(x / len, y / len, z / len);
      };

      ///  Normalize this vector, return vector itself.
      inline TVector3<T>& Normalize()
      {
        TVector3<double> Temp = ~(*this);
        *this = TVector3<T>(Temp.x, Temp.y, Temp.z);
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
      
      /// Any unit orthogonal vector to given vector
      TVector3<T> AnyOrthogonal() const
        {
        
        int ind = MaxElementIndex();
        
        T sum = 0;
        int i;
        for (i = 0; i < 3; i++)
          {
          if (i != ind)
            sum += (*this)[i];
          }
        
        T cmax = (*this)[ind];
        
        TVector3<T> res;
        for (i = 0; i < 3; i++)
          {
          if (i == ind)
            res[i] = -sum;
          else
            res[i] = cmax;
          }
        
        return res.Normalize();
        
        }

      /// @brief Return unit orthogonal vector to given vector, lying in
      /// the half plane defined by this and @b sample vectors
      /// @warning this and @sample should not be collinear!
      TVector3<T> OrthogonalInGivenHalfplane(const TVector3<T>& sample)
        {
        TVector3<T> s = gml::CrossProduct(*this, sample);
        TVector3<T> s1 = gml::CrossProduct(s, *this);
        return s1.Normalize();
        }
      /// Clip elements of this TVector to constraints from vmin to vmax
      inline void Clip(double vmin, double vmax)
      {
        ASSERT(vmax >= vmin);

        gml::Clip(x, vmin, vmax);
        gml::Clip(y, vmin, vmax);
        gml::Clip(z, vmin, vmax);
      }



      /// Test whether the TVector is normalized
      inline bool Normalized() const
      {
        return MathD::AboutEqual(Length(), 1);
      }


      /// Squared length of vector
      inline double SqrLength() const
      {
        return x * x + y * y + z * z;
      }


      /// Return true if all components of this vector less of equal than \a u
      bool LessOrEqual(const TVector3<T>& u) const
      {
        return (x <= u.x) && (y <= u.y) && (z <= u.z);
      }

      /// Return C-norm of the vector (maximal value among coords)
      T MaxValue() const
      {
        return Max3(x, y, z);
        }
      
      /// return index of maximal element
      int MaxElementIndex() const
        {
        if ((fabs(x) >= fabs(y)) && (fabs(x) >= fabs(z)))
          return 0;
        if (fabs(y) >= fabs(z))
          return 1;
        return 2;
        }

      /** @} */

      /// Treat array of (3) elements as a TVector
      inline static const TVector3<T>& Cast(const T* u)
      {
        return *(const TVector3<T>*) u;
      }
      /// Treat array of (3) elements as a TVector
      inline static TVector3<T>& Cast(T* u)
      {
        return *(TVector3<T>*) u;
      }

      /// @name MFC, VCL, OWL - specific functions (defined only if proper defines are found)
      /// @{

#ifdef GML_USE_OWL

      inline TVector3(const TPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = 0;
      };

      inline TVector3<T>& operator =(const TPoint& p)
      {
        x = (double) p.x; y = (double) p.y; z = 0;return *this;
      };

      operator TPoint()
      {
        return TPoint((int) x, (int) y);
      };
#endif

#ifdef GML_USE_MFC
      inline TVector3(const CPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = 0;
      };
      inline TVector3(const CSize& p)
      {
        x = (T) p.cx; y = (T) p.cy; z = 0;
      };

      inline TVector3<T>& operator =(const CPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = 0; return *this;
      };
      inline TVector3<T>& operator =(const CSize& p)
      {
        x = (T) p.cx; y = (T) p.cy; z = 0; return *this;
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
      inline TVector3(const CvPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = 0;
      };
      inline TVector3 operator =(const CvPoint& p)
      {
        x = (T) p.x; y = (T) p.y; z = 0; return *this;
      };

#endif

      /// @}
  };  // class TVector3<T>

  // -----------------------------------------------------------------
  // Related template functions
  // -----------------------------------------------------------------


  /// Multiplication of scalar d by TVector u
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<T> operator *(const double d, const TVector3<T>& u)
  {
    return u * d;
  }

  /// Squared length of given vector
  /** @relates TVector3
  */
  template <class T>
  inline double SqrLength(const TVector3<T>& u)
  {
    return u.SqrLength();
  }

  /// Length of the vector
  /** @relates TVector3
  */
  template <class T>
  inline double Length(const TVector3<T>& u)
  {
    return u.Length();
  }

  /// Dot product
  /** @relates TVector3
  */
  template <class T>
  inline double DotProduct(const TVector3<T>& v1, const TVector3<T>& v2)
  {
    return v1 * v2;
  }


  /// Cross product
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<T> CrossProduct(const TVector3<T>& v1, const TVector3<T>& v2)
  {
    return v1 ^ v2;
  }

  /// cos between two vectors
  /** @relates TVector3
  */

  template <class T>
  inline double Cos(const TVector3<T>& a, const TVector3<T>& b)
  {
    ASSERT(!MathD::AboutZero(SqrLength(a)) && !MathD::AboutZero(SqrLength(b)));
    return Clipped((a * b) / sqrt(SqrLength(a) * SqrLength(b)), -1, 1);
  }


  /// sin between two vectors
  /** @relates TVector3
  */
  template <class T>
  inline double Sin(const TVector3<T>& a, const TVector3<T>& b)
  {
    ASSERT(!MathD::AboutZero(SqrLength(a)) && !MathD::AboutZero(SqrLength(b)));
    return Clipped(fabs(a ^ b) / sqrt((SqrLength(a) * SqrLength(b))), 0, 1);
  }


  /// Convert TVector3<T_FROM> to TVector3<T_TO>
  /** @relates TVector3
  */
  template <class T_FROM, class T_TO>
  inline TVector3<T_TO> Conv(const TVector3<T_FROM>& u)
  {
    return TVector3<T_TO>(u.x, u.y, u.z);
  }


  /// Convert TVector3<T> to TVector3<float>
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<float> ConvF(const TVector3<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TVector3<T> to TVector3<double>
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<double> ConvD(const TVector3<T>& u)
  {
    return Conv<T, double>(u);
  }

  /// Convert TVector3<T> to TVector3<int>
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<int> ConvI(const TVector3<T>& u)
  {
    return Conv<T, int>(u);
  }

  /// Convert TVector3<T> to TVector3<int>
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<short> ConvS(const TVector3<T>& u)
  {
    return Conv<T, short>(u);
  }

  /// Convert TVector3<T> to TVector3<int>
  /** @relates TVector3
  */
  template <class T>
  inline TVector3<unsigned char> ConvUB(const TVector3<T>& u)
  {
    return Conv<T, unsigned char>(u);
  }




  /// Comparison of 2D vectors with a tolerance
  /** @param T - some REAL type (float, double)
    *
    */
  template <class T>
  class Math3 : public Math<T>
  {
    public:

      inline static bool AboutZero(const TVector3<T>& v,
                                   const double tolerance)
      {
        return Math<T>::AboutZero(v.x, tolerance) &&
               Math<T>::AboutZero(v.y,
                                  tolerance) &&
               Math<T>::AboutZero(v.z,
                                  tolerance);
      }
      inline static bool AboutZero(const TVector3<T>& v)
      {
        return AboutZero(v, TOLERANCE);
      }

      inline static bool NearZero(const TVector3<T>& v)
      {
        return AboutZero(v, EPSILON);
      }

      inline static bool AboutEqual(const TVector3<T>& v1,
                                    const TVector3<T>& v2,
                                    const double tolerance)
      {
        return AboutZero(v1 - v2, tolerance);
      }

      inline static bool AboutEqual(const TVector3<T>& v1,
                                    const TVector3<T>& v2)
      {
        return AboutZero(v1 - v2, TOLERANCE);
      }

      inline static bool NearEqual(const TVector3<T>& v1,
                                   const TVector3<T>& v2)
      {
        return AboutZero(v1 - v2, EPSILON);
      }
  };  // class Math2<T>

  // ----------------------------------------------------
  //             PREDEFINED TYPES
  // ----------------------------------------------------

  typedef TVector3<short> Vector3s;
  typedef TVector3<int> Vector3i;
  typedef TVector3<unsigned char> Vector3ub;
  typedef TVector3<float> Vector3f;
  typedef TVector3<double> Vector3d;

  typedef Math3<float> Math3f;
  typedef Math3<double> Math3d;

  /* @} */

  /* @} */
}

#endif