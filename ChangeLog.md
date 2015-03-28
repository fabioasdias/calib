# Changelog summary for each release version #


## Release 82 05/11/2012 ##
New utility interface for marker tracking (markerTracking), see the [markerTracking guide](http://code.google.com/p/calib/wiki/MarkerTrackingGuide) for more information. Alpha stage.

## Release 75 21/10/2012 ##
Added testing support to .mov files. Added third party code to support evolutionary camera model (experimental).

## Release 61 06/08/2009 ##
Our modified version of the GML toolbox is now available in the SVN tree. Some minor changes in the code, to improve reliability.

## Release 56 18/05/2009 ##
Bug fix. One multiplication misused in one of the cases. Bug introduced in [r46](https://code.google.com/p/calib/source/detail?r=46), only occurs when using J.B.'s toolbox method.

## Release 54 14/04/2009 ##
  * The chess toolbox uses the p distortion parameters in other order than us. Fixed.
  * Correction in the projection equation (undistort\_point.m) of inverse model. Now subtracts the distortion instead of adding.

## Release 46 10/04/2009 ##
Major changes:
  * New method to **estimate R and T** when using chess calibration. A little more simple and (hopefully) robust.
  * Modifications in the error functions of the optimizations. Added a **factor in the distortions** to reduce the impact of small variations. As k1 usually is between 1 and -1 and T, for instance, is usually bigger than 100, we had to "normalize" the search space. This change is _internal_, does not affect the method, only improves the result (the search is better guided).
  * Supports **new distortion parameters** (decentering and thin prism): p (aka as k(3:4) from J. Bouguet's toolbox) and s.

## Release 44 30/03/2009 ##
Added a new algorithm to estimate extrinsic parameters when using a new, 9 points only, calibration pattern.

## Release 42 27/03/2009 ##
Distortion coefficients removed from the optimization step when using intrinsic parameters computed with J. Bouguet's toolbox.

## Release 40 21/03/2009 ##
Some issues related to [r27](https://code.google.com/p/calib/source/detail?r=27) fixed. (The non linear opt. now only considers extrinsic parameters when using the intrinsic parameters computed with J. Bouguet's toolbox).

## Release 27 15/11/2008 ##
Added support for importing the intrinsic parameters computed with J. Bouguet's toolbox.
(since [r17](https://code.google.com/p/calib/source/detail?r=17), with some minor bug corrections. Use [r27](https://code.google.com/p/calib/source/detail?r=27))
http://calib.googlecode.com/files/CaLIBr27.zip


## Release 6 12/11/2008 ##
First stable version.