//
//  GMlib -- Graphics & Media Lab Common Source Library
//
//  $Id: gmlbsphere.cpp,v 1.4 2004/01/13 17:38:42 04a_deg Exp $
//
//  Copyright (C) 2004, Moscow State University Graphics & Media Lab
//  gmlsupport@graphics.cs.msu.su
//  
//  This file is part of GMlib software.
//  For conditions of distribution and use, see the accompanying README file.

#include "../base/gmlcommon.h"
#include "gmlbsphere.h"

using namespace gml;
// ----------------------------------------------------------
//                   BSphere3 METHODS
// ----------------------------------------------------------

//  expand the sphere to include given point
template <class T>
void BSphere3<T>::Include(const TVector3<T>& point)

//  expand the sphere to include given sphere
template <class T>
void BSphere3<T>::Include(const BSphere3<T>& bsphere)
