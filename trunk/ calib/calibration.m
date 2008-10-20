function calib=calibration(F,L,radial)
%function calib=calibration(F,L,radial)
% F: X Y Z -> real world
% L: u v   -> image plane
% radial   -> 0/1 : linear or non-linear calibration

%% sempre util ter o numero de pontos
tam=size(F,1);

%% toolbox
[K Kct]=wrapper_calculate_calib(F,L);
Ll=L;
if (~isempty(K))
    Ki=pinv(K);

    Ll(:,3)=1;
    for i=1:tam
        Ll(i,:)=(Ki*Ll(i,:)')';
    end
    % x = K[R|T]X
    % K^{-1} x = [R | T]X
    Ll=Ll(:,1:2)./repmat(Ll(:,3),[1 2]);


    %% KLT
    A=zeros(2*tam,11);
    B=zeros(2*tam,1);
    disp('DLT computation - RT');
    %linear
    for ii=1:tam
        A(2*ii-1,:)=[F(ii,:) 1 0 0 0 0 -Ll(ii,1)*F(ii,:)];
        B(2*ii-1)=Ll(ii,1);
        A(2*ii  ,:)=[0 0 0 0 F(ii,:) 1 -Ll(ii,2)*F(ii,:)];
        B(2*ii)=Ll(ii,2);
    end
    %12 elements!
    RT=[A\B;1];
    % proper normalization, using the norm of one of the rotation vectors
    RT=RT*1/sqrt(sum(RT(9:11).^2));
    RT=unstack_matrix(RT,3,4);
    R=RT(1:3,1:3);
    T=RT(:,4);

else
    %lets try the old'n'good DLT
    disp('Using DLT - P');
    [K R T]=calibration_dlt(F,L);
end
    

%% Gibbs vector for rotation
r=rodrigues(R);
[teta phi mr]=cart2sph(r(1),r(2),r(3));

%% Direct model (3D -> image)
%[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;k1;k2];
if (radial==1)
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;inicializa_k(Kct)];
else
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T];%;inicializa_k(Kct)];
end
    

[aux fval exitflag output] = fminsearch(@fcn_dir,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-8,'LevenbergMarquardt','on'));

%% recompor as matrizes para o resultado
if (radial==0)
    aux=[aux' 0 0]';
end
[calib.KK calib.RT calib.dir.k]=convert_vet_calib(aux);
calib.KKi=pinv(calib.KK);
calib.R=calib.RT(1:3,1:3);
calib.T=calib.RT(:,4);
calib.Ri=pinv(calib.R);
calib.P=calib.KK*calib.RT;
disp('P matrix');
disp(calib.P);
disp('K coefficients - Direct model');
disp(calib.dir.k');
disp(sprintf('Calibration square error: %g',fval));



%% Inverse model (image -> image)
if (radial==1)
    disp('Starting inverse model');
    x0=inicializa_k(-Kct);
    [aux fval exitflag output] = fminsearch(@fcn_inv,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-8,'LevenbergMarquardt','on'));
    calib.inv.k=aux(1:2);
    disp('K coefficients - Inverse model');
    disp(calib.dir.k');
    disp(sprintf('Calibration square error: %g',fval));
else
    calib.dir.k=[0 0];
end
    function sum_error=fcn_dir(x)
        sum_error=sum(sum( (projection(x,F,radial)-L').^2));
    end
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
            k=[0;0];
        else
            k=[k1;0];
        end
        vetor=k;
    end
end