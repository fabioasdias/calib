function xc=undistort_point(calib,x)
%function xc=undistort_point(calib,x)
%calib -> calibration struct
%x     -> original, distorted image points
%returns:
%xc    -> Corrected image points


if (min(size(x))>=2)
    if (size(x,1)>size(x,2))
        x=x';
    end
end

if isnan(calib.inv.k(1))
    model=1;
else
    model=0;
end

if (model~=0)
    %oulu model. To be replaced with a better model
    if (isstruct(calib))
        k=calib.dir.k;
        p=calib.dir.p;
        KK=calib.KK;
    else
        error('calib invalid!');
    end
    
    
    kc=[k;p;0];
    fc=[KK(1,1) KK(2,2)];
    cc=[KK(1,3) KK(2,3)];
    alpha_c=KK(1,2)/KK(1,1);
    xc=normalize(x,fc,cc,kc,alpha_c);
    xc(3,:)=1;
    xc=KK*xc;
    xc=xc(1:2,:)./repmat(xc(3,:),[2 1]);
else
    
    if (isstruct(calib))
        k=calib.inv.k;
        p=calib.inv.p;
        s=calib.inv.s;
        KK=calib.KK;
        KKi=pinv(KK);
    else
        error('calib invalid!');
    end

    x(3,:)=1;
    
    %projects onto image plane
    xd=KKi*x;
    
    
    %distortions Xd=>Xu
    u=xd(1,:)./xd(3,:);
    v=xd(2,:)./xd(3,:);
    xd(3,:)=1;
    
    
    r2=u.^2+v.^2;
    du=u.*(k(1).*r2+k(2).*(r2).^2)...
        +s(1).*r2...
        +(p(1).*(3.*u.^2+v.^2)+2.*p(2).*u.*v);
    dv=v.*(k(1).*r2+k(2).*(r2).^2)...
        +s(2).*r2...
        +(p(2).*(3.*v.^2+u.^2)+2.*p(1).*u.*v);
    
    xu=[u-du;v-dv;xd(3,:)];
    
    xc=KK*xu;
    xc=xc(1:2,:)./repmat(xc(3,:),[2 1]);
end