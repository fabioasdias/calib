#ifndef _GMLRAY3_H_
#define _GMLRAY3_H_

// own includes
#include "gmlvector3.h"
#include "gmlmatrix4.h"

namespace gml
  {
  
  /** @addtogroup Math3
  * @{
  */
  
  /**
  
    @class Ray3
    
    @brief 3D Geometric ray
      
  **/
  
  class Ray3
    {
    public:
      
      /// Default constructor
      Ray3()
        { }
      
      /// Constructor, initialize with the origin and direction of the ray
      Ray3(const gml::Vector3d& start, const gml::Vector3d& dir)
        : m_start(start), m_dir(dir)
        { }
      
      /// Set ray's attributes from start and end point
      void FromTwoPoints(const gml::Vector3d& start, const gml::Vector3d& end)
        {
        m_start = start;
        m_dir = (end - start).Normalize();
        }

      /// Set ray's attributes
      void SetValue(const gml::Vector3d& start, const gml::Vector3d& dir)
        {
        m_start = start;
        m_dir = dir;
        }
      
      /// Return ray direction
      const gml::Vector3d& GetDir() const
        { return m_dir; }
      
      /// Return ray origin
      const gml::Vector3d& GetStart() const
        { return m_start; }
      
      /// Return position on the ray at given time
      gml::Vector3d GetRayPos(double t1) const
        { return m_start + m_dir * t1;}
      
      /// Return ray, transformed by given matrix
      inline void GetTransformedRay(const gml::Matrix4x4d& tm, gml::Ray3& out_ray) const;
      
    private:
      
      /// Ray start
      gml::Vector3d m_start;
      /// Ray direction
      gml::Vector3d m_dir;
    };
  
  //////////////////////////////////////////////////////////////////////////////
  ///
  inline void Ray3::GetTransformedRay(const gml::Matrix4x4d& tm, Ray3& out_ray) const
    {
    tm.MultMatrixVec3(m_start, out_ray.m_start);
    tm.MultMatrixVec3(m_dir, out_ray.m_dir);
    }
  
  /* @} */
  
  } 

#endif