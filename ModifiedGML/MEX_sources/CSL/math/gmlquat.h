//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlquat.h,v 1.12 2005/03/22 18:38:51 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

/** @file gmlquat.h
 *  @brief Definition of TQuaternion template class
 */

#ifndef _GMLQUAT_H_
#define _GMLQUAT_H_

#include "gmlmatrix4.h"


namespace gml
{
  /** @addtogroup Math
  *  @{
  */

  const int QUATERNION_NORMALIZATION_THRESHOLD = 64;

  /// quaternion template 
  template<class T>
  class TQuaternion
    {
    public:

      TQuaternion()
      {
        *this = Identity();
      }

      TQuaternion(const T v[4])
      {
        SetValue(v);
      }


      TQuaternion(T q0, T q1, T q2, T q3)
      {
        SetValue(q0, q1, q2, q3);
      }


      TQuaternion(const TMatrix4x4<T>& m)
      {
        SetValue(m);
      }


      TQuaternion(const TVector3<T>& axis, T radians)
      {
        SetValue(axis, radians);
      }


      TQuaternion(const TVector3<T>& rotateFrom, const TVector3<T>& rotateTo)
      {
        SetValue(rotateFrom, rotateTo);
      }

      TQuaternion(const TVector3<T>& from_look,
                  const TVector3<T>& from_up,
                  const TVector3<T>& to_look,
                  const TVector3<T>& to_up)
      {
        SetValue(from_look, from_up, to_look, to_up);
      }

      const T* GetValue() const
      {
        return  &q[0];
      }

      void GetValue(T& q0, T& q1, T& q2, T& q3) const
      {
        q0 = q[0];
        q1 = q[1];
        q2 = q[2];
        q3 = q[3];
      }

      TQuaternion& SetValue(T q0, T q1, T q2, T q3)
      {
        q[0] = q0;
        q[1] = q1;
        q[2] = q2;
        q[3] = q3;
        counter = 0;
        return *this;
      }

      void GetValue(TVector3<T>& euler)
      {
        double sqw = q[3]*q[3];    
        double sqx = q[0]*q[0];    
        double sqy = q[1]*q[1];    
        double sqz = q[2]*q[2];

        T& heading =  euler.y = 0;
        T& attitude =  euler.z = 0;
        T& bank =  euler.x = 0;
        
        double unit = sqx + sqy + sqz + sqw; // if normalised is one, otherwise is correction factor
        if (q[0]*q[1] + q[2]*q[3] > 0.449*unit) 
        { // singularity at north pole
          heading = 2 * atan2(q[0],q[3]);
          attitude = PI/2;
          bank = 0;
          return;
        }	
        if (q[0]*q[1] + q[2]*q[3] < -0.449*unit)
        { // singularity at south pole
          heading = -2 * atan2(q[0],q[3]);
          attitude = PI/2;
          bank = 0;
          return;
        }    
        
        heading = atan2(2*q[1]*q[3]-2*q[0]*q[2] , sqx - sqy - sqz + sqw);
        attitude = asin((2*q[0]*q[1] + 2*q[2]*q[3])/unit);
        bank = atan2(2*q[0]*q[3]-2*q[1]*q[2] , -sqx + sqy - sqz + sqw);
          
      };
      
      void GetValue(TVector3<T>& axis, T& radians) const
      {
        radians = T(acos(q[3]) * (T) 2.0);
        if (radians == (T) 0.0)
          axis = TVector3<T>(0.0, 0.0, 1.0);
        else
        {
          axis[0] = q[0];
          axis[1] = q[1];
          axis[2] = q[2];
          axis.Normalize();
        }
      }

      void GetValue(TMatrix4x4<T>& m) const
      {
        T s, xs, ys, zs, wx, wy, wz, xx, xy, xz, yy, yz, zz;

        T norm = q[0] * q[0] + q[1] * q[1] + q[2] * q[2] + q[3] * q[3];

        s = (Math<T>::AboutEqual(norm, (T) 0.0)) ? (T) 0.0 : ((T) 2.0 / norm);

        xs = q[0] * s;
        ys = q[1] * s;
        zs = q[2] * s;

        wx = q[3] * xs;
        wy = q[3] * ys;
        wz = q[3] * zs;

        xx = q[0] * xs;
        xy = q[0] * ys;
        xz = q[0] * zs;

        yy = q[1] * ys;
        yz = q[1] * zs;
        zz = q[2] * zs;

        m(0, 0) = T((T) 1.0 - (yy + zz));
        m(0, 1) = T(xy - wz);
        m(0, 2) = T(xz + wy);

        m(1, 0) = T(xy + wz);
        m(1, 1) = T((T) 1.0 - (xx + zz));
        m(1, 2) = T(yz - wx);

        m(2, 0) = T(xz - wy);        
        m(2, 1) = T(yz + wx);        
        m(2, 2) = T((T) 1.0 - (xx + yy));

        m(3, 0) = m(3, 1) = m(3, 2) = m(0, 3) = m(1, 3) = m(2, 3) = (T) 0.0;
        m(3, 3) = (T) 1.0;
      }

      TQuaternion& SetValue(const T* qp)
      {
        memcpy(q, qp, sizeof(T) * 4);

        counter = 0;
        return *this;
      }

      TQuaternion& SetValue(const TMatrix4x4<T>& m)
      {

        T tr = 1 + m[0] + m[5] + m[10];

        T s;

        T x;
        T y;
        T z;
        T w;


        if (tr > (T) 0.0)
        {
          s = sqrt(tr) * 2;

          x = (m[9] - m[6]) / s;
          y = (m[2] - m[8]) / s;
          z = (m[4] - m[1]) / s;
          w = 0.25 * s;

        }
        else
        {
          if (m[0] > m[5] && m[0] > m[10])
          {
            // Column 0: 
           s = sqrt(1.0 + m[0] - m[5] - m[10]) * 2;
           x = 0.25 * s;
           y = (m[4] + m[1]) / s;
           z = (m[2] + m[8]) / s;
           w = (m[9] - m[6]) / s;
          }
          else if (m[5] > m[10])
          {
            // Column 1: 
            s = sqrt(1.0 + m[5] - m[0] - m[10]) * 2;
            x = (m[4] + m[1]) / s;
            y = 0.25 * s;
            z = (m[9] + m[6]) / s;
            w = (m[2] - m[8]) / s;
          }
          else
          {
            // Column 2:
            s = sqrt(1.0 + m[10] - m[0] - m[5]) * 2;
            x = (m[2] + m[8]) / s;
            y = (m[9] + m[6]) / s;
            z = 0.25 * s;
            w= (m[4] - m[1]) / s;
          }
        };

        q[0] = x;
        q[1] = y;
        q[2] = z;
        q[3] = w;

        counter = 0;
        return *this;
      }

      TQuaternion& SetValue(const TVector3<T>& axis, T theta)
      {
        T sqnorm = axis.SqrLength();

        if (Math<T>::NearZero(sqnorm))
        {
          // axis too small.
          *this = Identity();
        }
        else
        {
          theta *= T(0.5);
          T sin_theta = T(sin(theta));

          if (!Math<T>::AboutEqual(sqnorm, (T) 1.0))
            sin_theta /= T(sqrt(sqnorm));
          x = sin_theta * axis[0];
          y = sin_theta * axis[1];
          z = sin_theta * axis[2];
          w = T(cos(theta));
        }
        return *this;
      }

      TQuaternion& SetValue(const TVector3<T>& rotateFrom,
                            const TVector3<T>& rotateTo)
      {
        TVector3<T> p1, p2;
        T alpha;

        p1 = rotateFrom; 
        p1.Normalize();
        p2 = rotateTo;  
        p2.Normalize();

        alpha = p1 * p2;

        if (Math<T>::AboutEqual(alpha, (T) 1.0))
        {
          *this = Identity(); 
          return *this;
        }

        // ensures that the anti-parallel case leads to a positive dot
        if (Math<T>::AboutEqual(alpha, -(T) 1.0))
        {
          TVector3<T> v;

          if (p1[0] != p1[1] || p1[0] != p1[2])
            v = TVector3<T>(p1[1], p1[2], p1[0]);
          else
            v = TVector3<T>(-p1[0], p1[1], p1[2]);

          v -= p1 * DotProduct(p1, v);
          v.Normalize();

          SetValue(v, (T) PI);
          return *this;
        }

        p1 = CrossProduct(p1, p2);  
        p1.Normalize();
        SetValue(p1, T(acos(alpha)));

        counter = 0;
        return *this;
      }

      TQuaternion& SetValue(const TVector3<T>& from_look,
                            const TVector3<T>& from_up,
                            const TVector3<T>& to_look,
                            const TVector3<T>& to_up)
      {
        TQuaternion r_look = TQuaternion(from_look, to_look);

        TVector3<T> rotated_from_up(from_up);
        r_look.MultVec(rotated_from_up);

        TQuaternion r_twist = TQuaternion(rotated_from_up, to_up);

        *this = r_twist;
        *this *= r_look;
        return *this;
      }

      TQuaternion& operator *=(const TQuaternion& qr)
      {
        TQuaternion ql(*this);

        w = ql.w * qr.w - ql.x * qr.x - ql.y * qr.y - ql.z * qr.z;
        x = ql.w * qr.x + ql.x * qr.w + ql.y * qr.z - ql.z * qr.y;
        y = ql.w * qr.y + ql.y * qr.w + ql.z * qr.x - ql.x * qr.z;
        z = ql.w * qr.z + ql.z * qr.w + ql.x * qr.y - ql.y * qr.x;

        counter += qr.counter;
        counter++;
        CounterNormalize();
        return *this;
      }

      void Normalize()
      {
        T rnorm = (T) 1.0 / T(sqrt(w* w + x* x + y* y + z* z));
        if (Math<T>::AboutEqual(rnorm, (T) 0.0))
          return;
        x *= rnorm;
        y *= rnorm;
        z *= rnorm;
        w *= rnorm;
        counter = 0;
      }

      friend bool operator ==(const TQuaternion& q1, const TQuaternion& q2);      

      friend bool operator !=(const TQuaternion& q1, const TQuaternion& q2);

      friend TQuaternion operator *(const TQuaternion& q1, const TQuaternion& q2);

      bool Equals(const TQuaternion& r, T tolerance) const
      {
        T t;

        t = ((q[0] - r.q[0]) * (q[0] - r.q[0]) +
             (q[1] - r.q[1]) * (q[1] - r.q[1]) +
             (q[2] - r.q[2]) * (q[2] - r.q[2]) +
             (q[3] - r.q[3]) * (q[3] - r.q[3]));
        if (!Math<T>::NearZero(t))
          return false;
        return 1;
      }

      TQuaternion& Conjugate()
      {
        q[0] *= -(T) 1.0;
        q[1] *= -(T) 1.0;
        q[2] *= -(T) 1.0;
        return *this;
      }

      TQuaternion& Invert()
      {
        return Conjugate();
      }

      TQuaternion Inverse() const
      {
        TQuaternion r = *this;
        return r.Invert();
      }

      //
      // TQuaternion multiplication with cartesian vector
      // v' = q*v*q(star)
      //
      void MultVec(const TVector3<T>& src, TVector3<T>& dst) const
      {
        T v_coef = w* w - x* x - y* y - z* z;                     
        T u_coef = (T) 2.0 * (src[0] * x + src[1] * y + src[2] * z);  
        T c_coef = (T) 2.0 * w;                                       

        dst[0] = v_coef * src[0] +
                 u_coef * x +
                 c_coef * (y * src[2] - z * src[1]);
        dst[1] = v_coef * src[1] +
                 u_coef * y +
                 c_coef * (z * src[0] - x * src[2]);
        dst[2] = v_coef * src[2] +
                 u_coef * z +
                 c_coef * (x * src[1] - y * src[0]);
      }

      void MultVec(TVector3<T>& src_and_dst) const
      {
        MultVec(TVector3<T>(src_and_dst), src_and_dst);
      }

      void ScaleAngle(T scaleFactor)
      {
        TVector3<T> axis;
        T radians;

        GetValue(axis, radians);
        radians *= scaleFactor;
        SetValue(axis, radians);
      }

      static TQuaternion Slerp(const TQuaternion& p,
                               const TQuaternion& q,
                               T alpha)
      {
        TQuaternion r;

        T cos_omega = p.x* q.x + p.y* q.y + p.z* q.z + p.w* q.w;
        // if B is on opposite hemisphere from A, use -B instead

        if (cos_omega > 1) // possible due to rounding/precision errors
          cos_omega = 1;

        if (cos_omega < -1) // possible due to rounding/precision errors
          cos_omega = -1;

        int bflip;
        if ((bflip = (cos_omega < (T) 0.0)))
          cos_omega = -cos_omega;

        // complementary interpolation parameter
        T beta = (T) 1.0 - alpha;     

        if (Math<T>::AboutEqual(cos_omega, (T) 1.0))
          return p;

        T omega = T(acos(cos_omega));
        T one_over_sin_omega = (T) 1.0 / T(sin(omega));

        beta = T(sin(omega * beta) * one_over_sin_omega);
        alpha = T(sin(omega * alpha) * one_over_sin_omega);

        if (bflip)
          alpha = -alpha;

        r.x = beta * p.q[0] + alpha * q.q[0];
        r.y = beta * p.q[1] + alpha * q.q[1];
        r.z = beta * p.q[2] + alpha * q.q[2];
        r.w = beta * p.q[3] + alpha * q.q[3];
        return r;
      }

      static TQuaternion Identity()
      {
        static TQuaternion ident(0.0, 0.0, 0.0, (T)1.0);
        return ident;
      }

      T& operator [](int i)
      {
        ASSERT(i < 4);
        return q[i];
      }

      const T& operator [](int i) const
      {
        ASSERT(i < 4);
        return q[i];
      }

    protected:

      void CounterNormalize()
      {
        if (counter > QUATERNION_NORMALIZATION_THRESHOLD)
          Normalize();
      }

      union
        {
          struct
            {
              T q[4];
            };
          struct
            {
              T x;
              T y;
              T z;
              T w;
            };
        };

      // renormalization counter
      unsigned char counter;
    };

  template<class T>
  inline
  bool operator ==(const TQuaternion<T>& q1, const TQuaternion<T>& q2)
  {
    return (Math<T>::NearEqual(q1.x, q2.x) &&
            Math<T>::NearEqual(q1.y, q2.y) &&
            Math<T>::NearEqual(q1.z,
                               q2.z) &&
            Math<T>::NearEqual(q1.w,
                               q2.w));
  }

  template<class T>
  inline
  bool operator !=(const TQuaternion<T>& q1, const TQuaternion<T>& q2)
  {
    return !(q1 == q2);
  }

  template<class T>
  inline
  TQuaternion<T> operator *(const TQuaternion<T>& q1, const TQuaternion<T>& q2)
  {
    TQuaternion<T> r(q1); 
    r *= q2; 
    return r;
  }

  /// Convert TQuaternion<T_FROM> to TQuaternion<T_TO>
  /** @relates TQuaternion
  */
  template<class T_FROM, class T_TO>
  inline TQuaternion<T_TO> Conv(const TQuaternion<T_FROM>& u)
  {
    return TQuaternion<T_TO>(u[0], u[1], u[2], u[3]);
  }


  /// Convert TQuaternion<T> to TQuaternion<float>
  /** @relates TQuaternion
  */
  template<class T>
  inline TQuaternion<float> ConvF(const TQuaternion<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TQuaternion<T> to TQuaternion<double>
  /** @relates TQuaternion
  */
  template<class T>
  inline TQuaternion<double> ConvD(const TQuaternion<T>& u)
  {
    return Conv<T, double>(u);
  }


  typedef TQuaternion<float> Quaternionf;
  typedef TQuaternion<double> Quaterniond;
  /* @} */
}


#endif  