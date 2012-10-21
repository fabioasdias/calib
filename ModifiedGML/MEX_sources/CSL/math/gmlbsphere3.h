//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlbsphere3.h,v 1.6 2004/01/13 17:38:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef GMLBSPHERE3_H_INCLUDED
#define GMLBSPHERE3_H_INCLUDED

#include "gmlmath.h"
#include "gmlbbox3.h"

/** @file gmlbsphere3.h
*  @brief defines template class BSphere33<T>
*/

namespace gml
{
  /** @addtogroup Math3
   * @{
   */

  /// Template class for 3D bounding sphere
  /** 
   * @param T - template type of TVector elements
   * @warning Use it with some SIGNED integral type, or a real type
   */
  template <class T>
  class BSphere3
  {
    public:

      /// @name Constructors
      /// @{

      ///  default constructor
      inline BSphere3()
      {
      }

      ///  initialize class members by defined values
      BSphere3(const TVector3<T>& center0, const double radius0 = 0)
      {
        center = center0;
        radius = (T) radius0;
      }

      ///  construct sphere from given bounding box
      BSphere3(const BBox3<T>& bbox)
      {
        center = bbox.Center();
        radius = (float) (0.5 * (bbox.Diag()).Length());
      }

      /// @}


      /// @name Miscellanious methods
      /// @{

      ///  Expand the sphere to include given point
      void Include(const TVector3<T>& point)
      {
        double length;
        TVector3<T> u(point - center);

        //  point is inside of sphere
        if ((length = u.SqrLength()) <= radius * radius)
          return;
        length = (float) sqrt(length);

        //  new radius of sphere
        radius = (float) (0.5 * (radius + length));

        //  new center of sphere
        center = point + u * (radius / length);
      }

      ///  Expand the sphere to include given sphere
      void Include(const BSphere3& bsphere)
      {
        double length;
        TVector3<T> u(-center + bsphere.center); // ???

        //  bsphere is inside of sphere
        if ((length = u.Length()) + bsphere.radius > radius)
        {
          //  sphere is inside of bsphere
          if (length + radius <= bsphere.radius)
            *this = bsphere;
          else
          {
            //  new radius of sphere
            radius = (float) (0.5 * (radius + bsphere.radius + length));

            //  new center of sphere
            center = bsphere.center +
                     u * ((bsphere.radius - radius) / length);
          }
        }
      }


    public:
      T radius; ///< Radius of the sphere
      TVector3<T> center; ///< Center point
  };

  typedef BSphere3<float> BSphere3f;
  typedef BSphere3<double> BSphere3d;

  /// @}
}
#endif
