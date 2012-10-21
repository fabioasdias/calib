#ifndef __DMCALIBINIT_H__
#define __DMCALIBINIT_H__
/* $Id: dmcalibinit.h,v 1.11 2005/04/19 06:21:03 dmoroz Exp $*/

/** @file dmcalibinit.h 
    \brief Header file for the enhanced calibration object detection

    The algorithms developed and implemented by Vezhnevets Vldimir aka Dead Moroz
    <a href="mailto:vvp@graphics.cs.msu.ru">vvp@graphics.cs.msu.ru</a>
	See http://graphics.cs.msu.su/en/research/calibration/opencv.html for detailed information.
	Reliability additions and modifications made by Philip Gruebele.
	<a href="mailto:pgruebele@cox.net">pgruebele@cox.net</a>
*/ 

#include <cv.h>

/** @defgroup Exported
    @{
*/

/// Function finds first approximation of internal corners on the chess board
/**   
  @param arr          source halftone image
  @param thresharr    temporary image where will the thresholded source image be stored.
  @param storage      memory storage to use (can be NULL)
  @param etalon_size  number of corners in checkerboard per row and per column.
  @param corners      pointer to array where found points will be stored
  @param corner_count number of corners found
  @param in_bLocalAdaptive flag to use local adaptive thresholding, is false - global thresholding is used

  @returns CV_OK if corners are found
*/

CVAPI(bool) dmFindChessBoardCornerGuesses( const void* arr, void* thresharr,
                                   CvMemStorage * storage,
                                   CvSize etalon_size, CvPoint2D32f * corners,
                                   int *corner_count, int in_bLocalAdaptive CV_DEFAULT(1));

/// @}
#endif //__DMCALIBINIT_H__
