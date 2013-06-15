function im=projection(calib,real,radial)
%function im=projection(calib,real)
%im: (u,v) -> projection of real by calib
%real: 3D real world points
%calib: calibration (load_calibration)
%radial: 0/1 uses radial coefficients

%%
% if the parameter is not provided, assume 1
if (~exist('radial','var'))
    radial=1;
end

if (min(size(real))>=3)
    if (size(real,1)>size(real,2))
        real=real';
    end
end
real(4,:)=1;

if (isstruct(calib))
    RT=calib.RT;
    KK=calib.KK;
    k=calib.dir.k;
    p=calib.dir.p;
    s=calib.dir.s;
else
    [KK RT k p s]=convert_vet_calib(calib);
end

point=RT*real;
point=point./repmat(point(3,:),[3 1]);

u=point(1,:);
v=point(2,:);
%distortion
if (radial==1)

    u2v2=u.^2+v.^2;

    du=k(1).*u.*u2v2+k(2).*u.*(u2v2).^2+s(1).*u2v2+(p(1).*(3.*u.^2+v.^2)+2.*p(2).*u.*v);
    dv=k(1).*v.*u2v2+k(2).*v.*(u2v2).^2+s(2).*u2v2+(p(2).*(3.*v.^2+u.^2)+2.*p(1).*u.*v);
else
    du=0;
    dv=0;
end
point=[u+du;v+dv;point(3,:)];

point=KK*point;
point=point./repmat(point(3,:),[3 1]);

im=point(1:2,:);
