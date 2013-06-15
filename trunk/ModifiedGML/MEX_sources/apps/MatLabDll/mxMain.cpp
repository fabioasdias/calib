/* $Revision: 1.2 $ */
#include "mex.h" 
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <vector>
#include "../../CSL/base/gmlcommon.h"
#include "../../CSL/math/gmlmath.h"
#include "../../calibinit/dmcalibinit.h" 

//=======================================================================
//= Function name	: mexFunction
//= Description	    : 
//= Return type		: void 
//=======================================================================
 
bool CheckArguments(int nlhs, mxArray *plhs[], int nrhs,const mxArray *in_pArgs[])
{
  int  iWdt, iHgt, iDim;
  const mxArray *pImage, *pXDim, *pYDim;

  // Input argument - an image
  if (nrhs != 3)
  {
    mexPrintf("\nParameters expected: Image, iXSquares, iYSquares.", nrhs);
    return false;
  }

  pImage = in_pArgs[0];
  pXDim = in_pArgs[1];
  pYDim = in_pArgs[2];

  // Input argument - an image
  iDim = mxGetNumberOfDimensions(pImage);
  if (iDim != 2)
  {
    mexPrintf("\nThe input array dimensions should be 2.", nrhs);
    return false;
  }

  iWdt = mxGetN(pImage);
  iHgt = mxGetM(pImage);

  if (iWdt < 2 || iHgt < 2)
  {
    mexPrintf("\nImage is to small", nrhs);
    return false;
  }

  iDim = mxGetNumberOfDimensions(pXDim);
  iDim = mxGetNumberOfDimensions(pYDim);
  iDim = mxGetN(pXDim);
  iDim = mxGetM(pYDim);

  if (mxGetM(pXDim) != 1 || mxGetN(pXDim) != 1 ||
      mxGetM(pYDim) != 1 || mxGetN(pYDim) != 1)
  {
    mexPrintf("\nWrong calibration object dimensions", nrhs);
    return false;
  }
 
  return true;
}

//=======================================================================
//= Function name	: CopyPixels
//= Description	    : 
//= Return type		: void 
//=======================================================================

template <class T> void CopyPixels(const mxArray *in_pArray, IplImage *out_pImage,
                                   int in_iWdt, int in_iHgt, T in_Dummy)
{
  T             *pArrayData; 
  unsigned char *pImageData;
  int           iTotalElem, i, iStep = out_pImage->widthStep; 
  //int i;
  
  pArrayData = (T *)mxGetData(in_pArray);
  pImageData = (unsigned char *)out_pImage->imageData;

  iTotalElem = mxGetNumberOfElements(in_pArray);
  
  for (i = 0; i < iTotalElem; i++)  
  {
    int iX, iY;

    iY = i % in_iHgt;
    iX = i / in_iHgt;

    T Temp = *pArrayData++;
    pImageData[iY * iStep + iX] = (unsigned char)gml::Clipped(Temp, 0, 255);
  } 
}

//=======================================================================
//= Function name	: mxArrayToImage
//= Description	    : 
//= Return type		: void 
//=======================================================================

IplImage *mxArrayToImage(const mxArray *in_pArray)
{
  int        iWdt, iHgt;
  mxClassID  category = mxGetClassID(in_pArray);

  iWdt = mxGetN(in_pArray);
  iHgt = mxGetM(in_pArray);

  IplImage *pImage = cvCreateImage(cvSize(iWdt, iHgt), IPL_DEPTH_8U, 1);

  switch (category)
  {
    case mxUINT8_CLASS:
      {
        unsigned char Dummy;
        CopyPixels<unsigned char>(in_pArray, pImage, iWdt, iHgt, Dummy);
      }
      break;
    case mxDOUBLE_CLASS:
      {
        double Dummy;
        CopyPixels<double>(in_pArray, pImage, iWdt, iHgt, Dummy);
      }
      break;
  }

  return pImage;
}

//=======================================================================
//= Function name	: mxArrayToImage
//= Description	    : 
//= Return type		: void 
//=======================================================================

int mxArrayToInt(const mxArray *in_pArray)
{
  mxClassID  category = mxGetClassID(in_pArray);

  switch (category)
  {
    case mxINT32_CLASS:
      {
      int *pData = (int *) mxGetData(in_pArray);
      return *pData;
      break;
      }
    case mxUINT8_CLASS:
      {
      unsigned char *pData = (unsigned char *) mxGetData(in_pArray);
      return *pData;
      break;
      }
    case mxDOUBLE_CLASS:
      {
      double *pData = mxGetPr(in_pArray);
      return (int)*pData;
      }
      break;
  }
  return 0;
}

//=======================================================================
//= Function name	: mexFunction
//= Description	    : 
//= Return type		: void 
//=======================================================================

void mexFunction(int nlhs, mxArray *out_pArgs[], int nrhs,const mxArray *in_pArgs[])
{ 
  int            iWdt, iHgt, iObjXDim, iObjYDim, iCorners;
  const mxArray *pArray, *pXDim, *pYDim;
  std::vector<CvPoint2D32f> vCorners;

  if (!CheckArguments(nlhs, out_pArgs, nrhs, in_pArgs))
    return;

  pArray = in_pArgs[0];
  pXDim = in_pArgs[1];
  pYDim = in_pArgs[2];

  iWdt = mxGetN(pArray);
  iHgt = mxGetM(pArray);

  // Object dimensions
  iObjXDim = mxArrayToInt(pXDim);
  iObjYDim = mxArrayToInt(pYDim);

  IplImage *pImage = mxArrayToImage(pArray),
           *pThreshImage = cvCreateImage(cvSize(iWdt, iHgt), IPL_DEPTH_8U, 1);

  if (iObjXDim < 1 || iObjYDim < 1)
    return;

  vCorners.resize(iObjXDim * iObjYDim);

  // Call detect corners
  int bResult = dmFindChessBoardCornerGuesses(pImage, pThreshImage, NULL, cvSize(iObjXDim - 1, iObjYDim - 1),
                                &vCorners[0], &iCorners);

  if (bResult)
  {
    // Refine
    cvFindCornerSubPix( pImage, &vCorners[0], iCorners, cvSize(5,5), cvSize(iObjXDim - 1, iObjYDim - 1),
                        cvTermCriteria( CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 10, 0.01f ));

    mexPrintf("\nDetected %d corners\n", iCorners);

    // Pass back to matlab

    // The image points
    out_pArgs[0] = mxCreateDoubleMatrix(2, iCorners, mxREAL);
    double *pData = mxGetPr(out_pArgs[0]);
    for (int i = 0; i < iCorners; i++)
    {
      pData[i * 2] = vCorners[i].x;
      pData[i * 2 + 1] = vCorners[i].y;
    }

    // The 3D points
    out_pArgs[1] = mxCreateDoubleMatrix(3, iCorners, mxREAL);
    pData = mxGetPr(out_pArgs[1]);
    int i = 0;

    for (int iY = 0; iY < iObjYDim - 1; iY++)
      for (int iX = 0; iX < iObjXDim - 1; iX++)
      {
        pData[i * 3 + 0] = iX;
        pData[i * 3 + 1] = iY;
        pData[i * 3 + 2] = 0;
        i++;
      }
  }
  else
  {
    // Empty output arguments
    out_pArgs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
    out_pArgs[1] = mxCreateDoubleMatrix(0, 0, mxREAL);
  }

  cvReleaseImage(&pImage);
  cvReleaseImage(&pThreshImage);
}

