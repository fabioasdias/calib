function calib=calibration(F,L,radial)
%function calib=calibration(F,L,radial)
% F: X Y Z -> real world
% L: u v   -> image plane
% radial   -> 0/1 : linear or non-linear calibration

%% sempre util ter o numero de pontos
tam=size(F,1);

%% toolbox
previous=nan;
if (radial==1)
    previous=input('Name of previous calibration data from another toolbox? []=none ','s');
end
if (~isempty(previous))&&(~isnan(previous))
    previous=pick('mat');
    mat=load(previous);
    K=mat.KK;
    Kct=mat.kc;
else
    [K Kct mat]=wrapper_calculate_calib(F,L);
end
Ll=L;

if (~isempty(K))

    Ll=normalize(Ll',mat.fc,mat.cc,mat.kc,mat.alpha_c)';

    %     tam=size(F,1);
    %
    %     A=zeros(2*tam,11);
    %     B=zeros(2*tam,1);
    %     disp('Linear DLT!');
    %     for ii=1:tam
    %         A(2*ii-1,:)=[F(ii,:) 1 0 0 0 0 -L(ii,1)*F(ii,:)];
    %         B(2*ii-1)=L(ii,1);
    %         A(2*ii  ,:)=[0 0 0 0 F(ii,:) 1 -L(ii,2)*F(ii,:)];
    %         B(2*ii)=L(ii,2);
    %     end
    %
    %     % 12 elements
    %     X=[A\B;1];




    %     aux=fminsearch(@fun_calib_RT,[0;0;0;1;1;1]);
    %     R=rodrigues(aux(1:3));
    %     T=aux(4:6);
    %     RT=[R T];

    %[omckk,Tckk,Rckk] = compute_extrinsic_init(x_kk,X_kk,fc,cc,kc,alpha_c)
    [omc T R]=compute_extrinsic_init(L',F',mat.fc,mat.cc,mat.kc,mat.alpha_c);
    [omc,T,R,JJ] = compute_extrinsic_refine(omc,T,L',F',mat.fc,mat.cc,mat.kc,mat.alpha_c,20,1E6);

    calib.R=R;
    calib.T=T;
    calib.KK=K;
    calib.RT=[calib.R calib.T];
    calib.Ri=pinv(R);
    calib.dir.k=[Kct(1) Kct(2)];
    calib.inv.k=-[Kct(1) Kct(2)];
    calib.P=calib.KK*calib.RT;

else
    %lets try the old'n'good DLT
    disp('Using DLT - P');
    [K R T]=calibration_dlt(F,L);
end


if (radial==0)
    disp('Using DLT - P');
    [calib.KK calib.R calib.T]=calibration_dlt(F,L);
    calib.RT=[calib.R calib.T];
    calib.Ri=pinv(R);
    calib.dir.k=[0 0];
    calib.P=calib.KK*calib.RT;
    K=calib.KK;
    r=rodrigues(calib.R);
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;0;0];    
    fval=fcn_dir(x0);
else

    %% Gibbs vector for rotation
    r=rodrigues(R);
    %    [teta phi mr]=cart2sph(r(1),r(2),r(3));

    %% Direct model (3D -> image)
    %[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;k1;k2];
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;inicializa_k(Kct)];
    [aux fval exitflag output] = fminsearch(@fcn_dir,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-8,'LevenbergMarquardt','on'));

    %% recompor as matrizes para o resultado
    [calib.KK calib.RT calib.dir.k]=convert_vet_calib(aux);
    calib.KKi=pinv(calib.KK);
    calib.R=calib.RT(1:3,1:3);
    calib.T=calib.RT(:,4);
    calib.Ri=pinv(calib.R);
    calib.P=calib.KK*calib.RT;
end
disp('P matrix');
disp(calib.P);
if (radial==1)
    disp('K coefficients - Direct model');
    disp(calib.dir.k');
end
disp(sprintf('Calibration square error: %g',fval));





%% Inverse model (image -> image)
if (radial==1)
    disp('Starting inverse model');
    x0=inicializa_k(-Kct);
    [aux fval exitflag output] = fminsearch(@fcn_inv,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-8,'LevenbergMarquardt','on'));
    calib.inv.k=aux(1:2);
    disp('K coefficients - Inverse model');
    disp(calib.inv.k');
    disp(sprintf('Calibration square error: %g',fval));
else
    calib.dir.k=[0 0];
end




%     function sum_error=fun_calib_RT(x)
%         Ri=rodrigues(x(1:3));
%         Ti=x(4:6);
%         Fl=F;
%         Fl(:,4)=1;
%         aux=[Ri Ti]*Fl';
%         aux=aux(1:2,:)./repmat(aux(3,:),[2 1]);
%         sum_error=sum(sqrt(sum((aux-Ll').^2,1)));
%     end

    function sum_error=fcn_dir(x)
        sum_error=sum(sum( (projection(x,F,radial)-L').^2));
    end
%     function sum_error=fcn_dir_ext(x)
%         xl=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);x];
%         sum_error=sum(sum((projection(xl,F,radial)-L').^2));
%     end
    function sum_error=fcn_inv(x)
        Fl=F';
        Fl(4,:)=1;
        xup=calib.P*(Fl);
        xup=xup(1:2,:)./repmat(xup(3,:),[2 1]);
        calib.inv.k=x(1:2);
        sum_error=sum(sum((undistort_point(calib,L)-xup).^2));
    end
    function vetor= inicializa_k(kct)
        k1=input(['Starting value for K1: ([]=' num2str(kct(1)) ') ']);
        if (isempty(k1))
            k=[kct(1);0];
        else
            k=[k1;0];
        end
        vetor=k;
    end
end