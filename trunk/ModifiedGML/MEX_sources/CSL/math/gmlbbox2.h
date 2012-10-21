//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlbbox2.h,v 1.22 2004/10/13 07:56:37 jcd Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef GMLBBOX2_H_INCLUDED
#define GMLBBOX2_H_INCLUDED

// This definition should correct the problem with WIINDOWS.H MIN/MAX macros

#include "gmlvector2.h"
#include <limits>

/** @file gmlbbox2.h
 *  @brief A class for 2D boundary box (BBox2) definition
 *
 */

namespace gml
{
  /** @addtogroup Math2
   * @{
   */

  /// A template class for 2D boundary box
  template <class T>
  class BBox2
  {
    public:

      TVector2<T> vmin; ///< Minimal boundary
      TVector2<T> vmax; ///< Maximal boundary

    public:

      /// @name  Constructors
      /// @{

      /// no initialization
      inline BBox2()
      {
/*#ifdef max
#undef max
#endif
#ifdef min
#undef min
#endif*/
        // FIXME
        // The problem here is that minimum float and double are >= 0
        // Warning - this code seems to make a workaround, but be careful...
        if (std::numeric_limits<T>::has_infinity)
        {
          vmin = TVector2<T>(std::numeric_limits<T>::infinity());
          vmax = TVector2<T>(-std::numeric_limits<T>::infinity());
        }
        else
        {
          vmin = TVector2<T>(std::numeric_limits<T>::max());
          vmax = TVector2<T>(std::numeric_limits<T>::min());
        }
      }

      /// from point
      inline BBox2(const TVector2<T>& point)
      {
        vmin = vmax = point;
      }

      /// from two points
      inline BBox2(const TVector2<T>& point1, const TVector2<T>& point2)
      {
        vmin = point1; vmax = point2;
      }

      /// @}


      /// @name Comparison operators and methods
      /// @{

      /// Test for validity
      inline bool NotEmpty() const
      {
        return (vmin.x <= vmax.x) && (vmin.y <= vmax.y);
      }

      /// If the box is actually a dot
      inline bool IsDot() const
      {
        return Math2<T>::NearEqual(vmin, vmax);
      }

      /// Test for point inclusion
      inline bool Includes(const TVector2<T>& point) const
      {
        return (vmin.LessOrEqual(point)) && (point.LessOrEqual(vmax));
      }
      /// Test for box inclusion
      inline bool Includes(const BBox2<T>& box) const
      {
        return (vmin.LessOrEqual(box.vmin)) && (box.vmax.LessOrEqual(vmax));
      }

      /// Test for intersection
      inline bool Intersects(const BBox2<T>& box) const
      {
        return (vmin.LessOrEqual(box.vmax)) && (box.vmin.LessOrEqual(vmax));
      }

      /// @}

      /// @name Miscellanious methods
      /// @{

      /// Expand the box to include the given point
      inline void Include(const TVector2<T>& point)
      {
        if (point.x < vmin.x)
          vmin.x = point.x;
        if (vmax.x < point.x)
          vmax.x = point.x;
        if (point.y < vmin.y)
          vmin.y = point.y;
        if (vmax.y < point.y)
          vmax.y = point.y;
      }

      /// Expand the box to include the given points
      inline void Include(const TVector2<T>* points, int npoints)
      {
        for (int i = 0; i < npoints; ++i)
        {
          Include(*(points++));
        }
      }

      /// Expand the box to include the given box
      inline void Include(const BBox2<T>& box)
      {
        if (vmin.x > box.vmin.x)
          vmin.x = box.vmin.x;
        if (vmax.x < box.vmax.x)
          vmax.x = box.vmax.x;
        if (vmin.y > box.vmin.y)
          vmin.y = box.vmin.y;
        if (vmax.y < box.vmax.y)
          vmax.y = box.vmax.y;
      }

      /// Expand the box to include the given boxes
      inline void Include(const BBox2<T>* bboxes, int nbboxes)
      {
        for (int i = 0; i < nbboxes; ++i)
        {
          Include(*(bboxes++));
        }
      }

      /// Intersect with given box
      inline void Intersect(const BBox2<T>& box)
      {
        if (vmin.x < box.vmin.x)
          vmin.x = box.vmin.x;
        if (vmax.x > box.vmax.x)
          vmax.x = box.vmax.x;
        if (vmin.y < box.vmin.y)
          vmin.y = box.vmin.y;
        if (vmax.y > box.vmax.y)
          vmax.y = box.vmax.y;
      }

      /// Set box sizes
      inline void SetRect(const T& in_Left,
                          const T& in_Top,
                          const T& in_Right,
                          const T& in_Bottom)
      {
        vmin.x = in_Left;
        vmax.x = in_Right;
        vmin.y = in_Top;
        vmax.y = in_Bottom;
      }

      /// Adjust size by given value (give < 0 to deflate)
      inline void ExpandBy(const T& in_Value)
      {
        vmin.x -= in_Value;
        vmax.x += in_Value;
        vmin.y -= in_Value;
        vmax.y += in_Value;
      }

      /// Adjust sizes by given value (give < 0 to deflate)
      inline void ExpandBy(const T& in_HValue, const T& in_VValue)
      {
        vmin.x -= in_HValue;
        vmax.x += in_HValue;

        vmin.y -= in_VValue;
        vmax.y += in_VValue;
      }


      /// Translate the box to given  vector
      inline void Translate(const TVector2<T>& vct)
      {
        vmin += vct; vmax += vct;
      }

      /// Returns box translated by \a vct
      inline BBox2<T> Translated(const TVector2<T>& vct) const
      {
        return BBox2<T>(vmin + vct, vmax + vct);
      }

      /// Return diagonal
      inline TVector2<T> Diag() const
      {
        return vmax - vmin;
      }

      /// Return Center of this box
      inline TVector2<T> Center() const
      {
        return (vmax + vmin) * 0.5;
      }

      /// Return value of the volume
      inline double Volume() const
      {
        return (vmax.x - vmin.x) * (vmax.y - vmin.y);
      }

      /// Return value of width
      inline double Width() const
      {
        return (vmax.x - vmin.x);
      }

      /// Return value of height
      inline double Height() const
      {
        return (vmax.y - vmin.y);
      }

#ifdef GML_USE_MFC
      inline BBox2(const tagRECT& p)
      {
        vmin.x = (T) p.left; vmax.x = (T) p.right;
        vmin.y = (T) p.top; vmax.y = (T) p.bottom;
      };

      inline BBox2<T>& operator =(const tagRECT& p)
      {
        vmin.x = (T) p.left; vmax.x = (T) p.right;
        vmin.y = (T) p.top; vmax.y = (T) p.bottom;
      };

      operator tagRECT()
      {
        RECT TempRect;
        TempRect.top = (int) vmin.y; TempRect.left = (int) vmin.x;
        TempRect.bottom = (int) vmax.y; TempRect.right = (int) vmax.x;
        return TempRect;
      };
#endif

#ifdef GML_USE_INTEL_LIB
      operator CvRect()
      {
        CvRect TempRect;
        TempRect.x = (int) vmin.x; TempRect.width = (int) Width();
        TempRect.y = (int) vmin.y; TempRect.height = (int) Height();
        return TempRect;
      };
#endif


      /// @}
  };  // class BBox2<T>

  typedef BBox2<double> BBox2d;
  typedef BBox2<float> BBox2f;
  typedef BBox2<int> BBox2i;
  /** @} */
} // namespace gml
#endif
