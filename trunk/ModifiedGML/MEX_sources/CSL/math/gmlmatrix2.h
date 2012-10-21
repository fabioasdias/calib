//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlmatrix2.h,v 1.8 2004/01/13 17:38:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#ifndef _GMLMATRIX2_H_INCLUDED 
#define _GMLMATRIX2_H_INCLUDED 

#include "gmlvector2.h"
//#include "gmlvector3.h"

/** @file gmlmatrix2.h
*  @brief Definition of TMatrix2x2 template class and utility routines
*/


namespace gml
{
  /** @addtogroup Math
  * @{
  */

  /** @addtogroup Math2x2
  *  @{
  */

  /// Template class for 2x2 matrix
  /** 
  * @param T - template type of matrix elements
  * @warning Use it with some SIGNED integral type, or a real type
    Elements are stored in column-major order (OpenGL-style) E.g.:
    <PRE>   
    a0  a2 
    a1  a3
    </PRE>
  */
  template <class T>
  class TMatrix2x2
  {
    public:

      /// @name Constructors
      /// @{

      /// No initialization
      TMatrix2x2()
      {
      }

      /// Initialization by diagonal element
      TMatrix2x2(T r)
      {
        SetValue(r);
      }

      /// Initialization by array of T
      TMatrix2x2(const T* m)
      {
        SetValue(m);
      }

      /// Direct initialization by components (row order)
      TMatrix2x2(T a00, T a01, T a10, T a11)
      {
        Elem(0, 0) = a00;
        Elem(0, 1) = a01;      
        Elem(1, 0) = a10;
        Elem(1, 1) = a11;
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
        mp[0] = Elem(0, 0); mp[1] = Elem(1, 0); mp[2] = Elem(0, 1); mp[3] = Elem(1,
                                                                                 1);
      }

      /// Provide const access to the buffer
      const T* GetValue() const
      {
        return m;
      }

      /// Copy data from \a mp array
      void SetValue(const T* mp)
      {
        Elem(0, 0) = mp[0]; Elem(1, 0) = mp[1]; Elem(0, 1) = mp[2]; Elem(1, 1) = mp[3];
      }

      /// Initialization by a diagonal component
      void SetValue(T r)
      {
        MakeIdentity(); // this way is not optimal
        Elem(0, 0) = Elem(1, 1) = r;
      }

      /// access operator (e.g. m(1,0) = 20)
      T& operator ()(int row, int col)
      {
        return Elem(row, col);
      }

      /// const access operator (e.g. a = m(1,0))
      const T& operator ()(int row, int col) const
      {
        return Elem(row, col);
      }

      /// Return (row, col) element
      T& Elem(int row, int col)
      {
        return m[row | (col << 1)];
      }

      /// Return const (row, col) element
      const T& Elem(int row, int col) const
      {
        return m[row | (col << 1)];
      }

      /// @}



      /// Return predefined identity matrix
      static const TMatrix2x2<T>& Identity()
      {
        static TMatrix2x2<T> mident(
                (T)1.0, (T)0.0, (T)0.0, (T)1.0);
        return mident;
      }

      /// @name Row and column access
      /// @{
      /*
      /// Set scale components of this matrix to the same value \a s
      void SetScale( T s )
        {
        Elem(0,0) = s;
        Elem(1,1) = s;//!!!!!!!!!!!!!!!!!!!     
        }
      /// Set scale components of this matrix to values from vector \a s
      void SetScale( const TVector2<T> & s )
        {
        Elem(0,0) = s.x;
        Elem(1,1) = s.y;//!!!!!!!!!!!!!!!!!!!
        }
      /// Set translation part of this matrix to values of vector \a t
      /** Translation part is the 2-th column, so it is valid for use with column-vectors
       *  V = M * V; V = (v1 v2)T
       *  @see MultMatrixVec
       */
      /*void SetTranslation( const TVector3<T> & t )
        {
        Elem(0,3) = t.x;
        Elem(1,3) = t.y;
        Elem(2,3) = t.z;
        }
      /// Set vector \a t to translation part of this matrix
      void GetTranslation(TVector3<T>& t) const
        {
        t.x = Elem(0,3);
        t.y = Elem(1,3);
        t.z = Elem(2,3);
        }
      /// Return translation part of this matrix
      TVector2<T> GetTranslation() const
        {
        TVector2<T> t; GetTranslation(t);
        return t;
        }
      /// Set rotation part of the matrix (a 3x3 upper left corner)
      void SetRotation(const TMatrix2x2<T>& mat)
        {
        for(int j=0; j < 2; j++)
          for(int i=0; i < 2; i++)
            Elem(i,j) = mat(i,j);
        }
      /// Set mat to rotation part of this matrix
      void GetRotation(TMatrix2x2<T>& mat) const//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        {
        for(int j=0; j < 2; j++)
          for(int i=0; i < 2; i++)
            mat(i,j) = Elem(i,j);
        //mat(3,0) = mat(3,1) = mat(3,2) =  mat(0,3) = mat(1,3) = mat(2,3) = (T)0;
        //mat(3,3) = (T)1;
        }
      /// Return rotation part of this matrix (a 3x3 upper left corner)
      TMatrix2x2<T> GetRotation() const
        {
        TMatrix2x2<T> t;
        GetRotation(t);
        return t;
        }*/

      /// Set row \a r of this matrix to vector \a t
      void SetRow(int r, const TVector2<T>& t)
      {
        Elem(r, 0) = t.x;
        Elem(r, 1) = t.y;
      }

      /// Set column \a c of this matrix to vector \a t
      void SetColumn(int c, const TVector2<T>& t)
      {
        Elem(0, c) = t.x;
        Elem(1, c) = t.y;
      }

      /// Set vector \a t equal to row \a r of this matrix
      void GetRow(int r, TVector2<T>& t) const
      {
        t.x = Elem(r, 0);
        t.y = Elem(r, 1);
      }

      /// Return row \a r
      TVector2<T> GetRow(int r) const
      {
        TVector2<T> v; GetRow(r, v);
        return v;
      }

      /// Set vector \a t equal to column \a c of this matrix
      void GetColumn(int c, TVector2<T>& t) const
      {
        t.x = Elem(0, c);
        t.y = Elem(1, c);
      }

      /// Return column \a c
      TVector2<T> GetColumn(int c) const
      {
        TVector2<T> v; GetColumn(c, v);
        return v;
      }

      /// @}


      /// @name Matrix-2-Matrix operations
      /// @{

      /// Multiplication to matrix \a b (right)
      TMatrix2x2<T>& MultRight(const TMatrix2x2<T>& b)
      {
        TMatrix2x2<T> mt(*this);
        SetValue((T) (0));

        for (int i = 0; i < 2; i++)
        {
          for (int j = 0; j < 2; j++)
          {
            for (int c = 0; c < 2; c++)
            {
              Elem(i, j) += mt(i, c) * b(c, j);
            }
          }
        }
        return *this;
      }    

      /// Multiplication to matrix \a b (left)
      TMatrix2x2<T>& MultLeft(const TMatrix2x2<T>& b)
      {
        TMatrix2x2 mt(*this);
        SetValue((T) (0));

        for (int i = 0; i < 2; i++)
        {
          for (int j = 0; j < 2; j++)
          {
            for (int c = 0; c < 2; c++)
            {
              Elem(i, j) += b(i, c) * mt(c, j);
            }
          }
        }
        return *this;
      }

      /// this *= mat
      TMatrix2x2<T>& operator *=(const TMatrix2x2<T>& mat)
      {
        MultRight(mat);
        return *this;
      }

      /// this += mat
      TMatrix2x2<T>& operator +=(const TMatrix2x2<T>& mat)
      {
        Elem(0, 0) += mat.Elem(0, 0);
        Elem(1, 0) += mat.Elem(1, 0);
        Elem(0, 1) += mat.Elem(0, 1);
        Elem(1, 1) += mat.Elem(1, 1);

        return *this;
      }

      TMatrix2x2<T> operator /(const double d)
      {
        TMatrix2x2<T> mat;

        if (d != 0)
          for (int i = 0; i < 2; i++)
          {
            for (int j = 0; j < 2; j++)
            {
              mat(i, j) = Elem(i, j) / d;
            }
          }

        return mat;
      }

      /// @}

      /// @name Matrix-2-Vector operations
      /// @{

      /// dst = M * src
      void MultMatrixVec(const TVector2<T>& src, TVector2<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(0, 1));
        dst.y = (src.x * Elem(1, 0) + src.y * Elem(1, 1));
      }

      /// src_and_dst = M * src_and_dst
      void MultMatrixVec(TVector2<T>& src_and_dst) const
      {
        MultMatrixVec(TVector2<T>(src_and_dst), src_and_dst);
      }

      /// dst = src * M      
      void MultVecMatrix(const TVector2<T>& src, TVector2<T>& dst) const
      {
        dst.x = (src.x * Elem(0, 0) + src.y * Elem(1, 0));         
        dst.y = (src.x * Elem(0, 1) + src.y * Elem(1, 1));
      }

      /// src_and_dst = src_and_dst * M
      void MultVecMatrix(TVector2<T>& src_and_dst) const
      {
        MultVecMatrix(TVector2<T>(src_and_dst), src_and_dst);
      }

      /// @}

      /// @name Matrix-2-Scalar operations
      /// @{

      /// Multiplication by scalar r (diagonal)
      TMatrix2x2<T>& operator *=(const T& r)
      {
        Elem(0, 0) *= r;
        Elem(1, 0) *= r;
        Elem(0, 1) *= r;
        Elem(1, 1) *= r;

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
        Elem(1, 0) = 0.0;
        Elem(1, 1) = 1.0;
      }

      /// Return an inverse matrix
      TMatrix2x2<T> Inverse() const
      {
        TMatrix2x2<T> minv;
        T divider;

        divider = Elem(0, 0) * Elem(1, 1) - Elem(0, 1) * Elem(1, 0);

        minv(0, 0) = Elem(1, 1) / divider;
        minv(0, 1) = -Elem(0, 1) / divider;
        minv(1, 0) = -Elem(1, 0) / divider;
        minv(1, 1) = Elem(0, 0) / divider;

        return minv;
      }


      /// Return transposed matrix
      TMatrix2x2<T> Transpose() const
      {
        TMatrix2x2<T> mtrans;

        mtrans(0, 0) = Elem(0, 0);
        mtrans(1, 1) = Elem(1, 1);
        mtrans(0, 1) = Elem(1, 0);
        mtrans(1, 0) = Elem(0, 1);

        return mtrans;
      }
      /// @}

      //*************************
      T Det()
      {
        return Elem(0, 0) * Elem(1, 1) - Elem(0, 1) * Elem(1, 0);
      }

      TMatrix2x2<T> MultVectStr(TVector2<T>& v1, TVector2<T>& v2)
      {
        for (int i = 0; i < 2; i++)
        {
          for (int j = 0; j < 2; j++)
          {
            Elem(i, j) = v1[i] * v2[j];
          }
        }

        return *this;
      }

      //***************************

      friend TMatrix2x2<T> operator *(const TMatrix2x2<T>& m1,
                                      const TMatrix2x2<T>& m2);
      friend bool operator ==(const TMatrix2x2<T>& m1, const TMatrix2x2<T>& m2);
      friend bool operator !=(const TMatrix2x2<T>& m1, const TMatrix2x2<T>& m2);

    protected:
      T m[4];
  };

  /// Matrix multiplication (return m1 * m2)
  /** @relates TMatrix2x2
  */
  template <class T>
  inline  
  TMatrix2x2<T> operator *(const TMatrix2x2<T>& m1, const TMatrix2x2<T>& m2)
  {
    static TMatrix2x2<T> product;

    product = m1;
    product.MultRight(m2);

    return product;
  }

  /// Equality operator
  /** @relates TMatrix2x2
  */
  template <class T>
  inline
  bool operator ==(const TMatrix2x2<T>& m1, const TMatrix2x2<T>& m2)
  {
    return (m1(0, 0) ==
            m2(0, 0) &&
            m1(0, 1) ==
            m2(0, 1) &&
            m1(1, 0) ==
            m2(1,
                                                                           0) &&
            m1(1,
               1) ==
            m2(1,
               1));
  }

  /// Unequality operator
  /** @relates TMatrix2x2
  */
  template <class T>
  inline
  bool operator !=(const TMatrix2x2<T>& m1, const TMatrix2x2<T>& m2)
  {
    return !(m1 == m2);
  }  


  /// Convert TMatrix2x2<T_FROM> to TMatrix2x2<T_TO>
  /** @relates TMatrix2x2
  */
  template <class T_FROM, class T_TO>
  inline TMatrix2x2<T_TO> Conv(const TMatrix2x2<T_FROM>& u)
  {
    return TMatrix2x2<T_TO>((T_TO)
                            u(0, 0),
                            (T_TO)
                            u(0, 1),
                            (T_TO)
                            u(1, 0),
                            (T_TO)
                            u(1,
                              1));
  }


  /// Convert TMatrix2x2<T> to TMatrix2x2<float>
  /** @relates TMatrix2x2
  */
  template <class T>
  inline TMatrix2x2<float> ConvF(const TMatrix2x2<T>& u)
  {
    return Conv<T, float>(u);
  }

  /// Convert TMatrix2x2<T> to TMatrix2x2<double>
  /** @relates TMatrix2x2
  */
  template <class T>
  inline TMatrix2x2<double> ConvD(const TMatrix2x2<T>& u)
  {
    return Conv<T, double>(u);
  }


  typedef TMatrix2x2<double> Matrix2x2d;
  typedef TMatrix2x2<float> Matrix2x2f;


  /* @} */

  /* @} */
}



#endif