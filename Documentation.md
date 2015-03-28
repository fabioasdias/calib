

# Getting started - **Version [r27](https://code.google.com/p/calib/source/detail?r=27)** #
Updated 15/11/2008

http://calib.googlecode.com/files/CaLIBr27.zip

To make the toolbox functional:
  * Download it from the downloads page or checkout the svn,
  * Unzip it to any directory,
  * Add the main directory ~~and the lib and etc directories~~(not needed in releases>27) to the matlab path,
  * Type _calib_ in the matlab command prompt, to open the principal window:
  * Make sure that all needed data files (.dat/.ref **not** the .m) are in the **current** matlab directory.
  * **Do not** mix different versions of the toolbox!

~~**Important:** Adopt the Y axis (second value in each point) as _vertical_ axis. The third value (Z) must be the distance from the camera. Otherwise, J.B. Toolbox will not work properly.~~ (Weirdly enough, it does work).

![http://fabio.dias.googlepages.com/calib_inicial.png](http://fabio.dias.googlepages.com/calib_inicial.png)


## Calibration ##
The first button, _Calibration_, performs the camera calibration, using 2 provided files:
  1. One .dat file, following the dvideo format (detailed in the formats page of the wiki), with one measure per point. **Do not** try to perform camera calibration with two different measures of the same point.
  1. One .ref file, containing the 3D coordinates of the real world calibration pattern.

The user will be asked to provide each file, by selecting it on a list of all files with the same extension in the current directory. If only one file matches the criteria, it will be used automatically (a common case with the .ref file).

If you need to import the intrinsic parameters from J.Bouguet's toolbox (chessboard), enter a non-empty string when asked:
```
Import calibration data from another toolbox? []=none 
```

Then select the desired .mat file.


After the file selection step, it begins the computation of the calibration, using J. Bouguet's toolbox if possible, as follows:

```
WARNING: No image size (nx,ny) available. Setting nx=640 and ny=480. If these are not the right values, change values manually.
Aspect ratio optimized (est_aspect_ratio = 1) -> both components of fc are estimated (DEFAULT).
Principal point optimized (center_optim=1) - (DEFAULT). To reject principal point, set center_optim=0
Skew not optimized (est_alpha=0) - (DEFAULT)
Distortion not fully estimated (defined by the variable est_dist):
     Sixth order distortion not estimated (est_dist(5)=0) - (DEFAULT) .
Initialization of the principal point at the center of the image.
Initialization of the focal length to a FOV of 35 degrees.

Main calibration optimization procedure - Number of images: 1
Gradient descent iterations: 1...2...3...4...5...6...7...8...9...10...11...12...13...done
Estimation of uncertainties...done


Calibration results after optimization (with uncertainties):

Focal Length:          fc = [ 869.32279   869.09949 ] ± [ 8.63953   8.50968 ]
Principal point:       cc = [ 333.90951   225.45370 ] ± [ 17.84877   10.92310 ]
Skew:             alpha_c = [ 0.00000 ] ± [ 0.00000  ]   => angle of pixel axes = 90.00000 ± 0.00000 degrees
Distortion:            kc = [ -0.33259   0.16258   0.00036   0.00114  0.00000 ] ± [ 0.09242   0.38546   0.00213   0.00192  0.00000 ]
Pixel error:          err = [ 0.53191   0.88099 ]

Note: The numerical errors are approximately three times the standard deviations (for reference).

Starting value for K1: ([]=-0.33259) 
```

In this case, the toolbox has computed the K matrix (intrinsic parameters), remaining the RT matrix and the radial distortion coefficients.
In our toolbox, we consider two different ways to deal with radial distortion:
  * _Direct_ model: The (un)distortion is applied in the 3D data, projected to the camera plane, f<sub>d</sub>([R|T]X), where X is the 3D, real world, calibration points.
  * _Inverse_ model: The (un)distortion is applied to the image points, f<sub>d</sub>(K<sup>-1</sup>x<sub>d</sub>), where x<sub>d</sub> is the projection of the calibration points in the original (distorted) image.

**Important**: Usually the k1 parameter is **negative** in the direct model and **positive** in the inverse model, when the distortion is similar to the fisheye.

In this example, the toolbox uses the computed K1 as a initial value, which can be accepted (by pressing enter) or changed by the user. If no initial value is found, zero is used. By pressing enter, we get:

```
P matrix
  1.0e+006 *
   -0.0098   -0.0001   -0.0074    2.8904
   -0.0020   -0.0118    0.0010    2.4917
   -0.0000   -0.0000    0.0000    0.0048
K coefficients - Direct model
   -0.2659   -0.1505
Calibration square error: 151.988
Starting inverse model
Starting value for K1: ([]=0.33259) 
```


The toolbox shows the founded P matrix, the radial distortion coefficients and the calibration error, based on reprojection difference of the calibration points.
Then, it starts the computation of the inverse model.

```
K coefficients - Inverse model
   -0.2353   -0.3252
Calibration square error: 136.307
Camera c096.dat loaded
Plot the corrected points? []=no 
```

After the calibration of the two considered models, the toolbox corrects the original .dat  calibration file and performs another calibration, using a linear model (k1=k2=0). This linear calibration is used to generate the corresponding .cal file. At this point, we can examine the correction of the considered points by entering any text and pressing enter:


http://fabio.dias.googlepages.com/calib_reprojection.PNG

The 'xred' represents the original points and the 'oblue' the corrected .dat.

```
Plot the corrected points? []=no 2
Camera temp_aux.clb loaded

WARNING: No image size (nx,ny) available. Setting nx=640 and ny=480. If these are not the right values, change values manually.
Aspect ratio optimized (est_aspect_ratio = 1) -> both components of fc are estimated (DEFAULT).
Principal point optimized (center_optim=1) - (DEFAULT). To reject principal point, set center_optim=0
Skew not optimized (est_alpha=0) - (DEFAULT)
Distortion not fully estimated (defined by the variable est_dist):
     Sixth order distortion not estimated (est_dist(5)=0) - (DEFAULT) .
Initialization of the principal point at the center of the image.
Initialization of the focal length to a FOV of 35 degrees.

Main calibration optimization procedure - Number of images: 1
Gradient descent iterations: 1...2...3...4...5...6...7...8...9...10...11...12...13...14...15...16...17...done
Estimation of uncertainties...done


Calibration results after optimization (with uncertainties):

Focal Length:          fc = [ 889.15415   887.34580 ] ± [ 6.86764   6.82849 ]
Principal point:       cc = [ 307.58475   241.83786 ] ± [ 13.47160   8.68786 ]
Skew:             alpha_c = [ 0.00000 ] ± [ 0.00000  ]   => angle of pixel axes = 90.00000 ± 0.00000 degrees
Distortion:            kc = [ -0.10124   0.36961   0.00020   -0.00375  0.00000 ] ± [ 0.07158   0.31770   0.00384   0.00542  0.00000 ]
Pixel error:          err = [ 0.40765   0.85643 ]

Note: The numerical errors are approximately three times the standard deviations (for reference).

Using DLT - P
Linear DLT!
P matrix
  1.0e+005 *
    0.0026    0.0001   -0.0090    2.5973
   -0.0016   -0.0089   -0.0014    2.3742
   -0.0000   -0.0000   -0.0000    0.0052
Camera corr_c096.dat loaded
Please, enter the name for the clb/cal files: (without extension) 
```

Then the toolbox asks for the desired file name of the two results of the calibration, the **clb** file, used for undistorting another .dat files and the **cal** file, containing the linear projection, to be used in the analysis tools (dvideo).

---


## Undistort .dat ##
The second button corrects the radial distortion of a original .dat file, using a pre-calculated .clb file, created in the calibration step. **EVERY .DAT FILE MUST BE CORRECTED BEFORE USE IN OTHER ANALYSIS TOOLS, OTHERWISE THE DISTORTION WILL NOT BE CORRECTED**.

When we click on the _Undistort .dat_ button, it will ask for the original .dat file, using the exact same method as in the calibration part. Then we must provide the desired file name for the corrected .dat file:

```
Please, enter the desired name for the corrected dat: []=corr_c096.dat
```

If we just press enter, the suggested name will be used. This sugestion is made to avoid file overwriting, but **be careful** anyway. The next step is to provide the corresponding **clb** file.

The toolbox performs the distortion correction, preserving non measured points (-1), and saves the .dat file with the provided name.