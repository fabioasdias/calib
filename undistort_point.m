function xc=undistort_point(calib,x)
%function xc=undistort_point(calib,x)
%calib -> calibration struct
%x     -> original, distorted image points
%returns:
%xc    -> Corrected image points

if (isstruct(calib))
    k=calib.inv.k;
    p=calib.inv.p;
    s=calib.inv.s;
    KK=calib.KK;
    KKi=pinv(KK);
else
    error('calib invalid!');
end

if (min(size(x))>=2)
    if (size(x,1)>size(x,2))
        x=x';
    end
end
x(3,:)=1;

%projects onto image plane
xd=KKi*x;


%distortions Xd=>Xu
u=xd(1,:);
v=xd(2,:);


u2v2=u.^2+v.^2;
du=k(1).*u.*u2v2+k(2).*u.*(u2v2).^2+s(1).*u2v2+(p(1).*(3.*u.^2+v.^2)+2.*p(2).*u.*v);
dv=k(1).*v.*u2v2+k(2).*v.*(u2v2).^2+s(2).*u2v2+(p(2).*(3.*v.^2+u.^2)+2.*p(1).*u.*v);

xu=[u+du;v+dv;xd(3,:)];

xc=KK*xu;
xc=xc(1:2,:)./repmat(xc(3,:),[2 1]);
