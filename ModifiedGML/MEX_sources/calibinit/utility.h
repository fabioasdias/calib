#pragma once
#include "CV.h"
#include "highgui.h"
#include "cvaux.h"

class Utility
{
public:
	static void CalcDistPointToLine2D(CvPoint2D32f *points, int count, float *_line, float *dist);
	static float Distance(CvPoint2D32f *p1, CvPoint2D32f *p2);
};

