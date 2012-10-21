//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlmath.h,v 1.10 2004/01/13 17:38:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLMATH_H_INCLUDED
#define _GMLMATH_H_INCLUDED

/** @file gmlmath.h
 *  @brief Common mathematic utility routines, gml::Math
 * 
 */

#include <math.h>


namespace gml
{
  /** @addtogroup Math
   * @{
   */

#ifndef PI
#define PI 3.1415926535897 
#endif

  const double RAD_TO_DEG = 57.2957795130823208767981548141052;
  const double DEG_TO_RAD = 0.0174532925199432957692369076848861;

  inline double ToDegrees(double radians)
  {
    return radians * RAD_TO_DEG;
  }
  inline double ToRadians(double degrees)
  {
    return degrees * DEG_TO_RAD;
  }

  /// Clip a value of given variable by given range for different types T
  template <class T>
  inline void Clip(T& v, const double a_min, const double a_max)
  {
    if (v < (T) a_min)
      v = (T) a_min;
    if (v > (T) a_max)
      v = (T) a_max;
  }

  /// Clip a value of given variable by given range for different types T
  template <class T>
  inline T Clipped(const T v, const double a_min, const double a_max)
  {
    if (v < (T) a_min)
      return (T) a_min;
    if (v > (T) a_max)
      return (T) a_max;
    return v;
  }


  /// Find minimal value for different type T
  template <class T>
  inline T Min(const T u, const T v)
  {
    return (u < v) ? u : v;
  }


  /// Find minimal value for different type T within three vars
  template <class T>
  inline T Min3(const T u, const T v, const T w)
  {
    return Min(u, Min(v, w));
  }

  /// Find maximal value for different type T
  template <class T>
  inline T Max(const T u, const T v)
  {
    return (u > v) ? u : v;
  }

  /// Find maximal value for different type T within three vars
  template <class T>
  inline T Max3(const T u, const T v, const T w)
  {
    return Max(u, Max(v, w));
  }


  /// A template class for precision related staff 
  /**
   * @param T is a real type like float, double
   * @note use typedefs MathD, MathF
   */
  template <class T>
  class Math
  {
    public:

      /// default tolerance (type dependent)
      static const double TOLERANCE;
      /// Maximum values for float and double types (rounded down)
      static const double MIN_VALUE;
      ///  Minimal positive values for float and double types (rounded up)
      static const double MAX_VALUE;
      /// minimum positive floating point number x such that 1.0 + x != 1.0
      static const double EPSILON;

      /// Comparisons with given tolerance
      inline static bool AboutZero(const double v, const double tolerance)
      {
        return ((-tolerance <= v) && (v <= tolerance));
      }
      inline static bool AboutZero(const double v)
      {
        return AboutZero(v, TOLERANCE);
      }

      inline static bool NearZero(const double v)
      {
        return AboutZero(v, EPSILON);
      }

      inline static bool AboutEqual(const double v1,
                                    const double v2,
                                    const double tolerance)
      {
        return AboutZero(v1 - v2, tolerance);
      }
      inline static bool AboutEqual(const double v1, const double v2)
      {
        return AboutEqual(v1, v2, TOLERANCE);
      }

      inline static bool NearEqual(const double v1, const double v2)
      {
        return AboutZero(v1 - v2, EPSILON);
      }


      /// Determine sing of value with some tolerance around zero
      inline static int SignAbout(const double v, const double tolerance)
      {
        if (v >= tolerance)
          return 1;
        if (v <= -tolerance)
          return -1;
        return 0;
      }
      inline static int SignAbout(const double v)
      {
        return SignAbout(v, TOLERANCE);
      }
      inline static int SignNear(const double v)
      {
        return SignAbout(v, EPSILON);
      }
  };  // class Math<T>

  // ----------------------------------------------------
  //             PREDEFINED TYPES
  // ----------------------------------------------------

  typedef Math<float> MathF;
  typedef Math<double> MathD;





  /** @} */
};

#endif
