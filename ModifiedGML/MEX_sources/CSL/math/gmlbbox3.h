//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlbbox3.h,v 1.11 2004/01/13 17:38:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef GMLBBOX3_H_INCLUDED
#define GMLBBOX3_H_INCLUDED

#include "gmlvector3.h"
#include <limits>

/** @file gmlbbox3.h
 *  @brief A class for 2D boundary box (BBox3) definition
 * 
 */

namespace gml
{
  /** @addtogroup Math3
   * @{
   */

  /// A template class for 2D boundary box
  template <class T>
  class BBox3
  {
    public:

      TVector3<T> vmin; ///< Minimal boundary
      TVector3<T> vmax; ///< Maximal boundary

    public:

      /// @name  Constructors
      /// @{

      /// no initialization
      inline BBox3()
      {
#undef min
#undef max
        // FIXME
        // The problem here is that minimum float and double are >= 0
        // Warning - this code seems to make a workaround, but be careful...
        if (std::numeric_limits<T>::has_infinity)
        {
          vmin = TVector3<T>(std::numeric_limits<T>::infinity());
          vmax = TVector3<T>(-std::numeric_limits<T>::infinity());
        }
        else
        {
          vmin = TVector3<T>(std::numeric_limits<T>::max());
          vmax = TVector3<T>(std::numeric_limits<T>::min());
        }
      }

      /// from point
      inline BBox3(const TVector3<T>& point)
      {
        vmin = vmax = point;
      }

      /// from two points
      inline BBox3(const TVector3<T>& point1, const TVector3<T>& point2)
      {
        vmin = point1; vmax = point2;
      }

      /// @}           


      /// @name Comparison operators and methods
      /// @{

      /// Test for validity
      inline bool NotEmpty() const
      {
        return (vmin.x <= vmax.x) && (vmin.y <= vmax.y) && (vmin.z <= vmax.z);
      }

      /// If the box is actually a dot
      inline bool IsDot() const
      {
        return Math3<T>::NearEqual(vmin, vmax);
      }

      /// Test for point inclusion
      inline bool Includes(const TVector3<T>& point) const
      {
        return (vmin.LessOrEqual(point)) && (point.LessOrEqual(vmax));
      }
      /// Test for box inclusion
      inline bool Includes(const BBox3<T>& box) const
      {
        return (vmin.LessOrEqual(box.vmin)) && (box.vmax.LessOrEqual(vmax));
      }

      /// Test for intersection
      inline bool Intersects(const BBox3<T>& box) const
      {
        return (vmin.LessOrEqual(box.vmax)) && (box.vmin.LessOrEqual(vmax));
      }

      /// @}

      /// @name Miscellanious methods
      /// @{

      /// Expand the box to include the given point
      inline void Include(const TVector3<T>& point)
      {
        if (point.x < vmin.x)
          vmin.x = point.x;
        if (vmax.x < point.x)
          vmax.x = point.x;
        if (point.y < vmin.y)
          vmin.y = point.y;
        if (vmax.y < point.y)
          vmax.y = point.y;
        if (point.z < vmin.z)
          vmin.z = point.z;
        if (vmax.z < point.z)
          vmax.z = point.z;
      }

      /// Expand the box to include the given points
      inline void Include(const TVector3<T>* points, int npoints)
      {
        for (int i = 0; i < npoints; ++i)
        {
          Include(*(points++));
        }
      }

      /// Expand the box to include the given box
      inline void Include(const BBox3<T>& box)
      {
        if (vmin.x > box.vmin.x)
          vmin.x = box.vmin.x;
        if (vmax.x < box.vmax.x)
          vmax.x = box.vmax.x;
        if (vmin.y > box.vmin.y)
          vmin.y = box.vmin.y;
        if (vmax.y < box.vmax.y)
          vmax.y = box.vmax.y;
        if (vmin.z > box.vmin.z)
          vmin.z = box.vmin.z;
        if (vmax.z < box.vmax.z)
          vmax.z = box.vmax.z;
      }

      /// Expand the box to include the given boxes
      inline void Include(const BBox3<T>* bboxes, int nbboxes)
      {
        for (int i = 0; i < nbboxes; ++i)
        {
          Include(*(bboxes++));
        }
      }

      /// Intersect with given box
      inline void Intersect(const BBox3<T>& box)
      {
        if (vmin.x < box.vmin.x)
          vmin.x = box.vmin.x;
        if (vmax.x > box.vmax.x)
          vmax.x = box.vmax.x;
        if (vmin.y < box.vmin.y)
          vmin.y = box.vmin.y;
        if (vmax.y > box.vmax.y)
          vmax.y = box.vmax.y;
        if (vmin.z < box.vmin.z)
          vmin.z = box.vmin.z;
        if (vmax.z > box.vmax.z)
          vmax.z = box.vmax.z;
      }


      /// Adjust size by given value (give < 0 to deflate)
      inline void ExpandBy(const T& in_Value)
      {
        TVector3<T> expand_vec(in_Value);
        ExpandBy(expand_vec);
      }

      /// Adjust sizes by given value (give < 0 to deflate)
      inline void ExpandBy(const TVector3<T>& expand_vec)
      {
        vmin -= expand_vec;
        vmax += expand_vec;
      }

      /// Translate the box to given  vector
      inline void Translate(const TVector3<T>& vct)
      {
        vmin += vct; vmax += vct;
      }

      /// Returns box translated by \a vct
      inline BBox3<T> Translated(const TVector3<T>& vct) const
      {
        return BBox3<T>(vmin + vct, vmax + vct);
      }

      /// Return diagonal
      inline TVector3<T> Diag() const
      {
        return vmax - vmin;
      }

      /// Return Center of this box
      inline TVector3<T> Center() const
      {
        return (vmax + vmin) / 2.0f;
      }

      /// Return value of the volume
      inline double Volume() const
      {
        return (vmax.x - vmin.x) * (vmax.y - vmin.y) * (vmax.z - vmin.z);
      }

      /// @}
  };  // class BBox3<T>

  template <class T_FROM>
  inline BBox3<double> ConvD(const BBox3<T_FROM>& u)
  {
    return BBox3<double>(ConvD(u.vmin), ConvD(u.vmax));
  }


  template <class T_FROM>
  inline BBox3<float> ConvF(const BBox3<T_FROM>& u)
  {
    return BBox3<float>(ConvF(u.vmin), ConvF(u.vmax));
  }


  typedef BBox3<double> BBox3d;
  typedef BBox3<float> BBox3f;
  typedef BBox3<int> BBox3i;
  /** @} */
} // namespace gml
#endif