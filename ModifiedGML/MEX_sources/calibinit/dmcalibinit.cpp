/* $Id: dmcalibinit.cpp,v 1.18 2005/04/19 06:21:03 dmoroz Exp $*/

/*
    The algorithms developed and implemented by Vezhnevets Vldimir aka Dead Moroz.
    <a href="mailto:vvp@graphics.cs.msu.ru">vvp@graphics.cs.msu.ru</a>
	See http://graphics.cs.msu.su/en/research/calibration/opencv.html for detailed information.
	Reliability additions and modifications made by Philip Gruebele.
	<a href="mailto:pgruebele@cox.net">pgruebele@cox.net</a>
*/ 

//#include "stdafx.h"
#include <stdio.h>
#include <opencv/cv.h>
//#include <_cv.h>
//#define DEBUG_DRAW
#include "dmcalibinit.h"
#include "dmcalibinternal.h"
#include "utility.h"

// only need this for showing images
#ifdef DEBUG_DRAW
#include <highgui.h>
#endif

//=====================================================================================
// Implementation for the enhanced calibration object detection
//=====================================================================================


#define PROCESSED_CORNER 1
#define MAX_CONTOUR_APPROX  7


typedef struct CvContourEx
{
	CV_CONTOUR_FIELDS()
	   int counter;
}
CvContourEx;

IplImage *g_ppDebugImages[DEBUG_IMG_NUM] = {NULL, NULL, NULL, NULL, NULL, NULL};


//=====================================================================================

double DQuadInfo::GetMinDim()
{
  double dMin = CV_SQR(m_pCorners[0]->m_vPoint.x - m_pCorners[3]->m_vPoint.x) + 
                CV_SQR(m_pCorners[0]->m_vPoint.y - m_pCorners[3]->m_vPoint.y),
         dTemp;

  for (int i = 0; i < 3; i++)
  {
    dTemp = CV_SQR(m_pCorners[i]->m_vPoint.x - m_pCorners[i + 1]->m_vPoint.x) + 
            CV_SQR(m_pCorners[i]->m_vPoint.y - m_pCorners[i + 1]->m_vPoint.y);

    dMin = MIN(dMin, dTemp);
  }  

  return dMin;
}

//=====================================================================================

int compare( const void *arg1, const void *arg2 )
{
   /* Compare all of both strings: */
   return ( * ( double* ) arg1 > * ( double* ) arg2 ) - ( * ( double* ) arg1 < * ( double* ) arg2 );
}

//=====================================================================================

CV_IMPL
   bool dmFindChessBoardCornerGuesses( const void* arr, void* thresharr,
									 CvMemStorage * storage,
									 CvSize etalon_size, CvPoint2D32f * corners,
									 int *corner_count, int in_bAdaptiveThresh)
{
	CvStatus result = CV_NO_ERR;
	int iQuadCount,
	   iCornerCount,
	   iGroups,
	   iCount,
	   i,
     dilations;

	*corner_count = 0;  // philipg. Without this, if no corners are found, the function does not clear this...

	DQuadInfo	*pQuads			= NULL,
				**ppQuadGroup	= NULL;
	// Corners of internal part of object
	DCornerInfo	*pCorners		= NULL,
				**ppCornerGroup	= NULL;

	CV_FUNCNAME( "dmFindChessBoardCornerGuesses" );

	__BEGIN__;

	result = CV_NOTDEFINED_ERR;

	CvMat  stub, *img = (CvMat*)arr;
	CvMat  thstub, *thresh = (CvMat*)thresharr;
	CvSize size;

	CV_CALL( img    = cvGetMat( img, &stub ));
	CV_CALL( thresh = cvGetMat( thresh, &thstub ));

	if( CV_MAT_TYPE( img->type ) != CV_8UC1 ||
	   CV_MAT_TYPE( thresh->type ) != CV_8UC1 )
		CV_ERROR( CV_BadDepth, cvUnsupportedFormat );

	if( !CV_ARE_SIZES_EQ( img, thresh ))
		CV_ERROR( CV_StsUnmatchedSizes, "" );

	size = cvGetMatSize( img );

#ifdef DEBUG_DRAW
	ReleaseTmpImages();
	for (i = 0; i < DEBUG_IMG_NUM; i++)
	{
		g_ppDebugImages[i] = cvCreateImage(size, IPL_DEPTH_8U, 3);
		cvCvtColor(img, g_ppDebugImages[i], CV_GRAY2RGB);
		//cvCopy(img, g_ppDebugImages[i]);
	}
	ShowDebugImages();
#endif

	// Try our standard "1" dilation, but if etalon isnot found, iterate the whole procedure with higher dilations.
	// This is necessary because some squares simply do not separate properly with a single dilation.  However,
	// we want to use the minimum number of dilations possible since dilations cause the squares to become smaller,
	// making it difficult to detect smaller squares.
	for (dilations = 1; dilations <= 3; dilations++)
	{
		ThresholdImage(img, thresh, in_bAdaptiveThresh, etalon_size, dilations, (CvMat *)g_ppDebugImages[5]);

		// So we can find rectangles that go to the edge, we draw a white line around the image edge.
		// Otherwise FindContours will miss those clipped rectangle contours.
		// The border color will be the image mean, because otherwise we risk screwing up filters like cvSmooth()...
		cvLine(thresh, cvPoint(0,0), cvPoint(0,size.height-1), CV_RGB(255,255,255), 3, 8);
		cvLine(thresh, cvPoint(0,0), cvPoint(size.width-1, 0), CV_RGB(255,255,255), 3, 8);
		cvLine(thresh, cvPoint(size.width-1, 0), cvPoint(size.width-1, size.height-1), CV_RGB(255,255,255), 3, 8);
		cvLine(thresh, cvPoint(0,size.height-1), cvPoint(size.width-1, size.height-1), CV_RGB(255,255,255), 3, 8);

		iQuadCount = GenerateQuads(&pQuads, &pCorners, storage, thresh, etalon_size, (CvMat *)g_ppDebugImages[0]);

		// Rem - corners are quads * 4
		iCornerCount = iQuadCount * 4;

		if (iQuadCount < 1)
		{
			result = CV_NOTDEFINED_ERR;
			EXIT;
		}

	#ifdef DEBUG_DRAW
		for(i = 0; i < iQuadCount; i++ )
		{
			CvScalar color = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
			DrawQuad((CvMat *)g_ppDebugImages[5], &pQuads[i], color, 1);
			ShowDebugImages();
		}
	#endif //DEBUG_DRAW

		//  Find quad's neighbors
		FindQuadNeibors(pQuads, iQuadCount, pCorners, iCornerCount, (CvMat *)g_ppDebugImages[1]);

		iGroups = 0;

		ppQuadGroup = (DQuadInfo **)cvAlloc(sizeof(DQuadInfo *) * iQuadCount);
		ppCornerGroup = (DCornerInfo **)cvAlloc(sizeof(DCornerInfo *) * iCornerCount);

		do
		{
			iCount = FindConnectedQuads(pQuads, iQuadCount, ppQuadGroup, iGroups, (CvMat *)g_ppDebugImages[2]);

			// If iCount is more than it should be, this will remove those quads which cause maximum deviation from
			// a nice suqare etalon.
			iCount = CleanFoundConnectedQuads(iCount, ppQuadGroup, etalon_size, (CvMat *)g_ppDebugImages[2]);

			if (CheckQuadGroup(ppQuadGroup, iCount, ppCornerGroup, etalon_size, (CvMat *)g_ppDebugImages[3]))
			{
				// Copy corners to output array
				*corner_count = (etalon_size.width) * (etalon_size.height);

				for (i = 0; i < *corner_count; i++)
					corners[i] = ppCornerGroup[i]->m_vPoint;

				result = CV_OK;
				EXIT;
			}

			iGroups++;
		}
		while (iCount);
	}
	  
	//__CLEANUP__;
	__END__;

	cvFree( (void **)&pQuads );
	cvFree( (void **)&pCorners );
	cvFree( (void **)&ppQuadGroup );
	cvFree( (void **)&ppCornerGroup );

	return result == CV_OK;
}


//=====================================================================================

void ThresholdImage(CvMat *in_pImage, CvMat *out_pThreshImage, int in_bLocalAdaptive, CvSize in_etalon_size, int in_dilations, CvMat *out_pDebugImage)
{
	IplImage *pTempImage = (IplImage *)cvClone(in_pImage);

	if (in_bLocalAdaptive)
	{
		int size = (int)(in_pImage->width / in_etalon_size.width * 2.5);
		size = size + (1 - size & 1);

//	    cvSmooth(in_pImage, pTempImage, CV_BLUR, 3, 3);
//		cvDilate(pTempImage, out_pThreshImage, 0, 1);
		cvDilate(in_pImage, out_pThreshImage, 0, 1);

		// convert to binary
		cvAdaptiveThreshold(out_pThreshImage, pTempImage, 255, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY, size, 0);

		cvDilate(pTempImage, out_pThreshImage, 0, in_dilations);
	}
	else
	{
		// Make dilation before the thresholding.
		// It splits chessboard corners
		cvDilate( in_pImage, out_pThreshImage, 0, 1 );

		double mean;
		int thresh_level;

		// empiric threshold level
		mean = cvMean( in_pImage );
		thresh_level = cvRound( mean - 10 );
		thresh_level = MAX( thresh_level, 10 );

		// convert to binary
		cvThreshold(out_pThreshImage, out_pThreshImage, thresh_level, 255, CV_THRESH_BINARY);
	}

	//cvErode( in_pImage, out_pThreshImage, 0, 1 );

	cvRelease((void **)&pTempImage);
#ifdef DEBUG_DRAW
	if (out_pDebugImage)
	{
		cvCvtColor(out_pThreshImage, out_pDebugImage, CV_GRAY2RGB);
		ShowDebugImages();
	}
#endif //DEBUG_DRAW
}

// if we found too many connect quads, remove those which probably do not belong.
int CleanFoundConnectedQuads(int in_iQuadNum, DQuadInfo **in_ppQuadGroup, CvSize in_ElatonSize, CvMat *out_pDebugImage)
{
	CvMemStorage *storage1 = 0;

	int iCount; // number of quads this etalon should contain

	if (in_ElatonSize.height % 2)	
    iCount = ((in_ElatonSize.height + 1) >> 1) * (in_ElatonSize.width + 1);  
  else
    iCount = ((in_ElatonSize.width + 1) >> 1) * (in_ElatonSize.height + 1);  

  
	storage1	= cvCreateMemStorage(0);

	// if we have more quadrangles than we should, try to eliminate duplicates or ones which don't belong to the etalon rectangle...
	if (in_iQuadNum > iCount)
	{
		// create an array of quadrangle centers
		CvPoint2D32f *centers = (CvPoint2D32f *)cvMemStorageAlloc(storage1, sizeof(centers[0]) * in_iQuadNum);
		bool		*removed = (bool *)cvMemStorageAlloc(storage1, sizeof(removed[0]) * in_iQuadNum);
		CvPoint2D32f center;	// the center of the etalon
		center.x = center.y = 0;
		int i;

		for (i = 0; i < in_iQuadNum; i++)
		{
			removed[i] = false;

			centers[i].x = centers[i].y = 0;

			for (int j = 0; j < 4; j++)
			{
				CvPoint2D32f &pt = in_ppQuadGroup[i]->m_pCorners[j]->m_vPoint;

				centers[i].x +=  pt.x;
				centers[i].y +=  pt.y;
			}
			centers[i].x /=  4;
			centers[i].y /=  4;

			center.x += centers[i].x;
			center.y += centers[i].y;
		}
		center.x /=  in_iQuadNum;
		center.y /=  in_iQuadNum;

		// If we still have more quadrangles than we should, we try to eliminate bad ones based on minimizing the bounding box.
		// We iteratively remove the point which reduces the size of the bounding box of the blobs the most (since we want the rectangle to be as small as possible)

		// remove the quadrange that causes the biggest reduction in etalon size until we have the correct number
		while (in_iQuadNum > iCount)
		{
			int skip;
			float min_box_area = 1e10;
			int min_box_area_index = -1;

			// For each point, calculate box area without that point
			for (skip = 0; skip < in_iQuadNum; skip++)
			{
				// get bounding rectangle
				CvPoint2D32f temp = centers[skip];						// temporarily make index 'skip' the same as
				centers[skip] = center;									// etalon center (so it is not counted for convex hull)
				CvMat pointMat = cvMat(1, in_iQuadNum, CV_32FC2, centers);
				CvSeq	*hull = cvConvexHull2(&pointMat, storage1, CV_CLOCKWISE, 1);
				centers[skip] = temp;
				float hull_area = (float)fabs(cvContourArea(hull, CV_WHOLE_SEQ));

				// remember smallest box area 
				if (hull_area < min_box_area)
				{
					min_box_area = hull_area;
					min_box_area_index = skip;
				}
			}

#ifdef DEBUG_DRAW
			cvCircle(out_pDebugImage, cvPointFrom32f(centers[min_box_area_index]), 8, CV_RGB(0,255,255), 5, 8);
			ShowDebugImages();
#endif // DEBUG_RAW

			// remove any references to this quad as a neighbor
			for (int ii = 0; ii < in_iQuadNum; ii++)
				for (int jj = 0; jj < 4; jj++)
					if (in_ppQuadGroup[ii]->m_pNeibors[jj] == in_ppQuadGroup[min_box_area_index])
					{
						in_ppQuadGroup[ii]->m_pNeibors[jj] = NULL;
						in_ppQuadGroup[ii]->m_iCount--;
					}

			// remove the quad
			in_iQuadNum--;
			for (int ii = min_box_area_index; ii < in_iQuadNum; ii++)
				in_ppQuadGroup[ii]	= in_ppQuadGroup[ii+1];

			// set that point to the center of the etalon so it will no longer affect our ConvexHull calculation
			centers[min_box_area_index] = center;
		}
	}

	// release storages
	cvReleaseMemStorage(&storage1);

	return in_iQuadNum;
}

//=====================================================================================

int FindConnectedQuads(DQuadInfo *in_pQuadInfo, int in_iQuadNum,
					   DQuadInfo **out_ppQuadGroup, int in_iGroup,
					   CvMat *out_pDebugImage)
{
	int i, iCount;

	// Scan the array for a first unlabeled quad
	for (i = 0; i < in_iQuadNum; i++)
	{
		if (in_pQuadInfo[i].m_iCount > 0 && in_pQuadInfo[i].m_iGroup < 0)
			break;
	}

	if (i >= in_iQuadNum)
		return 0;

	// Start very simple recursive fill algorithm
	RecursiveFill(&in_pQuadInfo[i], in_iGroup);

	// Make array of pointers to current group
	iCount = 0;

	for (i = 0; i < in_iQuadNum; i++)
	{
		if (in_pQuadInfo[i].m_iGroup == in_iGroup)
		{
			out_ppQuadGroup[iCount] = &in_pQuadInfo[i];

#ifdef DEBUG_DRAW
			if (out_pDebugImage)
			{
				int c = 255 - (in_iGroup + 1) * 50;
				DrawQuad(out_pDebugImage, out_ppQuadGroup[iCount], CV_RGB(c,c,c));
				ShowDebugImages();
			}
#endif //DEBUG_DRAW

			iCount++;
		}
	}

	return iCount;
}

//=====================================================================================

void RecursiveFill(DQuadInfo *in_pSeed, int in_iGroup)
{
	int        i;
	DQuadInfo *pNeibor;

	// Mark current quad
	in_pSeed->m_iGroup = in_iGroup;

	// Fill all the neighbors
	for (i = 0; i < 4; i++)
	{
		if (!in_pSeed->m_pNeibors[i])
			continue;
		pNeibor = in_pSeed->m_pNeibors[i];

		if (pNeibor->m_iCount > 0 && pNeibor->m_iGroup == -1)
			RecursiveFill(pNeibor, in_iGroup);
	}
	return;
}

//=====================================================================================

bool CheckQuadGroup(DQuadInfo   **in_ppQuadGroup, int in_iCount,
					DCornerInfo **out_ppCorners, CvSize in_ObjDim,
					CvMat *out_pDebugImage)
{
	DQuadInfo *pLeftCurQuad = NULL,
	*pRightCurQuad = NULL,
	*pTempQuad;

	DCornerInfo **ppCorners = NULL;

	int        iTemp, iLeftPoint = -1, iRightPoint= -1, i, j, k, iTemp2,
	   iCornerCount = 0, iFoundCorners;
	double     dTestDist = 1e20, dTemp, dMinDist;
	bool       bTranspose = false;

	// board needs to be asymmetric
	if (in_ObjDim.width % 2 + in_ObjDim.height % 2 != 1)
		return false;

	if (in_ObjDim.height % 2)
	{
		iTemp = in_ObjDim.height;
		in_ObjDim.height = in_ObjDim.width;
		in_ObjDim.width = iTemp;

		bTranspose = true;
	}

	//-------------------------------------------
	// Check the number of quads
	if (in_iCount != ((in_ObjDim.width + 1) >> 1) * (in_ObjDim.height + 1))
		return false;

	// Find minimum square size
	for (i = 0; i < in_iCount; i++)
	{
		for (j = 0; j < 4; j++)
		{
			int next = j+1;
			if (next >= 4)
				next = 0;
			float dDist = Utility::Distance(&in_ppQuadGroup[i]->m_pCorners[j]->m_vPoint, &in_ppQuadGroup[i]->m_pCorners[next]->m_vPoint);

			if (dTestDist > dDist)
				dTestDist = dDist;
		}
	}

	// This distance is to check for points that are close to an etalon line.
	// It has to be big enough because of etalon curvature,
	// and small enough such that only points along the etalon line (H or V) are found.
	dTestDist = ceil(dTestDist * 0.5);

	//-------------------------------------------
	// Find one corner quad
	// (it has 4 neighbors, only one of which has 4 neighbors too)

	iTemp = 0;

	for (i = 0; i < in_iCount; i++)
	{
		iTemp2 = -1;
		if (in_ppQuadGroup[i]->m_iCount == 4)
		{
			int iLocalCount, j;

			iLocalCount = 0;
			for (j = 0; j < 4; j++)
			{
				if (in_ppQuadGroup[i]->m_pNeibors[j]->m_iCount == 4)
					iLocalCount++;
				if (in_ppQuadGroup[i]->m_pNeibors[j]->m_iCount == 1)
					iTemp2 = j;
			}

			if (iLocalCount <= 1)
			{
				iLeftPoint = iTemp2;
				pLeftCurQuad = in_ppQuadGroup[i];
				break;
			}
		}
	}

	if (!pLeftCurQuad || iLeftPoint < 0)
		return false;

#ifdef DEBUG_DRAW
	if (out_pDebugImage)
	{
		DrawQuad(out_pDebugImage, pLeftCurQuad, CV_RGB(0,0,0), 5);
		cvCircle(out_pDebugImage, cvPointFrom32f(pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint), 8, CV_RGB(0,255,0));
		ShowDebugImages();
	}
#endif //DEBUG_DRAW

	//-------------------------------------------
	// Find second corner quad
	// (it has 2 neighbors, only one of which has 4 neighbors)

	iTemp    = 0;
	dMinDist = 1e20;

	for (i = 0; i < in_iCount; i++)
	{
#ifdef DEBUG_DRAW
		DrawQuad(out_pDebugImage, in_ppQuadGroup[i], CV_RGB(128,0,0), 4);
		ShowDebugImages();
#endif //DEBUG_DRAW

		if (in_ppQuadGroup[i]->m_iCount == 2)
		{
			int iLocalCount, j;

			iLocalCount = 0;
			for (j = 0; j < 4; j++)
			{
				if (!in_ppQuadGroup[i]->m_pNeibors[j])
					continue;

				if (in_ppQuadGroup[i]->m_pNeibors[j]->m_iCount == 4)
					iLocalCount++;
			}

			if (iLocalCount == 1)
			{
				for (j = 0; j < 4; j++)
				{
					if (in_ppQuadGroup[i]->m_pNeibors[j] &&
						in_ppQuadGroup[i]->m_pNeibors[j]->m_iCount == 2)
					{
						// get number of inside corners which lie along this line (within dTestDist)
						int corners = CheckCornersCloseToLine(in_ppQuadGroup, in_iCount,
														pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint,
														in_ppQuadGroup[i]->m_pCorners[j]->m_vPoint,
														(int)dTestDist);

						// if this is same as elaton width, then we must have reached a top right corner point
						if (corners == in_ObjDim.width)
						{
							// distance between the line end points
							dTemp  = Utility::Distance(&pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint, &in_ppQuadGroup[i]->m_pCorners[j]->m_vPoint);

							if (dTemp <= dMinDist)
							{
								dMinDist = dTemp;
								pRightCurQuad = in_ppQuadGroup[i];
								iRightPoint = j;
							}
						}
						break;
					}
				}
			}
		}
	}

	if (!pRightCurQuad || iRightPoint < 0)
		return false;

#ifdef DEBUG_DRAW
	if (out_pDebugImage)
	{
		DrawQuad(out_pDebugImage, pRightCurQuad, CV_RGB(255,0,0), 2);
		cvCircle(out_pDebugImage, cvPointFrom32f(pRightCurQuad->m_pCorners[iRightPoint]->m_vPoint), 3, CV_RGB(0,255,0));
		ShowDebugImages();
	}
#endif //DEBUG_DRAW

	//-------------------------------------------
	// Pick up two corner points

	ppCorners = (DCornerInfo **)cvAlloc(sizeof(DCornerInfo *) * in_ObjDim.height * in_ObjDim.width);

	do
	{
		iFoundCorners = FindCornersCloseToLine(in_ppQuadGroup, in_iCount,
											   pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint,
											   pRightCurQuad->m_pCorners[iRightPoint]->m_vPoint,
											   &ppCorners[iCornerCount], (int)dTestDist);


#ifdef DEBUG_DRAW
		for (int lk = 0; (lk < iFoundCorners) && (out_pDebugImage); lk++)
			cvCircle(out_pDebugImage, cvPointFrom32f(ppCorners[iCornerCount + lk]->m_vPoint), 5, CV_RGB(0,0,255));
		ShowDebugImages();
#endif //DEBUG_DRAW

		if (iFoundCorners != in_ObjDim.width)
			break;

		iCornerCount += iFoundCorners;

		iTemp = 1;
		do
		{
			for (j = 0; j < 4; j++)
			{
				if (pLeftCurQuad->m_pNeibors[j]->m_iCount == iTemp &&
					!pLeftCurQuad->m_pCorners[j]->m_iDoneFlag)
				{
					iLeftPoint = j;
					break;
				}
			}
			iTemp++;
		}
		while (j >= 4 && iTemp < 3);

		if (j >= 4)
			break;

		do
		{
			for (j = 0; j < 4; j++)
			{
				if (pRightCurQuad->m_pNeibors[j] &&
					pRightCurQuad->m_pNeibors[j]->m_iCount > 0)
				{
					if (!pRightCurQuad->m_pCorners[j]->m_iDoneFlag)
					{
						iRightPoint = j;
						break;
					}
				}
			}

			// We failed to find next square with 4 neihbors - this can happen only at start
			if (j >= 4)
				pRightCurQuad = pRightCurQuad->m_pNeibors[iRightPoint];
		}
		while (j >= 4);


#ifdef DEBUG_DRAW
		if (out_pDebugImage)
		{
			cvCircle(out_pDebugImage, cvPointFrom32f(pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint), 3, CV_RGB(0,255,0));
			cvCircle(out_pDebugImage, cvPointFrom32f(pRightCurQuad->m_pCorners[iRightPoint]->m_vPoint), 3, CV_RGB(0,255,0));
			ShowDebugImages();
		}
#endif //DEBUG_DRAW

		iFoundCorners = FindCornersCloseToLine(in_ppQuadGroup, in_iCount,
											   pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint,
											   pRightCurQuad->m_pCorners[iRightPoint]->m_vPoint,
											   &ppCorners[iCornerCount], (int)dTestDist);


#ifdef DEBUG_DRAW
		for (lk = 0; (lk < iFoundCorners) && (out_pDebugImage); lk++)
			cvCircle(out_pDebugImage, cvPointFrom32f(ppCorners[iCornerCount + lk]->m_vPoint), 5, CV_RGB(0,0,255));
		ShowDebugImages();
#endif //DEBUG_DRAW

		if (iFoundCorners != in_ObjDim.width)
			break;

		iCornerCount += iFoundCorners;

		pTempQuad = pLeftCurQuad->m_pNeibors[iLeftPoint];
		for (j = 0; j < 4; j++)
		{
			if (pTempQuad->m_pNeibors[j] && pTempQuad->m_pNeibors[j]->m_iCount == 4 && pTempQuad->m_pNeibors[j] != pLeftCurQuad)
			{
				pLeftCurQuad = pTempQuad->m_pNeibors[j];

				for (k = 0; k < 4; k++)
				{
					if (pLeftCurQuad->m_pNeibors[k] == pTempQuad)
					{
						iLeftPoint = k;
						break;
					}
				}
				break;
			}
		}

		if (j >= 4 || k >= 4)
			// Failed to find next left quad and/or left point
			break;

		pTempQuad = pRightCurQuad->m_pNeibors[iRightPoint];
		for (j = 0; j < 4; j++)
		{
			if (pTempQuad->m_pNeibors[j] &&
				pTempQuad->m_pNeibors[j]->m_iCount == 2 &&
				pTempQuad->m_pNeibors[j] != pRightCurQuad)
			{
				pRightCurQuad = pTempQuad->m_pNeibors[j];

				for (k = 0; k < 4; k++)
				{
					if (pRightCurQuad->m_pNeibors[k] == pTempQuad)
					{
						iRightPoint = k;
						break;
					}
				}
				break;
			}
		}

		if (j >= 4 || k >= 4)
			// Failed to find next right quad and/or left point
			break;


#ifdef DEBUG_DRAW
		if (out_pDebugImage)
		{
			DrawQuad(out_pDebugImage, pLeftCurQuad, CV_RGB(0,0,0), 1);
			DrawQuad(out_pDebugImage, pRightCurQuad, CV_RGB(255,0,0), 1);

			cvCircle(out_pDebugImage, cvPointFrom32f(pLeftCurQuad->m_pCorners[iLeftPoint]->m_vPoint), 3, CV_RGB(0,255,0));
			cvCircle(out_pDebugImage, cvPointFrom32f(pRightCurQuad->m_pCorners[iRightPoint]->m_vPoint), 3, CV_RGB(0,255,0));
			ShowDebugImages();
		}
#endif //DEBUG_DRAW

	}
	while (1);

	if (iCornerCount == (in_ObjDim.width) * (in_ObjDim.height))
	{

		// calculate vector product, if it's positive,
		// reverse all the rows
		if( (ppCorners[in_ObjDim.width - 1]->m_vPoint.x - ppCorners[0]->m_vPoint.x) *
		   (ppCorners[in_ObjDim.width]->m_vPoint.y - ppCorners[in_ObjDim.width - 1]->m_vPoint.y) -
		   (ppCorners[in_ObjDim.width - 1]->m_vPoint.y - ppCorners[0]->m_vPoint.y) *
		   (ppCorners[in_ObjDim.width]->m_vPoint.x - ppCorners[in_ObjDim.width - 1]->m_vPoint.x) > 0 )
		{
			for( i = 0; i < in_ObjDim.width; i++ )
				for( j = 0; j < in_ObjDim.height / 2; j++ )
				{
					DCornerInfo *pTemp = ppCorners[j * in_ObjDim.width + i];

					ppCorners[j * in_ObjDim.width + i] =
					   ppCorners[(in_ObjDim.height - 1 - j) * in_ObjDim.width + i];
					ppCorners[(in_ObjDim.height - 1 - j) * in_ObjDim.width + i] = pTemp;
				}
		}

		// Transpose the corners
		if (bTranspose)
		{
			for (i = 0; i < in_ObjDim.height; i++)
				for (j = 0; j < in_ObjDim.width; j++)
					out_ppCorners[i + j * in_ObjDim.height] = ppCorners[j + i * in_ObjDim.width];
		}
		else
		{
			for (i = 0; i < in_ObjDim.height; i++)
				for (j = 0; j < in_ObjDim.width; j++)
					out_ppCorners[j + i * in_ObjDim.width] = ppCorners[j + i * in_ObjDim.width];
		}

		cvFree((void **)&ppCorners);
		return true;
	}
	else
	{
		cvFree((void **)&ppCorners);
		return false;
	}
}

//=====================================================================================

int FindCornersCloseToLine(DQuadInfo **in_ppQuadGroup, int in_iCount,
						   CvPoint2D32f in_vStart, CvPoint2D32f in_vFinish,
						   DCornerInfo **io_ppCorners, int in_iTestDist)
{

	int          i, j, k, iCount = 0;
	DCornerInfo *pTempCorner,
	*pFoundCorners[50];

	// Iterate through all quads in group
	for( i = 0; i < in_iCount; i++ )
	{
		// Through each point
		for (j = 0; j < 4; j++)
		{
			pTempCorner = in_ppQuadGroup[i]->m_pCorners[j];

			// if we already did this corner, or if the corner is not an inside corner, skip it
			if (pTempCorner->m_iDoneFlag || !in_ppQuadGroup[i]->m_pNeibors[j])
				continue;

			// get distance from point to line
			CvMat pointMat;
			float dist;
			float line[4];							
			// fit line
			CvPoint2D32f pts[2];
			pts[0] = in_vStart;
			pts[1] = in_vFinish;
			pointMat = cvMat(1, 2, CV_32FC2, pts);
			cvFitLine(&pointMat, CV_DIST_L2, 0, .01, .01, line);
			Utility::CalcDistPointToLine2D(&pTempCorner->m_vPoint, 1, line, &dist);

			if (dist < in_iTestDist)
			{
				float iCurDist;

				iCurDist = Utility::Distance(&in_vStart, &pTempCorner->m_vPoint);

				// Add it sorted by the distance from start point
				for (k = 0; k < iCount; k++)
				{
					float iDist;

					iDist = Utility::Distance(&in_vStart, &pFoundCorners[k]->m_vPoint);

					if (iDist > iCurDist)
						break;
				}

				if (k < iCount)
					memmove(&pFoundCorners[k + 1], &pFoundCorners[k], (iCount - k) * sizeof(DCornerInfo *));

				pFoundCorners[k] = pTempCorner;
				pFoundCorners[k]->m_iDoneFlag = PROCESSED_CORNER;
				iCount++;
				assert(iCount < 50);
			}
		}
	}

	for (k = 0; k < iCount; k++)
		io_ppCorners[k] = pFoundCorners[k];

	return iCount;
}


// returns the number of corners that lie within in_iTestDist of line(in_vStart->in_vFinish)
int CheckCornersCloseToLine(DQuadInfo **in_ppQuadGroup, int in_iCount, CvPoint2D32f in_vStart, CvPoint2D32f in_vFinish, int in_iTestDist)
{
	int          i, j, iCount = 0;

	DCornerInfo *pTempCorner,
	*pFoundCorners[50];

	// Iterate through all quads in group
	for( i = 0; i < in_iCount; i++ )
	{
		// Through each point
		for (j = 0; j < 4; j++)
		{
			pTempCorner = in_ppQuadGroup[i]->m_pCorners[j];

			// if we already did this corner, or if the corner is not an inside corner, skip it
			if (pTempCorner->m_iDoneFlag || !in_ppQuadGroup[i]->m_pNeibors[j])
				continue;

			// get distance from point to line
			CvMat pointMat;
			float dist;
			float line[4];							
			// fit line
			CvPoint2D32f pts[2];
			pts[0] = in_vStart;
			pts[1] = in_vFinish;
			pointMat = cvMat(1, 2, CV_32FC2, pts);
			cvFitLine(&pointMat, CV_DIST_L2, 0, .01, .01, line);
			Utility::CalcDistPointToLine2D(&pTempCorner->m_vPoint, 1, line, &dist);

			// if points is close enough to line, we count it
			if (dist < in_iTestDist)
			{
				pTempCorner->m_iDoneFlag = PROCESSED_CORNER;
				pFoundCorners[iCount] = pTempCorner;
				iCount++;
				assert(iCount < 50);
#ifdef DEBUG_DRAW
				cvCircle(g_ppDebugImages[4], cvPointFrom32f(pTempCorner->m_vPoint), 2, CV_RGB(255,255,0));
				ShowDebugImages();
#endif //DEBUG_DRAW
			}
		}
	}

	for (i = 0; i < iCount; i++)
		pFoundCorners[i]->m_iDoneFlag = 0;

	return iCount;
}

//=====================================================================================

bool IsLinesCross(int64 x1, int64 y1, int64 x2, int64 y2, int64 x3, int64 y3, int64 x4, int64 y4)
{
	int64 maxx1 = MAX(x1, x2), maxy1 = MAX(y1, y2);
	int64 minx1 = MIN(x1, x2), miny1 = MIN(y1, y2);
	int64 maxx2 = MAX(x3, x4), maxy2 = MAX(y3, y4);
	int64 minx2 = MIN(x3, x4), miny2 = MIN(y3, y4);

	if (minx1 > maxx2 || maxx1 < minx2 || miny1 > maxy2 || maxy1 < miny2)
		return false;  // Момент, када линии имеют одну общую вершину...


	int64 dx21 = x2 - x1, dy21 = y2 - y1; // Длина проекций первой линии на ось x и y
	int64 dx43 = x4 - x3, dy43 = y4 - y3; // Длина проекций второй линии на ось x и y
	int64 dx13 = x1 - x3, dy13 = y1 - y3;
	int64 div, mul;


	if ((div = (int64)((double)dy43 * dx21 - (double)dx43 * dy21)) == 0)
		return false; // Линии параллельны...

	if (div > 0)
	{
		if ((mul = (int64)((double)dx43 * dy13 - (double)dy43 * dx13)) < 0 || mul > div)
			return false; // Первый отрезок пересекается за своими границами...
		if ((mul = (int64)((double)dx21 * dy13 - (double)dy21 * dx13)) < 0 || mul > div)
			return false; // Второй отрезок пересекается за своими границами...
	}
	else
	{
		if ((mul = -(int64)((double)dx43 * dy13-(double)dy43 * dx13)) < 0 || mul > -div)
			return false; // Первый отрезок пересекается за своими границами...
		if ((mul = -(int64)((double)dx21 * dy13-(double)dy21 * dx13)) < 0 || mul > -div)
			return false; // Второй отрезок пересекается за своими границами...
	}

	return true;
}


//=====================================================================================

int  FindQuadNeibors(DQuadInfo *in_pQuads, int in_iQuadsNum,
					 DCornerInfo *in_pCorners, int in_iCornersNum,
					 CvMat *out_pDebugImage)
{
	int idx, i, k, j;
	DQuadInfo   *pMinQuad;
	DCornerInfo *pMinCorner;
	double dGlobalMinDist = 1e236, dMinQuadDim = 200;/*= 1e236;

	double *pMinQuadDim = (double *)cvAlloc(sizeof(double) * in_iQuadsNum);

	// Find minimum quad dimension
	for( idx = 0; idx < in_iQuadsNum; idx++ )
		pMinQuadDim[idx] = in_pQuads[idx].GetMinDim();

	qsort(pMinQuadDim, in_iQuadsNum, sizeof(double), compare);

	dMinQuadDim = pMinQuadDim[in_iQuadsNum / 2] / 4;
*/
	// Find quad neighbors
	for (idx = 0; idx < in_iQuadsNum; idx++)
	{
#ifdef DEBUG_DRAW
		DrawQuad(out_pDebugImage, &in_pQuads[idx], CV_RGB(255,0,0), 1);
		ShowDebugImages();
#endif //DEBUG_DRAW

		//   choose the points of the current quadrangle that are close to
		//   some points of the other quadrangles
		//   (it can happen for split corners (due to dilation) of the
		//   checker board). Search only in other quadrangles!

		// for each neighborless corner in of this quadrangle
		for (i = 0; i < 4; i++)
		{
			if (in_pQuads[idx].m_pNeibors[i])
				continue;

			CvPoint2D32f pt = in_pQuads[idx].m_pCorners[i]->m_vPoint;

			// Find the CLOSEST point
			double dMinDist = 1e236, dDist;
			int    iMinPoint = -1;
			bool bNotFound = true;

			dMinDist = 1e236;
			pMinQuad   = NULL;
			pMinCorner = NULL;

//			int pMinQuadIndex = 1;

			// find closest neighborless corner in all other quadrangles
			for (k = 0; k < in_iQuadsNum; k++)
			{
				if (k == idx)
					continue;

				for (j = 0; j < 4; j++)
				{
					if (in_pQuads[k].m_pNeibors[j])
						continue;

					int dx = (int)(pt.x - in_pQuads[k].m_pCorners[j]->m_vPoint.x);
					int dy = (int)(pt.y - in_pQuads[k].m_pCorners[j]->m_vPoint.y);

					dDist = dx * dx + dy * dy;

					if (dDist < dMinDist)
					{
						iMinPoint = j;
						pMinQuad = &in_pQuads[k];
//						pMinQuadIndex = k;
						dMinDist = dDist;
					}
				}
			}

			// we found a matching corner point?
			if (iMinPoint >= 0 && dMinDist < dMinQuadDim)
			{
				// If another point from our current quad is closer to pMinQuad, iMinPoint
				// than this one, then we don't count this one after all.
				// This is necessary to support small squares where otherwise the wrong 
				// corner will get matched to pMinQuad;
				int ii;
				for (ii = i+1; ii < 4; ii++)
				{
					CvPoint2D32f pt = in_pQuads[idx].m_pCorners[ii]->m_vPoint;
					int dx = (int)(pt.x - pMinQuad->m_pCorners[iMinPoint]->m_vPoint.x);
					int dy = (int)(pt.y - pMinQuad->m_pCorners[iMinPoint]->m_vPoint.y);
					dDist = dx * dx + dy * dy;

					if (dDist < dMinDist)
					{
						iMinPoint = -1;
						break;
					}
				}

				if (ii == 4)
				{
					if (!bNotFound)
						goto NextPoint;
					bNotFound = false;
				}
				else
					bNotFound = true;
			}
			else
				bNotFound = true;

			if (!bNotFound)
			{
				int ik;

				pMinCorner = pMinQuad->m_pCorners[iMinPoint];
				pMinCorner->m_vPoint.x = (pt.x + pMinCorner->m_vPoint.x) * 0.5f;
				pMinCorner->m_vPoint.y = (pt.y + pMinCorner->m_vPoint.y) * 0.5f;

				// Check that each corner is neighbor of different counters
				for (ik = 0; ik < in_pQuads[idx].m_iCount; ik++)
				{
					if (in_pQuads[idx].m_pNeibors[ik] == pMinQuad)
						break;
				}
				if (ik < in_pQuads[idx].m_iCount)
					break;

				for (ik = 0; ik < pMinQuad->m_iCount; ik++)
				{
					if (pMinQuad->m_pNeibors[ik] == &in_pQuads[idx])
						goto NextPoint;
				}
				if (ik < pMinQuad->m_iCount)
					break;

				// We've found one more corner - remember it
				in_pQuads[idx].m_iCount++;
				assert(in_pQuads[idx].m_iCount <= 4);
				in_pQuads[idx].m_pNeibors[i] = pMinQuad;
				in_pQuads[idx].m_pCorners[i] = pMinCorner;

				pMinQuad->m_iCount++;
				assert(pMinQuad->m_iCount <= 4);
				pMinQuad->m_pNeibors[iMinPoint] = &in_pQuads[idx];
				assert(pMinQuad->m_pCorners[iMinPoint] == pMinCorner);

#ifdef DEBUG_DRAW
				if (out_pDebugImage)
				{
					cvCircle(out_pDebugImage, cvPointFrom32f(pMinCorner->m_vPoint), 2, CV_RGB(255, 255, 255));
					cvCircle(out_pDebugImage, cvPointFrom32f(pMinCorner->m_vPoint), 4, CV_RGB(0, 255, 0));
					ShowDebugImages();
				}
#endif //DEBUG_DRAW

				dGlobalMinDist = MIN(dGlobalMinDist, dMinDist);
			}
		 NextPoint:;
		}
	}

	return (int)dGlobalMinDist;
}

//=====================================================================================

int GenerateQuads(DQuadInfo **out_ppQuads, DCornerInfo **out_ppCorners,
				  CvMemStorage *in_pStorage, CvMat *in_pThresh, CvSize in_ObjDim,
				  CvMat *out_pDebugImage)
{
	int iQuadCount = 0;
	CvSeq *src_contour = 0;
	CvMemStorage *storage1 = 0;
	CvSeq *root;
	CvContourEx* board = 0;
	CvContourScanner scanner;
	int min_size;
	CvSize size;
	const int min_approx_level = 2;
	const int max_approx_level = MAX_CONTOUR_APPROX;
	int quandrangles = 0,
	   idx;
	CvSeqReader reader;

	if (!out_ppCorners || !out_ppQuads)
		return 0;

	size = cvGetMatSize( in_pThresh );


	// empiric bound for minimal allowed perimeter for squares
	min_size = cvRound( size.width * size.height * .03 * 0.01 * 0.92);

	//   Create temporary storages.
	//   First one will store retrived contours and the
	//   second one - approximated contours.
	storage1	= in_pStorage ? cvCreateChildMemStorage( in_pStorage ) : cvCreateMemStorage(0);
	root		= cvCreateSeq(0, sizeof(CvSeq), sizeof(CvSeq*), storage1);

	// initialize contour retrieving routine
	scanner = cvStartFindContours(in_pThresh, storage1, sizeof( CvContourEx ), CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE);

	// Debug output
	//cvSetZero(img);

	// get all the contours one by one
	while ((src_contour = cvFindNextContour( scanner )) != 0)
	{
		CvSeq *dst_contour = 0;
		CvRect rect = ((CvContour*)src_contour)->rect;

#ifdef DEBUG_DRAW
		CvScalar color1 = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
		CvScalar color2 = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
		cvDrawContours(out_pDebugImage, src_contour, color1, color2, 0, 1);
		ShowDebugImages();
#endif //DEBUG_DRAW

		// reject contours with too small perimeter
		if (CV_IS_SEQ_HOLE(src_contour) && rect.width *rect.height >= min_size)
		{
			int approx_level;

			for (approx_level = min_approx_level; approx_level <= max_approx_level; approx_level++)
			{
				dst_contour = cvApproxPoly(src_contour, sizeof(CvContour), storage1, CV_POLY_APPROX_DP, (float)approx_level);
				// we call this again on its own output (because sometimes cvApproxPoly() does not simplify as much as it should).
				dst_contour = cvApproxPoly(dst_contour, sizeof(CvContour), storage1, CV_POLY_APPROX_DP, (float)approx_level);

				if (dst_contour->total == 4)
					break;
			}

#ifdef DEBUG_DRAW
		CvScalar color1 = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
		CvScalar color2 = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
		cvDrawContours(out_pDebugImage, dst_contour, color1, color2, 0, 1);
		ShowDebugImages();
#endif //DEBUG_DRAW

			quandrangles += dst_contour->total == 4;

			// reject non-quadrangles
			if (dst_contour->total == 4 && cvCheckContourConvexity(dst_contour))
			{
				CvPoint pt[4];
				int i;
				double d1, d2, p = cvContourPerimeter(dst_contour);
				double area = fabs(cvContourArea(dst_contour, CV_WHOLE_SEQ));

				double dx, dy;

				for (i = 0; i < 4; i++)
					pt[i] = *(CvPoint*)cvGetSeqElem(dst_contour, i);

				dx = pt[0].x - pt[2].x;
				dy = pt[0].y - pt[2].y;
				d1 = sqrt(dx*dx + dy*dy);

				dx = pt[1].x - pt[3].x;
				dy = pt[1].y - pt[3].y;
				d2 = sqrt(dx*dx + dy*dy);

				// philipg.  Only accept those quadrangles which are more square than rectangular and which are big enough
				double d3, d4;
				dx = pt[0].x - pt[1].x;
				dy = pt[0].y - pt[1].y;
				d3 = sqrt(dx*dx + dy*dy);
				dx = pt[1].x - pt[2].x;
				dy = pt[1].y - pt[2].y;
				d4 = sqrt(dx*dx + dy*dy);
				if (d3*4 > d4 && d4*4 > d3 && d3*d4 < area*1.5 && area > min_size)
				{
#ifdef DEBUG_DRAW
					CvScalar color1 = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
					CvScalar color2 = CV_RGB(255*rand()/RAND_MAX, 255*rand()/RAND_MAX, 255*rand()/RAND_MAX);
					cvDrawContours(out_pDebugImage, dst_contour, color1, color2, 0, 1);
					ShowDebugImages();
#endif //DEBUG_DRAW

					if (d1 >= 0.15 * p && d2 >= 0.15 * p)
					{
						CvContourEx* parent = (CvContourEx*)(src_contour->v_prev);
						parent->counter++;
						if (!board || board->counter < parent->counter)
							board = parent;
						dst_contour->v_prev = (CvSeq*)parent;
						cvSeqPush(root, &dst_contour);
					}
				}
			}
		}
	}

	// finish contour retrieving
	cvEndFindContours(&scanner);

	if (root->total < 1)
		return 0;

	int npoints = root->total;												// total quadrangels found
	int iCount = ((in_ObjDim.width + 1) >> 1) * (in_ObjDim.height + 1);		//

	// if we have more quadrangles than we should, try to eliminate duplicates or ones which don't belong to the etalon rectangle...
	if (npoints > iCount)
	{
		// create an array of quadrangle centers
		CvPoint2D32f *centers = (CvPoint2D32f *)cvMemStorageAlloc(storage1, sizeof(centers[0]) * npoints);
		bool		*removed = (bool *)cvMemStorageAlloc(storage1, sizeof(removed[0]) * npoints);
		CvPoint2D32f center;	// the center of the etalon
		center.x = center.y = 0;

		for (idx = 0; idx < npoints; idx++)
		{
			removed[idx] = false;

			src_contour = *(CvSeq**)cvGetSeqElem(root, idx);
			int i, total = src_contour->total;

			if (src_contour->v_prev != (CvSeq*)board)
				continue;

			assert(total == 4);

			cvStartReadSeq(src_contour, &reader, 0);

			centers[idx].x = centers[idx].y = 0;
			for (i = 0; i < total; i++)
			{
				CvPoint pt;
				CV_READ_SEQ_ELEM(pt, reader);

				centers[idx].x +=  pt.x;
				centers[idx].y +=  pt.y;
			}
			centers[idx].x /=  total;
			centers[idx].y /=  total;

			center.x += centers[idx].x;
			center.y += centers[idx].y;
		}
		center.x /=  npoints;
		center.y /=  npoints;
	}

	// Get memory
	*out_ppQuads = (DQuadInfo *)cvAlloc(root->total * sizeof(DQuadInfo));
	*out_ppCorners = (DCornerInfo *)cvAlloc(root->total * 4 * sizeof(DCornerInfo));
	memset(*out_ppCorners, 0, root->total * 4 * sizeof(DCornerInfo));
	memset(*out_ppQuads, 0, root->total * sizeof(DQuadInfo));

	if (!*out_ppQuads || !*out_ppCorners)
		return -1;

	// Create array of quads structures
	for (idx = 0; idx < root->total; idx++)
	{
		src_contour = *(CvSeq**)cvGetSeqElem( root, idx );
		int i, total = src_contour->total;

		if (src_contour->v_prev != (CvSeq*)board)
			continue;

		cvStartReadSeq(src_contour, &reader, 0);

		// Reset group ID
		(*out_ppQuads)[iQuadCount].m_iGroup = -1;

		assert(total == 4);

#ifdef DEBUG_DRAW
		// DEBUG output
		cvDrawContours(out_pDebugImage, src_contour, CV_RGB(255, 255, 0), CV_RGB(255, 255, 0), 0);
		ShowDebugImages();
#endif // DEBUG_RAW

		for( i = 0; i < total; i++ )
		{
			CvPoint pt;

			CV_READ_SEQ_ELEM( pt, reader );

			(*out_ppCorners)[iQuadCount * 4 + i].m_vPoint = cvPoint2D32f(pt.x, pt.y);
			(*out_ppQuads)[iQuadCount].m_pCorners[i] = &(*out_ppCorners)[iQuadCount * 4 + i];
		}

		iQuadCount++;
	}

	// release storages
	cvReleaseMemStorage( &storage1 );

	return iQuadCount;
}

#ifdef DEBUG_DRAW

//=====================================================================================

void DrawQuad(CvMat *out_pImage, DQuadInfo *in_pQuad, CvScalar in_ucColor, int in_iThick)
{
	cvLine(out_pImage,
		   cvPointFrom32f(in_pQuad->m_pCorners[0]->m_vPoint),
		   cvPointFrom32f(in_pQuad->m_pCorners[1]->m_vPoint),
		   in_ucColor, in_iThick);
	cvLine(out_pImage,
		   cvPointFrom32f(in_pQuad->m_pCorners[1]->m_vPoint),
		   cvPointFrom32f(in_pQuad->m_pCorners[2]->m_vPoint),
		   in_ucColor, in_iThick);
	cvLine(out_pImage,
		   cvPointFrom32f(in_pQuad->m_pCorners[2]->m_vPoint),
		   cvPointFrom32f(in_pQuad->m_pCorners[3]->m_vPoint),
		   in_ucColor, in_iThick);
	cvLine(out_pImage,
		   cvPointFrom32f(in_pQuad->m_pCorners[3]->m_vPoint),
		   cvPointFrom32f(in_pQuad->m_pCorners[0]->m_vPoint),
		   in_ucColor, in_iThick);
}

//=====================================================================================

void ReleaseTmpImages()
{
	for (int i = 0; i < DEBUG_IMG_NUM; i++)
		cvReleaseImage( &g_ppDebugImages[i] );
}

void ShowDebugImages()
{
	char str[50];
	for (int i = 0; i < DEBUG_IMG_NUM; i++)
	{
		sprintf(str, "g_ppDebugImages[%d]", i);
		cvShowImage(str, g_ppDebugImages[i]);
	}
}

#endif //DEBUG_DRAW
