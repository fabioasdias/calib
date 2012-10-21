#ifndef __DMCALIBINTERNAL_H__
#define __DMCALIBINTERNAL_H__
/* $Id: dmcalibinternal.h,v 1.4 2005/04/19 06:21:03 dmoroz Exp $*/

/** @file dmcalibinternal.h
\brief Header file for the internal functions for the enhanced calibration object detection

The algorithms developed and implemented by Vezhnevets Vldimir aka Dead Moroz
<a href="mailto:vvp@graphics.cs.msu.ru">vvp@graphics.cs.msu.ru</a>
See http://graphics.cs.msu.su/en/research/calibration/opencv.html for detailed information.
Reliability additions and modifications made by Philip Gruebele.
<a href="mailto:pgruebele@cox.net">pgruebele@cox.net</a>
*/

//#include <_cv.h>
#include <cv.h>

//=====================================================================================
/// Corner info structure
/** This structure stores information about the chessboard corner.*/

struct DCornerInfo
{
	/// Coordinates of the corner
	CvPoint2D32f m_vPoint;
	/// Processed flag
	int          m_iDoneFlag;
};


//=====================================================================================
/// Quadrangle contour info structure
/** This structure stores information about the chessboard quadrange.*/

struct DQuadInfo
{
	/// Number of quad neibors
	int m_iCount;
	/// Quad group ID
	int m_iGroup;
	/// Coordinates of quad corners
	DCornerInfo *m_pCorners[4];
	/// Pointers of quad neibors
	DQuadInfo   *m_pNeibors[4];

  /// Get minimum legnth side of the quadrangle
  double GetMinDim();
};

/// @defgroup Internal Internal functions
/// @{

//=====================================================================================
/// Threshold image to find the checkboard
/**
@param in_pImage         source image
@param out_pThreshImage  thresholded image
@param out_pDebugImage   image for output in debug mode
@param in_bLocalAdaptive flag to use local adaptive thresholding, is false - global thresholding is used
@param in_etalon_size	 size of the etalon
@param in_dilations		 number of post threshold dilations to perform (1-2)
*/

void ThresholdImage(CvMat *in_pImage, CvMat *out_pThreshImage, int in_bLocalAdaptive, CvSize in_etalon_size, int in_dilations, CvMat *out_pDebugImage CV_DEFAULT(NULL));

//=====================================================================================
/// Recursively labels adjacent quads
/**
@param in_pSeed        pointer to current seed in in_pQuadInfo array
@param in_iGroup       id number of current group to be found
*/

void RecursiveFill(DQuadInfo *in_pSeed, int in_iGroup);


//=====================================================================================
/// Forms groups of adjacent quadrangles
/**
@param in_pQuadInfo    pointer to array of all found quads
@param out_ppQuadGroup pointer to array, where pointers to quads will be stored
@param in_iQuadNum     number of total quads in in_pQuadInfo
@param in_iGroup       id number of current group to be found
@param out_pDebugImage  image for output in debug mode

@return number of found quadrangles in current group
*/

int FindConnectedQuads(DQuadInfo *in_pQuadInfo, int in_iQuadNum,
					   DQuadInfo **out_ppQuadGroup, int in_iGroup,
					   CvMat *out_pDebugImage CV_DEFAULT(NULL));


//=====================================================================================
/// Cleans found quadrangles
/**
@param in_iQuadNum     number of total quads in in_pQuadInfo
@param in_ppQuadGroup pointer to array, where pointers to quads will be stored
@param in_ElatonSize	the size of the etalon we are looking for.
@param out_pDebugImage  image for output in debug mode

@return number of found quadrangles lect after cleaning
*/
int CleanFoundConnectedQuads(int in_iQuadNum, DQuadInfo **in_ppQuadGroup, CvSize in_ElatonSize, CvMat *out_pDebugImage);

//=====================================================================================
/// Checks the quad group and extracts corners close to given line
/**
@param in_ppQuadGroup  pointer to array of pointers to this groups's quads
@param in_iCount       number of total quads in group
@param io_ppCorners    pointers extracted corners are stored here
@param in_iTestDist    maximum distance to line
@param in_vStart       start point of the line
@param in_vFinish      end point of the line

@return number of found points close to the line
*/

int FindCornersCloseToLine(DQuadInfo **in_ppQuadGroup, int in_iCount,
						   CvPoint2D32f in_vStart, CvPoint2D32f in_vFinish,
						   DCornerInfo **io_ppCorners, int in_iTestDist);

//=====================================================================================
/// Checks the quad group and extracts corners sorted by lines
/**
@param in_ppQuadGroup  pointer to array of pointers to this groups's quads
@param in_iCount       number of total quads in group
@param in_iExpected    number of expected points
@param in_iTestDist    maximum distance to line
@param in_vStart       start point of the line
@param in_vFinish      end point of the line

@return Maximum distance to the points close to line
*/

int CheckCornersCloseToLine(DQuadInfo **in_ppQuadGroup, int in_iCount, CvPoint2D32f in_vStart, CvPoint2D32f in_vFinish, int in_iTestDist);

//=====================================================================================
/// Checks intersection of two line segments
/**
@return true if intersection is detected
*/

bool IsLinesCross(int64 x11, int64 y11, int64 x12, int64 y12,
				  int64 x21, int64 y21, int64 x22, int64 y22);

//=====================================================================================
/// Generate quad contours from binary image
/**
@param out_ppQuads    pointer to array of all quads
@param out_ppCorners  pointer to array of extracted quad corners
@param in_pStorage    some OpenCV structure for memory management during contour retreival
@param in_pThresh     thresholded image of the checkboard

@return number of found quads
*/

int GenerateQuads(DQuadInfo **out_ppQuads, DCornerInfo **out_ppCorners,
				  CvMemStorage *in_pStorage, CvMat *in_pThresh, CvSize in_ObjDim,
				  CvMat *out_pDebugImage CV_DEFAULT(NULL));

//=====================================================================================
/// Creates neibor links in quad structures and corrects corner coordinates for adjacent quads
/**
@param in_pQuads      array all quads
@param in_iQuadsNu    number of total quads
@param in_pCorners    array of extracted corners
@param in_iCornersNum number of corners

@return Minimal distance between corners
*/

int FindQuadNeibors(DQuadInfo *in_pQuads, int in_iQuadsNum,
					DCornerInfo *in_pCorners, int in_iCornersNum,
					CvMat *out_pDebugImage CV_DEFAULT(NULL));


//=====================================================================================
/// Checks the quad group and extracts corners sorted by lines
/**
@param in_ppQuadGroup  pointer to array of pointers to this groups's quads
@param in_iCount       number of total quads in group
@param out_ppCorners   pointers to extracted corners are stored here
@param in_ObjDim       dimensions of the calibrated object

@return true if the group is the calibration object
*/

bool CheckQuadGroup(DQuadInfo   **in_ppQuadGroup, int in_iCount,
					DCornerInfo **out_ppCorners, CvSize in_ObjDim,
					CvMat *out_pDebugImage CV_DEFAULT(NULL));

/// @}

/// \defgroup Debug Debug functions
/// @{

/// Draws quad contour on image
#define DEBUG_IMG_NUM 6

#ifdef DEBUG_DRAW
extern IplImage *g_ppDebugImages[DEBUG_IMG_NUM];
void DrawQuad(CvMat *out_pImage, DQuadInfo *in_pQuad, CvScalar in_ucColor, int in_iThick = 1);
void ReleaseTmpImages();
void ShowDebugImages();
#endif
/// @}


#endif //__DMCALIBINTERNAL_H__
