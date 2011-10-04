function calib=calibration(F,L,radial)
%function calib=calibration(F,L,radial)
% F: X Y Z -> real world
% L: u v   -> image plane
% radial   -> 0/1 : linear or non-linear calibration


%multiplier/divisor to reduce the effect of the variation of the
%distortions in the optimizations
MULT=100;

%% toolbox
K=[];
if (radial==1)
    previous=input('Import calibration data from another toolbox? []=none ','s');
    
    if (~isempty(previous))
        previous=pick('mat');
        mat=load(previous);
        K=mat.KK;
        Kct=mat.kc;
        if ((Kct(4)==0)&&(Kct(5)==0))
            kps=0;
        else
            kps=1;
        end
    else
        %not using previous calibration from another toolbox.
        kps=input('Which distortion parameters ? ([],0=k / 1=kp / 2=kps): ');
        if (isempty(kps)||(kps==0))
            kps=0;
            distortions=[1;1;0;0;0];
        else
            distortions=[1;1;1;1;0];
        end
	dlt=input('Force DLT utilization? []=no ','s');
	if ~isempty(dlt);
          [Ktemp R T]=calibration_dlt(F,L);
	  
	else
          [K Kct mat]=wrapper_calculate_calib(F,L,distortions);
	  end
          
    end
     %the order of p parameters is changed in the toolbox
    kct_aux=Kct(4);
    Kct(4)=Kct(3);
    Kct(3)=kct_aux;

end
Ll=L;

full_otim=1;

if (~isempty(K))
    calib.KK=K;
    calib.dir.k=[Kct(1) Kct(2)];
    calib.dir.p=[Kct(3) Kct(4)];
    calib.dir.s=[0 0];
    calib.inv.k=[Kct(1) Kct(2)];
    calib.inv.p=[Kct(3) Kct(4)];
    calib.inv.s=[0 0];
    if (isempty(previous))
        full_otim=1;
    else
        full_otim=0;
    end
    [R T]=pose_approx(calib,L,F);
    calib.R=R;
    calib.T=T;
    calib.RT=[calib.R calib.T];
    calib.Ri=pinv(R);
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
    
    calib.dir.k=[0;0];
    calib.dir.p=[0;0];
    calib.dir.s=[0;0];
    
    calib.inv.k=[0;0];
    calib.inv.p=[0;0];
    calib.inv.s=[0;0];
    
    calib.P=calib.KK*calib.RT;
    K=calib.KK;
    r=rodrigues(calib.R);
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T];    
    fval=fcn_dir(x0);
else
    %% Gibbs vector for rotation
    r=rodrigues(R);

    if (full_otim==1)
        %% Direct model (3D -> image)
        if (isempty(kps)||(kps==0))
            %[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;k1;k2];
            x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;inicializa_k(Kct)*MULT];        
            [aux  fval] = fminsearch(@fcn_dir_k,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
            aux=[aux;0;0;0;0];
        else
            if (kps==1)
                %p also
                x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;inicializa_k(Kct)*MULT;inicializa_p(Kct)*MULT];
                [aux  fval]= fminsearch(@fcn_dir_kp,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
                aux=[aux;0;0];
            else
                if (kps==2)
                    % p & s
                    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;inicializa_k(Kct)*MULT;inicializa_p(Kct)*MULT;0;0];
                    [aux  fval] = fminsearch(@fcn_dir_kps,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
                end
            end
        end
        aux(13:18)=aux(13:18)/MULT;
                
    else
        x0=[r;T];
        [aux  fval]= fminsearch(@fcn_RT,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
        aux=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);aux;Kct(1);Kct(2);Kct(3);Kct(4);0;0];
    end

    %% rebuilding the matrix of the result
    [calib.KK calib.RT calib.dir.k calib.dir.p calib.dir.s]=convert_vet_calib(aux);
    calib.KKi=pinv(calib.KK);
    calib.R=calib.RT(1:3,1:3);
    calib.T=calib.RT(:,4);
    calib.Ri=pinv(calib.R);
    calib.P=calib.KK*calib.RT;
end
disp('P matrix');
disp(calib.P);
if (radial==1)
    disp('coefficients - Direct model');
    disp('k');
    disp(calib.dir.k');
    disp('p');
    disp(calib.dir.p');    
    disp('s');
    disp(calib.dir.s');

end
disp(sprintf('Calibration square error: %g',fval));






%% Inverse model (image -> image)
if (radial==1)
    disp('Starting inverse model');
    
    %if using chess, generate more points to 'fit'. disabled now to use
    %oulu model (temporary)
    if (full_otim==0)
        calib.inv=calib.dir;
        calib.inv.k(1)=NaN; % flagging the model
        
        
%         wantToChange=1;
%         while (~isempty(wantToChange))
%             for ii=1:3
%                 lower(ii)=input(sprintf('Lower value to be considered in the %d coordinate (same unit as .ref): ',ii));
%                 upper(ii)=input(sprintf('Upper value to be considered in the %d coordinate (same unit as .ref): ',ii));
%                 step(ii)=input(sprintf('Step to be considered in the %d coordinate (same unit as .ref): ',ii));
%             end
%             [F1 F2 F3]=meshgrid(lower(1):step(1):upper(1),lower(2):step(2):upper(2),lower(3):step(3):upper(3));
%             F1=reshape(F1,[1 numel(F1)]);
%             F2=reshape(F2,[1 numel(F2)]);
%             F3=reshape(F3,[1 numel(F3)]);
%             
%             Fl=[F1; F2; F3];
%             Ll=projection(calib,Fl,1);
%             figure,plot(Ll(1,:),Ll(2,:),'xred'),hold on,grid on
%             plot(L(:,1),L(:,2),'oblue');
%             title('blue: Original points / red: Generated points');
%             wantToChange=input('Proceed or change the limits? []=proceed ','s');
%         end
    else %remove this else when removing oulu
        Fl=F';
        Fl(4,:)=1;
        xup=calib.P*(Fl);
        xup=xup(1:2,:)./repmat(xup(3,:),[2 1]);
        
        if (isempty(kps)||(kps==0))
            %[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;k1;k2];
            x0=-inicializa_k(Kct);
            [aux  fval] = fminsearch(@fcn_inv_k,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
            aux=[aux;0;0;0;0];
        else
            if (kps==1)
                %p also
                x0=[-inicializa_k(Kct);inicializa_p(Kct)];
                [aux  fval]= fminsearch(@fcn_inv_kp,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
                aux=[aux;0;0];
            else
                if (kps==2)
                    % p & s
                    x0=[-inicializa_k(Kct);inicializa_p(Kct);0;0];
                    [aux  fval] = fminsearch(@fcn_inv_kps,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-16,'LevenbergMarquardt','on'));
                end
            end
        end
        
        calib.inv.k=aux(1:2);
        calib.inv.p=aux(3:4);
        calib.inv.s=aux(5:6);
        disp('coefficients - Inverse model');
        disp('k'); disp(calib.inv.k')
        disp('p'); disp(calib.inv.p')
        disp('s'); disp(calib.inv.s')
        disp(sprintf('Calibration square error: %g',fval));
    end
else
    calib.dir.k=[0 0];
end

dis=input('Display the reprojection of the calibration (direct)? []=no ','s');
if (~isempty(dis))
    figure,hold on,grid on
    plot(L(:,1),L(:,2),'ob');
    xu=projection(calib,F,1);
    plot(xu(1,:),xu(2,:),'+r');
    title('Blue: calibration / red: reprojection');
end



    function sum_error=fcn_dir_kps(x)
        x(13:18)=x(13:18)/MULT;
        sum_error=sum(sum( (projection(x,F,radial)-L').^2));
    end

    function sum_error=fcn_dir_kp(x)
        x(13:16)=x(13:16)/MULT;
        sum_error=sum(sum( (projection([x;0;0],F,radial)-L').^2));
    end

    function sum_error=fcn_dir_k(x)
        x(13:14)=x(13:14)/MULT;
        sum_error=sum(sum( (projection([x;0;0;0;0],F,radial)-L').^2));
    end

    function sum_error=fcn_dir(x)
        sum_error=sum(sum( (projection([x;0;0;0;0;0;0],F,radial)-L').^2));
    end


     function sum_error=fcn_RT(x)
         xl=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);x;Kct(1:4);0;0];
         sum_error=sum(sum((projection(xl,F,radial)-L').^2));
     end
 
  function sum_error=fcn_inv_k(x)
        calib.inv.k=x(1:2);
        calib.inv.p=[0;0];
        calib.inv.s=[0;0];
        sum_error=sum(sum((undistort_point(calib,Ll)-xup).^2));
    end
   
 
  function sum_error=fcn_inv_kp(x)
        calib.inv.k=x(1:2);
        calib.inv.p=x(3:4);
        calib.inv.s=[0;0];
        sum_error=sum(sum((undistort_point(calib,Ll)-xup).^2));
    end
   
 
    function sum_error=fcn_inv_kps(x)
        calib.inv.k=x(1:2);
        calib.inv.p=x(3:4);
        calib.inv.s=x(5:6);
        sum_error=sum(sum((undistort_point(calib,Ll)-xup).^2));
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
    function vetor= inicializa_p(kct)
        vetor=kct(3:4);
    end

end