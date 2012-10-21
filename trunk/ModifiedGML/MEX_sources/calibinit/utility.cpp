//#include "stdafx.h"
#include "utility.h"
#include <math.h>
#include "cxmisc.h"

void Utility::CalcDistPointToLine2D(CvPoint2D32f *points, int count, float *_line, float *dist)
{
    int j;
    float px = _line[2], py = _line[3];
    float nx = _line[1], ny = -_line[0];

    for( j = 0; j < count; j++ )
    {
        float x, y;

        x = points[j].x - px;
        y = points[j].y - py;

        dist[j] = (float) fabs( nx * x + ny * y );
    }
}

// returns distance between 2 2D points.
float Utility::Distance(CvPoint2D32f *p1, CvPoint2D32f *p2)
{
	return sqrt(pow(p1->x-p2->x,2) + pow(p1->y-p2->y,2));
}

