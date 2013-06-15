#pragma once
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv/cvaux.h>


class Utility
{
public:
	static void CalcDistPointToLine2D(CvPoint2D32f *points, int count, float *_line, float *dist);
	static float Distance(CvPoint2D32f *p1, CvPoint2D32f *p2);
};

