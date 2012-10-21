//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlmatrix3.h,v 1.10 2004/09/20 09:32:56 dmoroz Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLMATRIX3_H_INCLUDED 
#define _GMLMATRIX3_H_INCLUDED 

#include "gmlvector3.h"
#include "gmlvector2.h"

/** @file gmlmatrix3.h
*  @brief Definition of TMatrix3x3 template class and utility routines
*/


namespace gml
{
  /** @addtogroup Math
  * @{
  */

  /** @addtogroup Math3x3
  *  @{
  */

  /// Template class for 3x3 matrix
  /** 
  * @param T - template type of matrix elements
  * @warning Use it with some SIGNED integral type, or a real type
    Elements are stored in column-major order (OpenGL-style) E.g.:
    <PRE>   
    a0  a3  a6 
    a1  a4  a7
    a2  a5  a8
    </PRE>
  */
  template <class T>
  class TMatrix3x3
  {
    public:

      /// @name Constructors
      /// @{

      /// No initialization
      TMatrix3x3()
      {
      }

      /// Initialization by diagonal element
      TMatrix3x3(T r)
      {
        SetValue(r);
      }

      /// Initialization by array of T
      TMatrix3x3(const T* m)
      {
        SetValue(m);
      }

      /// Direct initialization by components (row order)
      TMatrix3x3(T a00, T a01, T a02, T a10, T a11, T a12, T a20, T a21, T a22)
      {
        Elem(0, 0) = a00;
        Elem(0, 1) = a01;
        Elem(0, 2) = a02;

        Elem(1, 0) = a10;
        Elem(1, 1) = a11;
        Elem(1, 2) = a12;

        Elem(2, 0) = a20;
        Elem(2, 1) = a21;
        Elem(2, 2) = a22;
      }

      /// @}

      /// @name Access to values
      /// @{

      /// @brief Provide access to internal contents
      /// @warning Use with care, this function is dangerous!
      T* RawArray()
      {
        return m;
      }

      /// Copy this matrix \a mp array (! column-major order)
      void GetValue(T* mp) const
      {
        int c = 0;
        for (int j = 0; j < 3; j++)
        {
          for (int i = 0; i < 3; i++)
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
        for (int j = 0; j < 3; j++)
        {
          for (int i = 0; i < 3; i++)
          {
            Elem(i, j) = mp[c++];
          }
        }
      }

      /// Initialization by a diagonal component
      void SetValue(T r)
      {
        MakeIdentity(); // this way is not optimal
        Elem(0, 0) = Elem(1, 1) = Elem(2, 2) = r;
      }

      /// access operator (e.g. m(2,1) = 20)
      T& operator ()(int row, int col)
      {
        return Elem(row, col);
      }

      /// const access operator (e.g. a = m(2,1))
      const T& operator ()(int row, int col) const
      {
        return Elem(row, col);
      }

      /// Return (row, col) element
      T& Elem(int row, int col)
      {
        return m[row + col * 3];
      }

      /// Return const (row, col) element
      const T& Elem(int row, int col) const
      {
        return m[row + col * 3];
      }

      /// @}



      /// Return predefined identity matrix
      static const TMatrix3x3<T>& Identity()
      {
        static TMatrix3x3<T> mident(
                (T)1.0,
                (T)0.0,
                (T)0.0,
                (T)0.0,
                (T)1.0,
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
      }

      /// Set scale components of this matrix to values from vector \a s
      void SetScale(const TVector3<T>& s)
      {
        Elem(0, 0) = s.x;
        Elem(1, 1) = s.y;
      }


      /// Set translation part of this matrix to values of vector \a t
      /** Translation part is the 3-th column, so it is valid for use with column-vectors
       *  V = M * V; V = (v1 v2 v3 v4)T
       *  @see MultMatrixVec
       */
      void SetTranslation(const TVector2<T>& t)
      {
        Elem(0, 2) = t.x;
        Elem(1, 2) = t.y;
      }

      /// Set vector \a t to translation part of this matrix
      void GetTranslation(TVector2<T>& t) const
      {
        t.x = Elem(0, 2);
        t.y = Elem(1, 2);
      }

      /// Return translation part of this matrix
      TVector2<T> GetTranslation() const
      {
        TVector2<T> t; GetTranslation(t);
        return t;
      }

      /// Set rotation part of the matrix (a 2x2 upper left corner)
      void SetRotation(const TMatrix3x3<T>& mat)
      {
        for (int j = 0; j < 2; j++)
        {
          for (int i = 0; i < 2; i++)
          {
            Elem(i, j) = mat(i, j);
          }
        }
      }
      /// Set mat to rotation part of this matrix
      void GetRotation(TMatrix3x3<T>& mat) const
      {
        for (int j = 0; j < 2; j++)
        {
          for (int i = 0; i < 2; i++)
          {
            mat(i, j) = Elem(i, j);
          }
        }

        mat(2, 0) = mat(2, 1) = mat(0, 2) = mat(1, 2) = (T) 0;
        mat(2, 2) = (T) 1;
      }

      /// Return rotation part of this matrix (a 2x2 upper left corner)
      TMatrix3x3<T> GetRotation() const
      {
        TMatrix3x3<T> t;
        GetRotation(t);
        return t;
      }

      /// Set row \a r of this matrix to vector \a t
      void SetRow(int r, const TVector3<T>& t)
      {
        Elem(r, 0) = t.x;
        Elem(r, 1) = t.y;
        Elem(r, 2) = t.z;
      }

      /// Set column \a c of this matrix to vector \a t
      void SetColumn(int c, const TVector3<T>& t)
      {
        Elem(0, c) = t.x;
        Elem(1, c) = t.y;
        Elem(2, c) = t.z;
      }

      /// Set vector \a t equal to row \a r of this matrix
      void GetRow(int r, TVector3<T>& t) const
      {
        t.x = Elem(r, 0);
        t.y = Elem(r, 1);
        t.z = Elem(r, 2);
      }

      /// Return row \a r
      TVector3<T> GetRow(int r) const
      {
        TVector3<T> v; GetRow(r, v);
        return v;
      }

      /// Set vector \a t equal to column \a c of this matrix
      void GetColumn(int c, TVector3<T>& t) const
      {
        t.x = Elem(0, c);
        t.y = Elem(1, c);
        t.z = Elem(2, c);
      }

      /// Return column \a c
      TVector3<T> GetColumn(int c) const
      {
        TVector3<T> v; GetColumn(c, v);
        return v;
      }

      /// @}


      /// @name Matrix-2-Matrix operations
      /// @{

      /// Multiplication to matrix \a b (right)
      TMatrix3x3<T>& MultRight(const TMatrix3x3<T>& b)
      {
        TMatrix3x3<T> mt(*this);
        SetValue((T) (0));

        for (int i = 0; i < 3; i++)
        {
          for (int j = 0; j < 3; j++)
          {
            for (int c = 0; c < 3; c++)
            {
              Elem(i, j) += mt(i, c) * b(c, j);
            }
          }
        }
        return *this;
      }    

      /// Multiplication to matrix \a b (left)
      TMatrix3x3<T>& MultLeft(const TMatrix3x3<T>& b)
      {
        TMatrix3x3 mt(*this);
        SetValue((T) (0));

        for (int i = 0; i < 3; i++)
        {
          for (int j = 0; j < 3; j++)
          {
            for (int c = 0; c < 3; c++)
            {
              Elem(i, j) += b(i, c) * mt(c, j);
            }
          }
        }
        return *this;
      }

      /// this *= mat
      TMatrix3x3<T>& operator *=(const TMatrix3x3<T>& mat)
      {
        MultRight(mat);
        return *this;
      }

      /// this += mat
      TMatrix3x3<T>& operator +=(const TMatrix3x3<T>& mat)
      {
        for (int i = 0; i < 3; ++i)
        {
          Elem(0, i) += mat.Elem(0, i);
          Elem(1, i) += mat.Elem(1, i);
          Elem(2, i) += mat.Elem(2, i);
        }
        return *this;
      }
      //*************************
      //this /= number
      TMatrix3x3<T>& operator /=(const double d)
      {
        if (d != 0)
          for (int i = 0; i < 3; i++)
          {
            for (int j = 0; j < 3; j++)
            {
              Elem(i, j) /= d;
            }
          }

        return *this;
      }

      //this *= number
      TMatrix3x3<T> operator *=(const double d)
      {
        if (d != 0)
          for (int i = 0; i < 3; i++)
          {
            for (int j = 0; j < 3; j++)
            {
              Elem(i, j) *= d;
            }
          }

        return *this;
      }

      TMatrix3x3<T> operator /(const double d)
      {
        TMatrix3x3<T> mat;

        if (d != 0)
          for (int i = 0; i < 3; i++)
          {
            for (int j = 0; j < 3; j++)
            {
              mat(i, j) = Elem(i, j) / d;
            }
          }

        return mat;
      }

      TMatrix3x3<T> operator =(const TMatrix3x3<T>& mat)
      {
        for (int i = 0; i < 3; i++)
        {
          for (int j = 0; j < 3; j++)
          {
            Elem(i, j) = mat(i, j);
          }
        }

        return *this;
      }

      //*************************

      /// @}

      //*************************
      void RotateByX(double in_dAngle) 
      {
        // Assuming the angle is in radians. (?)
        double c = cos(in_dAngle);
        double s = sin(in_dAngle);

        Elem(0, 0) = 1.0;
        Elem(0, 1) = 0.0;
        Elem(0, 2) = 0.0;
        Elem(1, 0) = 0.0;
        Elem(1, 1) = c;
        Elem(1, 2) = s;
        Elem(2, 0) = 0.0;
        Elem(2, 1) = -s;
        Elem(2, 2) = c;
      }


      void RotateByY(double angle) 
      {
        // Assuming the angle is in radians. (?)
        double c = cos(angle);
        double s = sin(angle);

        Elem(0, 0) = c;
        Elem(0, 1) = 0.0;
        Elem(0, 2) = -s;
        Elem(1, 0) = 0.0;
        Elem(1, 1) = 1;
        Elem(1, 2) = 0.0;
        Elem(2, 0) = s;
        Elem(2, 1) = 0.0;
        Elem(2, 2) = c;
      }


      void RotateByZ(double angle) 
      {
        // Assuming the angle is in radians. (?)
        double c = cos(angle);
        double s = sin(angle);

        Elem(0, 0) = c;
        Elem(0, 1) = s;
        Elem(0, 2) = 0.0;
        Elem(1, 0) = -s;
        Elem(1, 1) = c;
        Elem(1, 2) = 0.0;
        Elem(2, 0) = 0.0;
        Elem(2, 1) = 0.0;
        Elem(2, 2) = 1.0;
      }

      //*************************

      /// @name Matrix-2-Vector operations
      /// @{

      /// dst = M * src
      void MultMatrixVec(const TVector2<T>& src, TVector2<T>& dst) const
      {
        T w = (src.x* Elem(2, 0) + src.y* Elem(2, 1) + Elem(2, 2));

        ASSERT(w != (T) 0.0);

        dst.x = (src.x * Elem(0, 0) + src.y * Elem(0, 1) + Elem(0, 2)) / w;
        dst.y = (src.x * Elem(1, 0) + src.y * Elem(1, 1) + Elem(1, 2)) / w;
      }

      /// src_and_dst = M * src_and_dst
      void MultMatrixVec(TVector2<T>& src_and_dst) const
      {
        MultMatrixVec(TVector2<T>(src_and_dst), src_and_dst);
      }

      /// dst = src * M

      void MultVecMatrix(const TVector2<T>& src, TVector2<T>& dst) const
      {
        T w = (src.x* Elem(0, 2) + src.y* Elem(1, 2) + Elem(2, 2));

        ASSERT(w != (T) 0.0);
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(1, 0) + Elem(2, 0)) / w;
        dst.y = (src.x * Elem(0, 1) + src.y * Elem(1, 1) + Elem(2, 1)) / w;
      }

      /// src_and_dst = src_and_dst * M
      void MultVecMatrix(TVector2<T>& src_and_dst) const
      {
        MultVecMatrix(TVector2<T>(src_and_dst), src_and_dst);
      }

      /// dst = M * src
      void MultMatrixVec(const TVector3<T>& src, TVector3<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(0, 1) + src.z * Elem(0, 2));
        dst.y = (src.x * Elem(1, 0) + src.y * Elem(1, 1) + src.z * Elem(1, 2));
        dst.z = (src.x * Elem(2, 0) + src.y * Elem(2, 1) + src.z * Elem(2, 2));
      }

      /// src_and_dst = M * src_and_dst
      void MultMatrixVec(TVector3<T>& src_and_dst) const
      {
        MultMatrixVec(TVector3<T>(src_and_dst), src_and_dst);
      }


      /// dst = src * M      
      void MultVecMatrix(const TVector3<T>& src, TVector3<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(1, 0) + src.z * Elem(2, 0));
        dst.y = (src.x * Elem(0, 1) + src.y * Elem(1, 1) + src.z * Elem(2, 1));
        dst.z = (src.x * Elem(0, 2) + src.y * Elem(1, 2) + src.z * Elem(2, 2));
      }

      /// src_and_dst = src_and_dst * M
      void MultVecMatrix(TVector3<T>& src_and_dst) const
      {
        MultVecMatrix(TVector3<T>(src_and_dst), src_and_dst);
      }


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
      void MultDirMatrix(const TVector2<T>& src, TVector2<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(1, 0)) ;
        dst.y = (src.x * Elem(0, 1) + src.y * Elem(1, 1)) ;
      }

      /// src_and_dst = src_and_dst * M (only rotation and scale part, no translation)      
      void MultDirMatrix(TVector2<T>& src_and_dst) const
      {
        MultDirMatrix(TVector2<T>(src_and_dst), src_and_dst);
      }

      /// @}

      /// @name Matrix-2-Scalar operations
      /// @{

      /// Multiplication by scalar r (diagonal)
      /*
      TMatrix3x3<T> & operator *= ( const T & r )
        {
        for (int i = 0; i < 3; ++i)
          {
          Elem(0,i) *= r;
          Elem(1,i) *= r;
          Elem(2,i) *= r;
          }
        return *this;
        }*/
      /// @}

      /// @name Miscellaneous
      /// @{

      /// Make E-matrix from this one
      void MakeIdentity()
      {
        Elem(0, 0) = 1.0;
        Elem(0, 1) = 0.0;
        Elem(0, 2) = 0.0; 

        Elem(1, 0) = 0.0;
        Elem(1, 1) = 1.0; 
        Elem(1, 2) = 0.0;

        Elem(2, 0) = 0.0;
        Elem(2, 1) = 0.0;
        Elem(2, 2) = 1.0;
      }

      /// Return an inverse matrix
      TMatrix3x3<T> Inverse() const
      {
        TMatrix3x3<T> minv;

        T r1[6], r2[6], r3[6];
        T* s[3], * tmprow;

        s[0] = &r1[0];
        s[1] = &r2[0];
        s[2] = &r3[0];

        register int i,j,p,jj;
        for (i = 0; i < 3; i++)
        {
          for (j = 0; j < 3; j++)
          {
            s[i][j] = Elem(i, j);
            if (i == j)
              s[i][j + 3] = 1.0;
            else
              s[i][j + 3] = 0.0;
          }
        }
        T scp[3];
        for (i = 0; i < 3; i++)
        {
          scp[i] = (T) (fabs(s[i][0]));
          for (j = 1; j < 3; j++)
            if ((T) (fabs(s[i][j])) > scp[i])
              scp[i] = (T) (fabs(s[i][j]));
          if (scp[i] == 0.0)
            return minv; // singular matrix!
        }

        int pivot_to;
        T scp_max;
        for (i = 0; i < 3; i++)
        {
          // select pivot row
          pivot_to = i;
          scp_max = (T) (fabs(s[i][i] / scp[i]));
          // find out which row should be on top
          for (p = i + 1; p < 3; p++)
            if ((T) (fabs(s[p][i] / scp[p])) > scp_max)
            {
              scp_max = (T) (fabs(s[p][i] / scp[p])); pivot_to = p;
            }
          // Pivot if necessary
          if (pivot_to != i)
          {
            tmprow = s[i];
            s[i] = s[pivot_to];
            s[pivot_to] = tmprow;
            T tmpscp;
            tmpscp = scp[i];
            scp[i] = scp[pivot_to];
            scp[pivot_to] = tmpscp;
          }

          T mji;
          // perform gaussian elimination
          for (j = i + 1; j < 3; j++)
          {
            mji = s[j][i] / s[i][i];
            s[j][i] = 0.0;
            for (jj = i + 1; jj < 6; jj++)
              s[j][jj] -= mji * s[i][jj];
          }
        }
        if (s[2][2] == 0.0)
          return minv; // singular matrix!

        //
        // Now we have an upper triangular matrix.
        //
        //  x x x x | y y y y
        //  0 x x x | y y y y 
        //  0 0 x x | y y y y
        //  0 0 0 x | y y y y
        //
        //  we'll back substitute to get the inverse
        //
        //  1 0 0 0 | z z z z
        //  0 1 0 0 | z z z z
        //  0 0 1 0 | z z z z
        //  0 0 0 1 | z z z z 
        //

        T mij;
        for (i = 2; i > 0; i--)
        {
          for (j = i - 1; j > -1; j--)
          {
            mij = s[j][i] / s[i][i];
            for (jj = j + 1; jj < 6; jj++)
              s[j][jj] -= mij * s[i][jj];
          }
        }

        for (i = 0; i < 3; i++)
        {
          for (j = 0; j < 3; j++)
          {
            minv(i, j) = s[i][j + 3] / s[i][i];
          }
        }

        return minv;
      }


      /// Return transposed matrix
      TMatrix3x3<T> Transpose() const
      {
        TMatrix3x3<T> mtrans;

        for (int i = 0; i < 3; i++)
        {
          for (int j = 0; j < 3; j++)
          {
            mtrans(i, j) = Elem(j, i);
          }
        }   
        return mtrans;
      }
      /// @}

      //*****************************
      T Det()
      {
        return Elem(0, 0) * Elem(1, 1) * Elem(2, 2) +
               Elem(0, 1) * Elem(1, 2) * Elem(2,
                                              0) +
               Elem(0,
                    2) * Elem(2,
                              1) * Elem(1,
                                        0) -
               Elem(0,
                    2) * Elem(1,
                              1) * Elem(2,
                                        0) -
               Elem(0,
                    1) * Elem(1,
                              0) * Elem(2,
                                        2) -
               Elem(0,
                    0) * Elem(1,
                              2) * Elem(2,
                                        1);
      }

      TMatrix3x3<T> MultVectStr(TVector3<T>& v1, TVector3<T>& v2)
      {
        for (int i = 0; i < 3; i++)
        {
          for (int j = 0; j < 3; j++)
          {
            Elem(i, j) = v1[i] * v2[j];
          }
        }

        return *this;
      }
      //*****************************

      friend TMatrix3x3<T> operator *(const TMatrix3x3<T>& m1,
                                      const TMatrix3x3<T>& m2);
      friend bool operator ==(const TMatrix3x3<T>& m1, const TMatrix3x3<T>& m2);
      friend bool operator !=(const TMatrix3x3<T>& m1, const TMatrix3x3<T>& m2);
      //friend TMatrix3x3<T> operator *(const TVector3<T> &v1, const TVector3<T> &v2);
      //friend TMatrix3x3<T> operator =( TMatrix3x3<T> &m1, const TMatrix3x3<T> &m2);

    protected:
      T m[9];
  };

  /// Matrix multiplication (return m1 * m2)
  /** @relates TMatrix3x3
  */
  template <class T>
  inline  
  TMatrix3x3<T> operator *(const TMatrix3x3<T>& m1, const TMatrix3x3<T>& m2)
  {
    static TMatrix3x3<T> product;

    product = m1;
    product.MultRight(m2);

    return product;
  }

  /// Equality operator
  /** @relates TMatrix3x3
  */
  template <class T>
  inline
  bool operator ==(const TMatrix3x3<T>& m1, const TMatrix3x3<T>& m2)
  {
    return (m1(0, 0) ==
            m2(0, 0) &&
            m1(0, 1) ==
            m2(0, 1) &&
            m1(0, 2) ==
            m2(0,
                                                                           2) &&
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
               2));
  }

  /// Unequality operator
  /** @relates TMatrix3x3
  */
  template <class T>
  inline
  bool operator !=(const TMatrix3x3<T>& m1, const TMatrix3x3<T>& m2)
  {
    return !(m1 == m2);
  }  


  /// Convert TMatrix3x3<T_FROM> to TMatrix3x3<T_TO>
  /** @relates TMatrix3x3
  */
  template <class T_FROM, class T_TO>
  inline TMatrix3x3<T_TO> Conv(const TMatrix3x3<T_FROM>& u)
  {
    return TMatrix3x3<T_TO>((T_TO)
                            u(0, 0),
                            (T_TO)
                            u(0, 1),
                            (T_TO)
                            u(0, 2),
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
                            u(2,
                              0),
                            (T_TO)
                            u(2,
                              1),
                            (T_TO)
                            u(2,
                              2));
  }


  /// Convert TMatrix3x3<T> to TMatrix3x3<float>
  /** @relates TMatrix3x3
  */
  template <class T>
  inline TMatrix3x3<float> ConvF(const TMatrix3x3<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TMatrix3x3<T> to TMatrix3x3<double>
  /** @relates TMatrix3x3
  */
  template <class T>
  inline TMatrix3x3<double> ConvD(const TMatrix3x3<T>& u)
  {
    return Conv<T, double>(u);
  }

  //**********************

  template <class T>
  TMatrix3x3<T> MultVectStr(TVector3<T>& v1, TVector3<T>& v2)
  {
    TMartix3x3<T> prod;

    for (i = 0; i < 3; i++)
    {
      for (j = 0; j < 3; j++)
      {
        prod(i, j) = v1[i] * v2[j];
      }
    }

    return prod;
  }

  /*template <class T>
  inline TMatrix3x3<T> operator *(const TVector3<T> &v1, const TVector3<T> &v2)
  {
  TMartix3x3<T> prod;
  for (i=0; i<3; i++)
  for (j=0; j<3; j++)
    prod(i,j)=v1[i]*v2[j];
  return prod;
  }
  template <class T>
  inline TVector3<T> operator *( const TMatrix3x3<T> &mat, const TVector3<T> &src )
      {
      TVector3<T> vec;
   T x,y,z;
   
   x  = (
        mat(0,0) * src[0] +
        mat(0,1) * src[1] +
        mat(0,2) * src[2]);
      y  = (
        mat(1,0) * src[0] +
        mat(1,1) * src[1] +
        mat(1,2) * src[2]);
      z  = (
        mat(2,0) * src[0] +
        mat(2,1) * src[1] + 
        mat(2,2) * src[2]);
   vec=TVector3<T> (x,y,z);
   return vec;
      }*/ 
  //**************************


  typedef TMatrix3x3<double> Matrix3x3d;
  typedef TMatrix3x3<float> Matrix3x3f;


  /* @} */

  /* @} */
}



#endif