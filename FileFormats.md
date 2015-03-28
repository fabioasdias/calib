

# File Format definitions #

## .dat ##
Used to store 2D points in multiple frames.
Each line represents a frame.
A dat with N points and M frames must look like:

---

0 x<sub>01</sub> y<sub>01</sub> x<sub>02</sub> y<sub>02</sub> ... x<sub>0N</sub> y<sub>0N</sub>

...

M-1 x<sub>M1</sub> y<sub>M1</sub> x<sub>M2</sub> y<sub>M2</sub> ... x<sub>MN</sub> y<sub>MN</sub>

---


**Important**: The .dat files used for calibration may contain measures from different frames, but one measure for each point. **Do not** measure the same calibration point in two different frames.

## .ref ##
Used to store 3D points, usually containing the reference for calibration.
A ref with N points must look like:

---

0 X<sub>0</sub> Y<sub>0</sub> Z<sub>0</sub>

...

N-1 X<sub>N</sub> Y<sub>N</sub> Z<sub>N</sub>

---


Preferably, the Z axis should be vertical.

## .cal ##
The .cal must follow the dvideo format:
Code snippet

```
    dvideo=fopen([name '.cal'],'w');
    Pn=stack_matrix(calib.P);
    Pd=Pn/Pn(12);
    fprintf(dvideo,'%6.6g ',Pd(1));
    fprintf(dvideo,'%6.6g ',Pd(5));
    fprintf(dvideo,'%6.6g ',Pd(9));
    fprintf(dvideo,'%6.6g ',Pd(2));
    fprintf(dvideo,'%6.6g ',Pd(6));    
    fprintf(dvideo,'%6.6g ',Pd(10));
    fprintf(dvideo,'%6.6g ',Pd(3));
    fprintf(dvideo,'%6.6g ',Pd(7));
    fprintf(dvideo,'%6.6g ',Pd(11));
    fprintf(dvideo,'%6.6g ',Pd(4));
    fprintf(dvideo,'%6.6g ',Pd(8));

    fclose(dvideo);
```

## .clb ##
Each item in separated lines:
  1. KK matrix: fprintf(f,'%e ',calib.KK');
  1. RT matrix: fprintf(f,'%e ',calib.RT');
  1. Direct model coeff: fprintf(f,'%e %e\n',calib.dir.k(1),calib.dir.k(2));
  1. Direct model coeff: fprintf(f,'%e %e\n',calib.dir.p(1),calib.dir.p(2));
  1. Direct model coeff: fprintf(f,'%e %e\n',calib.dir.s(1),calib.dir.s(2));
  1. Inverse model coeff: fprintf(f,'%e %e\n',calib.inv.k(1),calib.inv.k(2));
  1. Inverse model coeff: fprintf(f,'%e %e\n',calib.inv.p(1),calib.inv.p(2));
  1. Inverse model coeff: fprintf(f,'%e %e\n',calib.inv.s(1),calib.inv.s(2));