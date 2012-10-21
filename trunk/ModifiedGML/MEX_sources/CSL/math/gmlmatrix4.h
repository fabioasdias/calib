//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlmatrix4.h,v 1.14 2005/01/09 10:48:03 leo Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLMATRIX4_H_INCLUDED 
#define _GMLMATRIX4_H_INCLUDED 

#include "gmlvector3.h"
#include "gmlvector4.h"
#include "gmlmatrix3.h"
/** @file gmlmatrix4.h
*  @brief Definition of TMatrix4x4 template class and utility routines
*/


namespace gml
{
  /** @addtogroup Math
  * @{
  */

  /** @addtogroup Math4x4
  *  @{
  */

  /// Template class for 4x4 matrix
  /** 
  * @param T - template type of matrix elements
  * @warning Use it with some SIGNED integral type, or a real type
    Elements are stored in column-major order (OpenGL-style) E.g.:
    <PRE>   
    a0  a4  a8  a12 
    a1  a5  a9  a13
    a2  a6  a10 a14
    a3  a7  a11 a15
    </PRE>
  */
  template <class T>
  class TMatrix4x4
  {
    public:

      /// @name Constructors
      /// @{

      /// No initialization
      TMatrix4x4()
      {
      }

      /// Initialization by diagonal element
      TMatrix4x4(T r)
      {
        SetValue(r);
      }

      /// Initialization by array of T
      TMatrix4x4(const T* m)
      {
        SetValue(m);
      }

      /// Direct initialization by components (row order)
      TMatrix4x4(T a00,
                 T a01,
                 T a02,
                 T a03,
                 T a10,
                 T a11,
                 T a12,
                 T a13,
                 T a20,
                 T a21,
                 T a22,
                 T a23,
                 T a30,
                 T a31,
                 T a32,
                 T a33)
      {
        Elem(0, 0) = a00;
        Elem(0, 1) = a01;
        Elem(0, 2) = a02;
        Elem(0, 3) = a03;

        Elem(1, 0) = a10;
        Elem(1, 1) = a11;
        Elem(1, 2) = a12;
        Elem(1, 3) = a13;

        Elem(2, 0) = a20;
        Elem(2, 1) = a21;
        Elem(2, 2) = a22;
        Elem(2, 3) = a23;

        Elem(3, 0) = a30;
        Elem(3, 1) = a31;
        Elem(3, 2) = a32;
        Elem(3, 3) = a33;
      }

      
      TMatrix4x4( const TMatrix3x3 <T> &in_Matr )
      {
      Elem(0,0) = in_Matr.Elem(0, 0);
      Elem(0,1) = in_Matr.Elem(0, 1);
      Elem(0,2) = in_Matr.Elem(0, 2);
      Elem(0,3) = 0;
      
      Elem(1,0) = in_Matr.Elem(1, 0);
      Elem(1,1) = in_Matr.Elem(1, 1);
      Elem(1,2) = in_Matr.Elem(1, 2);
      Elem(1,3) = 0;
      
      Elem(2,0) = in_Matr.Elem(2, 0);
      Elem(2,1) = in_Matr.Elem(2, 1);
      Elem(2,2) = in_Matr.Elem(2, 2);
      Elem(2,3) = 0;
      
      Elem(3,0) = 0;
      Elem(3,1) = 0;
      Elem(3,2) = 0;
      Elem(3,3) = 1;
      };


      /// @}

      /// @name Access to values
      /// @{

      /// @brief Provide access to internal contents
      /// @warning Use with care, this function is dangerous!
      T* RawArray()
      {
        return m;
      }

      /// Copy this matrix to array in DirectX-compatible style (row-major)
      void GetValueDX(T* mp)
      {
        int c = 0;
        for (int i = 0; i < 4; i++)
        {
          for (int j = 0; j < 4; j++)
          {
            mp[c++] = Elem(j, i);
          }
        }
      }

      /// Copy this matrix \a mp array (! column-major order)
      void GetValue(T* mp) const
      {
        int c = 0;
        for (int j = 0; j < 4; j++)
        {
          for (int i = 0; i < 4; i++)
          {
            mp[c++] = Elem(i, j);
          }
        }
      }

      /// Provide const access to the buffer
      const T* GetValue() const
      {
        return m;
      }

      /// Copy data from \a mp array
      void SetValue(const T* mp)
      {
        int c = 0;
        for (int j = 0; j < 4; j++)
        {
          for (int i = 0; i < 4; i++)
          {
            Elem(i, j) = mp[c++];
          }
        }
      }

      /// Initialization by a diagonal component
      void SetValue(T r)
      {
        MakeIdentity(); // this way is not optimal
        Elem(0, 0) = Elem(1, 1) = Elem(2, 2) = Elem(3, 3) = r;
      }

      /// access operator (e.g. m(2,3) = 20)
      T& operator ()(int row, int col)
      {
        return Elem(row, col);
      }

      T& operator [](int idx)
      {
        return m[idx];
      }

      const T& operator [](int idx) const
      {
        return m[idx];
      }
      /// const access operator (e.g. a = m(2,3))
      const T& operator ()(int row, int col) const
      {
        return Elem(row, col);
      }

      /// Return (row, col) element
      T& Elem(int row, int col)
      {
        return m[row | (col << 2)];
      }

      
      /// Return const (row, col) element
      const T& Elem(int row, int col) const
      {
        return m[row | (col << 2)];
      }

      /// @}



      /// Return predefined identity matrix
      static const TMatrix4x4<T>& Identity()
      {
        static TMatrix4x4<T> mident(
                (T)1.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)1.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)1.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)1.0);
        return mident;
      }

      /// @name Row and column access
      /// @{

      /// Set scale components of this matrix to the same value \a s
      void SetScale(T s)
      {
        Elem(0, 0) = s;
        Elem(1, 1) = s;
        Elem(2, 2) = s;
      }

      /// Set scale components of this matrix to values from vector \a s
      void SetScale(const TVector3<T>& s)
      {
        Elem(0, 0) = s.x;
        Elem(1, 1) = s.y;
        Elem(2, 2) = s.z;
      }


      /// Set translation part of this matrix to values of vector \a t
      /** Translation part is the 4-th column, so it is valid for use with column-vectors
       *  V = M * V; V = (v1 v2 v3 v4)T
       *  @see MultMatrixVec
       */
      void SetTranslation(const TVector3<T>& t)
      {
        Elem(0, 3) = t.x;
        Elem(1, 3) = t.y;
        Elem(2, 3) = t.z;
      }

      /// Set vector \a t to translation part of this matrix
      void GetTranslation(TVector3<T>& t) const
      {
        t.x = Elem(0, 3);
        t.y = Elem(1, 3);
        t.z = Elem(2, 3);
      }

      /// Return translation part of this matrix
      TVector3<T> GetTranslation() const
      {
        TVector3<T> t; GetTranslation(t);
        return t;
      }

      /// Set rotation part of the matrix (a 3x3 upper left corner)
      void SetRotation(const TMatrix4x4<T>& mat)
      {
        for (int j = 0; j < 3; j++)
        {
          for (int i = 0; i < 3; i++)
          {
            Elem(i, j) = mat(i, j);
          }
        }
      }
      /// Set mat to rotation part of this matrix
      void GetRotation(TMatrix4x4<T>& mat) const
      {
        for (int j = 0; j < 3; j++)
        {
          for (int i = 0; i < 3; i++)
          {
            mat(i, j) = Elem(i, j);
          }
        }

        mat(3, 0) = mat(3, 1) = mat(3, 2) = mat(0, 3) = mat(1, 3) = mat(2, 3) = (T)
                    0;
        mat(3, 3) = (T) 1;
      }

      /// Return rotation part of this matrix (a 3x3 upper left corner)
      TMatrix4x4<T> GetRotation() const
      {
        TMatrix4x4<T> t;
        GetRotation(t);
        return t;
      }

      /// Set row \a r of this matrix to vector \a t
      void SetRow(int r, const TVector4<T>& t)
      {
        Elem(r, 0) = t.x;
        Elem(r, 1) = t.y;
        Elem(r, 2) = t.z;
        Elem(r, 3) = t.w;
      }

      /// Set column \a c of this matrix to vector \a t
      void SetColumn(int c, const TVector4<T>& t)
      {
        Elem(0, c) = t.x;
        Elem(1, c) = t.y;
        Elem(2, c) = t.z;
        Elem(3, c) = t.w;
      }

      /// Set vector \a t equal to row \a r of this matrix
      void GetRow(int r, TVector4<T>& t) const
      {
        t.x = Elem(r, 0);
        t.y = Elem(r, 1);
        t.z = Elem(r, 2);
        t.w = Elem(r, 3);
      }

      /// Return row \a r
      TVector4<T> GetRow(int r) const
      {
        TVector4<T> v; GetRow(r, v);
        return v;
      }

      /// Set vector \a t equal to column \a c of this matrix
      void GetColumn(int c, TVector4<T>& t) const
      {
        t.x = Elem(0, c);
        t.y = Elem(1, c);
        t.z = Elem(2, c);
        t.w = Elem(3, c);
      }

      /// Return column \a c
      TVector4<T> GetColumn(int c) const
      {
        TVector4<T> v; GetColumn(c, v);
        return v;
      }

      /// @}


      /// @name Matrix-2-Matrix operations
      /// @{

      /// Multiplication to matrix \a b (right)
      TMatrix4x4<T>& MultRight(const TMatrix4x4<T>& b)
      {
        TMatrix4x4<T> mt(*this);
        SetValue((T) (0));

        for (int i = 0; i < 4; i++)
        {
          for (int j = 0; j < 4; j++)
          {
            for (int c = 0; c < 4; c++)
            {
              Elem(i, j) += mt(i, c) * b(c, j);
            }
          }
        }
        return *this;
      }    

      /// Multiplication to matrix \a b (left)
      TMatrix4x4<T>& MultLeft(const TMatrix4x4<T>& b)
      {
        TMatrix4x4 mt(*this);
        SetValue((T) (0));

        for (int i = 0; i < 4; i++)
        {
          for (int j = 0; j < 4; j++)
          {
            for (int c = 0; c < 4; c++)
            {
              Elem(i, j) += b(i, c) * mt(c, j);
            }
          }
        }
        return *this;
      }

      /// this *= mat
      TMatrix4x4<T>& operator *=(const TMatrix4x4<T>& mat)
      {
        MultRight(mat);
        return *this;
      }

      /// this += mat
      TMatrix4x4<T>& operator +=(const TMatrix4x4<T>& mat)
      {
        for (int i = 0; i < 4; ++i)
        {
          Elem(0, i) += mat.Elem(0, i);
          Elem(1, i) += mat.Elem(1, i);
          Elem(2, i) += mat.Elem(2, i);
          Elem(3, i) += mat.Elem(3, i);
        }
        return *this;
      }

      /// @}

      /// @name Matrix-2-Vector operations
      /// @{

      /// dst = M * src
      void MultMatrixVec(const TVector3<T>& src, TVector3<T>& dst) const
      {
        T w = (src.x* Elem(3, 0) +
               src.y* Elem(3, 1) +
               src.z* Elem(3, 2) +
               Elem(3,
                    3));

        ASSERT(w != (T) 0.0);

        dst.x = (src.x * Elem(0, 0) +
                 src.y * Elem(0, 1) +
                 src.z * Elem(0, 2) +
                 Elem(0,
                      3)) /
                w;
        dst.y = (src.x * Elem(1, 0) +
                 src.y * Elem(1, 1) +
                 src.z * Elem(1, 2) +
                 Elem(1,
                      3)) /
                w;
        dst.z = (src.x * Elem(2, 0) +
                 src.y * Elem(2, 1) +
                 src.z * Elem(2, 2) +
                 Elem(2,
                      3)) /
                w;
      }

      /// src_and_dst = M * src_and_dst
      void MultMatrixVec(TVector3<T>& src_and_dst) const
      {
        MultMatrixVec(TVector3<T>(src_and_dst), src_and_dst);
      }

      /// dst = src * M
      void MultVecMatrix(const TVector3<T>& src, TVector3<T>& dst) const
      {
        T w = (src.x* Elem(0, 3) +
               src.y* Elem(1, 3) +
               src.z* Elem(2, 3) +
               Elem(3,
                    3));

        ASSERT(w != (T) 0.0);

        dst.x = (src.x * Elem(0, 0) +
                 src.y * Elem(1, 0) +
                 src.z * Elem(2, 0) +
                 Elem(3,
                      0)) /
                w;
        dst.y = (src.x * Elem(0, 1) +
                 src.y * Elem(1, 1) +
                 src.z * Elem(2, 1) +
                 Elem(3,
                      1)) /
                w;
        dst.z = (src.x * Elem(0, 2) +
                 src.y * Elem(1, 2) +
                 src.z * Elem(2, 2) +
                 Elem(3,
                      2)) /
                w;
      }

      /// src_and_dst = src_and_dst * M
      void MultVecMatrix(TVector3<T>& src_and_dst) const
      {
        MultVecMatrix(TVector3<T>(src_and_dst), src_and_dst);
      }

      /// dst = M * src
      void MultMatrixVec(const TVector4<T>& src, TVector4<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) +
                 src.y * Elem(0, 1) +
                 src.z * Elem(0, 2) +
                 src.w * Elem(0,
                              3));
        dst.y = (src.x * Elem(1, 0) +
                 src.y * Elem(1, 1) +
                 src.z * Elem(1, 2) +
                 src.w * Elem(1,
                              3));
        dst.z = (src.x * Elem(2, 0) +
                 src.y * Elem(2, 1) +
                 src.z * Elem(2, 2) +
                 src.w * Elem(2,
                              3));
        dst.w = (src.x * Elem(3, 0) +
                 src.y * Elem(3, 1) +
                 src.z * Elem(3, 2) +
                 src.w * Elem(3,
                              3));
      }

      /// src_and_dst = M * src_and_dst
      void MultMatrixVec(TVector4<T>& src_and_dst) const
      {
        MultMatrixVec(TVector4<T>(src_and_dst), src_and_dst);
      }


      /// dst = src * M      
      void MultVecMatrix(const TVector4<T>& src, TVector4<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) +
                 src.y * Elem(1, 0) +
                 src.z * Elem(2, 0) +
                 src.w * Elem(3,
                              0));
        dst.y = (src.x * Elem(0, 1) +
                 src.y * Elem(1, 1) +
                 src.z * Elem(2, 1) +
                 src.w * Elem(3,
                              1));
        dst.z = (src.x * Elem(0, 2) +
                 src.y * Elem(1, 2) +
                 src.z * Elem(2, 2) +
                 src.w * Elem(3,
                              2));
        dst.w = (src.x * Elem(0, 3) +
                 src.y * Elem(1, 3) +
                 src.z * Elem(2, 3) +
                 src.w * Elem(3,
                              3));
      }

      /// src_and_dst = src_and_dst * M
      void MultVecMatrix(TVector4<T>& src_and_dst) const
      {
        MultVecMatrix(TVector4<T>(src_and_dst), src_and_dst);
      }

          /// dst = M * src (no perspective division)
    void MultMatrixVec3( const TVector3<T> &src, TVector3<T> &dst ) const
      {
      dst.x  = (
        src.x * Elem(0,0) +
        src.y * Elem(0,1) +
        src.z * Elem(0,2) +
        Elem(0,3)          );
      dst.y  = (
        src.x * Elem(1,0) +
        src.y * Elem(1,1) +
        src.z * Elem(1,2) +
        Elem(1,3)          );
      dst.z  = (
        src.x * Elem(2,0) +
        src.y * Elem(2,1) + 
        src.z * Elem(2,2) +
        Elem(2,3)          );
      }
    
    /// src_and_dst = M * src_and_dst (no perspective division)
    void MultMatrixVec3( TVector3<T> & src_and_dst) const
      { MultMatrixVec3(TVector3<T>(src_and_dst), src_and_dst); }
    
    /// dst = src * M (no perspective division)
    void MultVec3Matrix( const TVector3<T> &src, TVector3<T> &dst ) const
      {
      
      dst.x  = (
        src.x * Elem(0,0) +
        src.y * Elem(1,0) + 
        src.z * Elem(2,0) + 
        Elem(3,0)          );
      dst.y  = (
        src.x * Elem(0,1) +
        src.y * Elem(1,1) +
        src.z * Elem(2,1) +
        Elem(3,1)          );
      dst.z  = (
        src.x * Elem(0,2) +
        src.y * Elem(1,2) +
        src.z * Elem(2,2) +
        Elem(3,2)          );
      }

    /// src_and_dst = src_and_dst * M (no perspective division)
    void MultVec3Matrix( TVector3<T> & src_and_dst) const
      { MultVec3Matrix(TVector3<T>(src_and_dst), src_and_dst); }


      /// dst = M * src (only rotation and scale part, no translation)
      void MultMatrixDir(const TVector3<T>& src, TVector3<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(0, 1) + src.z * Elem(0, 2)) ;
        dst.y = (src.x * Elem(1, 0) + src.y * Elem(1, 1) + src.z * Elem(1, 2)) ;
        dst.z = (src.x * Elem(2, 0) + src.y * Elem(2, 1) + src.z * Elem(2, 2)) ;
      }

      /// src_and_dst = M * src_and_dst (only rotation and scale part, no translation)
      void MultMatrixDir(TVector3<T>& src_and_dst) const
      {
        MultMatrixDir(TVector3<T>(src_and_dst), src_and_dst);
      }


      /// dst = src * M (only rotation and scale part, no translation)
      void MultDirMatrix(const TVector3<T>& src, TVector3<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(1, 0) + src.z * Elem(2, 0)) ;
        dst.y = (src.x * Elem(0, 1) + src.y * Elem(1, 1) + src.z * Elem(2, 1)) ;
        dst.z = (src.x * Elem(0, 2) + src.y * Elem(1, 2) + src.z * Elem(2, 2)) ;
      }

      /// src_and_dst = src_and_dst * M (only rotation and scale part, no translation)      
      void MultDirMatrix(TVector3<T>& src_and_dst) const
      {
        MultDirMatrix(TVector3<T>(src_and_dst), src_and_dst);
      }

      /// @}

      /// @name Matrix-2-Scalar operations
      /// @{

      /// Multiplication by scalar r (diagonal)
      TMatrix4x4<T>& operator *=(const T& r)
      {
        for (int i = 0; i < 4; ++i)
        {
          Elem(0, i) *= r;
          Elem(1, i) *= r;
          Elem(2, i) *= r;
          Elem(3, i) *= r;
        }
        return *this;
      }
      /// @}

      /// @name Miscellaneous
      /// @{

      /// Make E-matrix from this one
      void MakeIdentity()
      {
        Elem(0, 0) = 1.0;
        Elem(0, 1) = 0.0;
        Elem(0, 2) = 0.0; 
        Elem(0, 3) = 0.0;

        Elem(1, 0) = 0.0;
        Elem(1, 1) = 1.0; 
        Elem(1, 2) = 0.0;
        Elem(1, 3) = 0.0;

        Elem(2, 0) = 0.0;
        Elem(2, 1) = 0.0;
        Elem(2, 2) = 1.0;
        Elem(2, 3) = 0.0;

        Elem(3, 0) = 0.0; 
        Elem(3, 1) = 0.0; 
        Elem(3, 2) = 0.0;
        Elem(3, 3) = 1.0;
      }

    /// Return an inverse matrix
    TMatrix4x4<T> Inverse() const
      {
      T tmp[12]; // temp array for pairs
      TMatrix4x4<T> m;

      // calculate pairs for first 8 elements (cofactors)
      tmp[0]  = Elem(2,2) * Elem(3,3);
      tmp[1]  = Elem(2,3) * Elem(3,2);
      tmp[2]  = Elem(2,1) * Elem(3,3);
      tmp[3]  = Elem(2,3) * Elem(3,1);
      tmp[4]  = Elem(2,1) * Elem(3,2);
      tmp[5]  = Elem(2,2) * Elem(3,1);
      tmp[6]  = Elem(2,0) * Elem(3,3);
      tmp[7]  = Elem(2,3) * Elem(3,0);
      tmp[8]  = Elem(2,0) * Elem(3,2);
      tmp[9]  = Elem(2,2) * Elem(3,0);
      tmp[10] = Elem(2,0) * Elem(3,1);
      tmp[11] = Elem(2,1) * Elem(3,0);

      // calculate first 8 elements (cofactors)
      m.Elem(0,0)  = tmp[0] * Elem(1,1) + tmp[3] * Elem(1,2) + tmp[4]  * Elem(1,3);
      m.Elem(0,0) -= tmp[1] * Elem(1,1) + tmp[2] * Elem(1,2) + tmp[5]  * Elem(1,3);
      m.Elem(1,0)  = tmp[1] * Elem(1,0) + tmp[6] * Elem(1,2) + tmp[9]  * Elem(1,3);
      m.Elem(1,0) -= tmp[0] * Elem(1,0) + tmp[7] * Elem(1,2) + tmp[8]  * Elem(1,3);
      m.Elem(2,0)  = tmp[2] * Elem(1,0) + tmp[7] * Elem(1,1) + tmp[10] * Elem(1,3);
      m.Elem(2,0) -= tmp[3] * Elem(1,0) + tmp[6] * Elem(1,1) + tmp[11] * Elem(1,3);
      m.Elem(3,0)  = tmp[5] * Elem(1,0) + tmp[8] * Elem(1,1) + tmp[11] * Elem(1,2);
      m.Elem(3,0) -= tmp[4] * Elem(1,0) + tmp[9] * Elem(1,1) + tmp[10] * Elem(1,2);
      m.Elem(0,1)  = tmp[1] * Elem(0,1) + tmp[2] * Elem(0,2) + tmp[5]  * Elem(0,3);
      m.Elem(0,1) -= tmp[0] * Elem(0,1) + tmp[3] * Elem(0,2) + tmp[4]  * Elem(0,3);
      m.Elem(1,1)  = tmp[0] * Elem(0,0) + tmp[7] * Elem(0,2) + tmp[8]  * Elem(0,3);
      m.Elem(1,1) -= tmp[1] * Elem(0,0) + tmp[6] * Elem(0,2) + tmp[9]  * Elem(0,3);
      m.Elem(2,1)  = tmp[3] * Elem(0,0) + tmp[6] * Elem(0,1) + tmp[11] * Elem(0,3);
      m.Elem(2,1) -= tmp[2] * Elem(0,0) + tmp[7] * Elem(0,1) + tmp[10] * Elem(0,3);
      m.Elem(3,1)  = tmp[4] * Elem(0,0) + tmp[9] * Elem(0,1) + tmp[10] * Elem(0,2);
      m.Elem(3,1) -= tmp[5] * Elem(0,0) + tmp[8] * Elem(0,1) + tmp[11] * Elem(0,2);

      // calculate pairs for second 8 elements (cofactors)
      tmp[0]  = Elem(0,2) * Elem(1,3);
      tmp[1]  = Elem(0,3) * Elem(1,2);
      tmp[2]  = Elem(0,1) * Elem(1,3);
      tmp[3]  = Elem(0,3) * Elem(1,1);
      tmp[4]  = Elem(0,1) * Elem(1,2);
      tmp[5]  = Elem(0,2) * Elem(1,1);
      tmp[6]  = Elem(0,0) * Elem(1,3);
      tmp[7]  = Elem(0,3) * Elem(1,0);
      tmp[8]  = Elem(0,0) * Elem(1,2);
      tmp[9]  = Elem(0,2) * Elem(1,0);
      tmp[10] = Elem(0,0) * Elem(1,1);
      tmp[11] = Elem(0,1) * Elem(1,0);

      // calculate second 8 elements (cofactors)
      m.Elem(0,2)  = tmp[0]  * Elem(3,1) + tmp[3]  * Elem(3,2) + tmp[4]  * Elem(3,3);
      m.Elem(0,2) -= tmp[1]  * Elem(3,1) + tmp[2]  * Elem(3,2) + tmp[5]  * Elem(3,3);
      m.Elem(1,2)  = tmp[1]  * Elem(3,0) + tmp[6]  * Elem(3,2) + tmp[9]  * Elem(3,3);
      m.Elem(1,2) -= tmp[0]  * Elem(3,0) + tmp[7]  * Elem(3,2) + tmp[8]  * Elem(3,3);
      m.Elem(2,2)  = tmp[2]  * Elem(3,0) + tmp[7]  * Elem(3,1) + tmp[10] * Elem(3,3);
      m.Elem(2,2) -= tmp[3]  * Elem(3,0) + tmp[6]  * Elem(3,1) + tmp[11] * Elem(3,3);
      m.Elem(3,2)  = tmp[5]  * Elem(3,0) + tmp[8]  * Elem(3,1) + tmp[11] * Elem(3,2);
      m.Elem(3,2) -= tmp[4]  * Elem(3,0) + tmp[9]  * Elem(3,1) + tmp[10] * Elem(3,2);
      m.Elem(0,3)  = tmp[2]  * Elem(2,2) + tmp[5]  * Elem(2,3) + tmp[1]  * Elem(2,1);
      m.Elem(0,3) -= tmp[4]  * Elem(2,3) + tmp[0]  * Elem(2,1) + tmp[3]  * Elem(2,2);
      m.Elem(1,3)  = tmp[8]  * Elem(2,3) + tmp[0]  * Elem(2,0) + tmp[7]  * Elem(2,2);
      m.Elem(1,3) -= tmp[6]  * Elem(2,2) + tmp[9]  * Elem(2,3) + tmp[1]  * Elem(2,0);
      m.Elem(2,3)  = tmp[6]  * Elem(2,1) + tmp[11] * Elem(2,3) + tmp[3]  * Elem(2,0);
      m.Elem(2,3) -= tmp[10] * Elem(2,3) + tmp[2]  * Elem(2,0) + tmp[7]  * Elem(2,1);
      m.Elem(3,3)  = tmp[10] * Elem(2,2) + tmp[4]  * Elem(2,0) + tmp[9]  * Elem(2,1);
      m.Elem(3,3) -= tmp[8]  * Elem(2,1) + tmp[11] * Elem(2,2) + tmp[5]  * Elem(2,0);

      // calculate matrix inverse
      m *= 1 / (Elem(0,0) * m.Elem(0,0) + Elem(0,1) * m.Elem(1,0) + Elem(0,2) * m.Elem(2,0) + Elem(0,3) * m.Elem(3,0));

      return m;

      }


      /// Return transposed matrix
      TMatrix4x4<T> Transpose() const
      {
        TMatrix4x4<T> mtrans;

        for (int i = 0; i < 4; i++)
        {
          for (int j = 0; j < 4; j++)
          {
            mtrans(i, j) = Elem(j, i);
          }
        }   
        return mtrans;
      }


      /// Construct perspective matrix (fovy in degrees!)
      void Perspective(double fovy, double aspect, double z_near, double z_far)
        {
        T f = static_cast<T>(1 / tan(ToRadians(fovy) / 2));
        
        Elem(0,0) = static_cast<T>(f / aspect);
        Elem(1,0) = 0;
        Elem(2,0) = 0;
        Elem(3,0) = 0;
        
        Elem(0,1) = 0;
        Elem(1,1) = f;
        Elem(2,1) = 0;
        Elem(3,1) = 0;
        
        Elem(0,2) = 0;
        Elem(1,2) = 0;
        Elem(2,2) = static_cast<T>(-(z_far + z_near) / (z_far - z_near));
        Elem(3,2) = -1;
        
        Elem(0,3) = 0;
        Elem(1,3) = 0;
        Elem(2,3) = static_cast<T>(-2 * z_far * z_near / (z_far - z_near));
        Elem(3,3) = 0;
        }

      void Ortho(double left,
                 double right,
                 double bottom,
                 double top,
                 double znear,
                 double zfar)
      {
        Elem(0, 0) = 2 / (right - left);
        Elem(0, 1) = 0.0;
        Elem(0, 2) = 0.0; 
        Elem(0, 3) = -(right + left) / (right - left);

        Elem(1, 0) = 0.0;
        Elem(1, 1) = 2 / (top - bottom);
        Elem(1, 2) = 0.0;
        Elem(1, 3) = -(top + bottom) / (top - bottom);

        Elem(2, 0) = 0.0;
        Elem(2, 1) = 0.0;
        Elem(2, 2) = -2 / (zfar - znear);
        Elem(2, 3) = -(zfar + znear) / (zfar - znear);

        Elem(3, 0) = 0.0; 
        Elem(3, 1) = 0.0; 
        Elem(3, 2) = 0.0;
        Elem(3, 3) = 1.0;
      }

      /// @}

      friend TMatrix4x4<T> operator *(const TMatrix4x4<T>& m1,
                                      const TMatrix4x4<T>& m2);
      friend bool operator ==(const TMatrix4x4<T>& m1, const TMatrix4x4<T>& m2);
      friend bool operator !=(const TMatrix4x4<T>& m1, const TMatrix4x4<T>& m2);

    protected:
      T m[16];
  };

  /// Matrix multiplication (return m1 * m2)
  /** @relates TMatrix4x4
  */
  template <class T>
  inline  
  TMatrix4x4<T> operator *(const TMatrix4x4<T>& m1, const TMatrix4x4<T>& m2)
  {
    static TMatrix4x4<T> product;

    product = m1;
    product.MultRight(m2);

    return product;
  }

  /// Equality operator
  /** @relates TMatrix4x4
  */
  template <class T>
  inline
  bool operator ==(const TMatrix4x4<T>& m1, const TMatrix4x4<T>& m2)
  {
    return (m1(0, 0) ==
            m2(0, 0) &&
            m1(0, 1) ==
            m2(0, 1) &&
            m1(0, 2) ==
            m2(0,
                                                                           2) &&
            m1(0,
               3) ==
            m2(0,
               3) &&
            m1(1,
               0) ==
            m2(1,
               0) &&
            m1(1,
               1) ==
            m2(1,
               1) &&
            m1(1,
               2) ==
            m2(1,
               2) &&
            m1(1,
               3) ==
            m2(1,
               3) &&
            m1(2,
               0) ==
            m2(2,
               0) &&
            m1(2,
               1) ==
            m2(2,
               1) &&
            m1(2,
               2) ==
            m2(2,
               2) &&
            m1(2,
               3) ==
            m2(2,
               3) &&
            m1(3,
               0) ==
            m2(3,
               0) &&
            m1(3,
               1) ==
            m2(3,
               1) &&
            m1(3,
               2) ==
            m2(3,
               2) &&
            m1(3,
               3) ==
            m2(3,
               3));
  }

  /// Unequality operator
  /** @relates TMatrix4x4
  */
  template <class T>
  inline
  bool operator !=(const TMatrix4x4<T>& m1, const TMatrix4x4<T>& m2)
  {
    return !(m1 == m2);
  }  


  /// Convert TMatrix4x4<T_FROM> to TMatrix4x4<T_TO>
  /** @relates TMatrix4x4
  */
  template <class T_FROM, class T_TO>
  inline TMatrix4x4<T_TO> Conv(const TMatrix4x4<T_FROM>& u)
  {
    return TMatrix4x4<T_TO>((T_TO)
                            u(0, 0),
                            (T_TO)
                            u(0, 1),
                            (T_TO)
                            u(0, 2),
                            (T_TO)
                            u(0,
                              3),
                            (T_TO)
                            u(1,
                              0),
                            (T_TO)
                            u(1,
                              1),
                            (T_TO)
                            u(1,
                              2),
                            (T_TO)
                            u(1,
                              3),
                            (T_TO)
                            u(2,
                              0),
                            (T_TO)
                            u(2,
                              1),
                            (T_TO)
                            u(2,
                              2),
                            (T_TO)
                            u(2,
                              3),
                            (T_TO)
                            u(3,
                              0),
                            (T_TO)
                            u(3,
                              1),
                            (T_TO)
                            u(3,
                              2),
                            (T_TO)
                            u(3,
                              3));
  }


  /// Convert TMatrix4x4<T> to TMatrix4x4<float>
  /** @relates TMatrix4x4
  */
  template <class T>
  inline TMatrix4x4<float> ConvF(const TMatrix4x4<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TMatrix4x4<T> to TMatrix4x4<double>
  /** @relates TMatrix4x4
  */
  template <class T>
  inline TMatrix4x4<double> ConvD(const TMatrix4x4<T>& u)
  {
    return Conv<T, double>(u);
  }


  typedef TMatrix4x4<double> Matrix4x4d;
  typedef TMatrix4x4<float> Matrix4x4f;


  /* @} */

  /* @} */
}



#endif