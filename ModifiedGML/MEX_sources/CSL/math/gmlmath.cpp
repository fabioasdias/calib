//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlmath.cpp,v 1.9 2004/01/13 17:38:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#include "gmlmath.h"
#include <limits>

namespace gml
{
using namespace std;

#ifdef __BORLANDC__

#if __BORLANDC__ < 0x550
  const double Math<float> ::MAX_VALUE = numeric_limits<float>::max();
  const double Math<double> ::MAX_VALUE = numeric_limits<double>::max();
  const double Math<float> ::MIN_VALUE = numeric_limits<float>::min();
  const double Math<double> ::MIN_VALUE = numeric_limits<double>::min();
  const double Math<float> :: EPSILON = numeric_limits<float>::epsilon();
  const double Math<double> ::EPSILON = numeric_limits<double>::epsilon();
  const double Math<int> ::EPSILON = numeric_limits<int>::epsilon();

  const double Math<float> ::TOLERANCE = 1.0E-05f;
  const double Math<double> ::TOLERANCE = Math<float>::EPSILON;

#else

  const template < > double Math<float> ::MAX_VALUE = numeric_limits<float>::max();
  const template < > double Math<double> ::MAX_VALUE = numeric_limits<double>::max();
  const template < > double Math<float> ::MIN_VALUE = numeric_limits<float>::min();
  const template < > double Math<double> ::MIN_VALUE = numeric_limits<double>::min();
  const template < > double Math<float> :: EPSILON = numeric_limits<float>::epsilon();
  const template < > double Math<double> ::EPSILON = numeric_limits<double>::epsilon();
  const template < > double Math<int> ::EPSILON = numeric_limits<int>::epsilon();

  const template < > double Math<float> ::TOLERANCE = 1.0E-05f;
  const template < > double Math<double> ::TOLERANCE = Math<float>::EPSILON;
#endif


#else

  const double Math<float> ::MAX_VALUE = numeric_limits<float>::max();
  const double Math<double> ::MAX_VALUE = numeric_limits<double>::max();
  const double Math<float> ::MIN_VALUE = numeric_limits<float>::min();
  const double Math<double> ::MIN_VALUE = numeric_limits<double>::min();
  const double Math<float> :: EPSILON = numeric_limits<float>::epsilon();
  const double Math<double> ::EPSILON = numeric_limits<double>::epsilon();
  const double Math<int> ::EPSILON = numeric_limits<int>::epsilon();

  const double Math<float> ::TOLERANCE = 1.0E-05f;
  const double Math<double> ::TOLERANCE = Math<float>::EPSILON;

#endif
}
