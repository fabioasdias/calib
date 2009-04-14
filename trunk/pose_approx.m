function [R T]=pose_approx(c,x,X)
%function [R T]=pose_approx(c,x,X)
%estimates extrinsic parameters
% REQUIRES "TRIOD" CALIBRATION PATTERN

MULT=100;

if (size(x,1)~=2)
    x=x';
end
%% temporary calibration data
nc=c;
nc.R=eye(3);
nc.T=[0;0;1];
nc.RT=[nc.R nc.T];

%% estimating T3

% average size of the calibration pattern - approx. square
dx=max([max(x(1,:))-min(x(1,:)) max(x(2,:))-min(x(2,:))]);

nc.T(3)=fminsearch(@f_t3,1);
nc.RT=[nc.R nc.T];
xu=projection(nc,X,1); %updating values



%% Now we estimate T1 e T2
mx=mean(x');

%supposing zero
x0=[nc.T(1);nc.T(2)];
aux=fminsearch(@f_t12,x0);
nc.T(1)=aux(1);
nc.T(2)=aux(2);
nc.RT=[nc.R nc.T];
xu=projection(nc,X,1); %updating values

%% finding rotation matrix R (and adapting T)
try
    [aux fval]=patternsearch(@fcn_RT,[0;0;MULT*pi;nc.T]);
catch %optimization toolbox not present
    [aux fval]=fminsearch(@fcn_RT,[0;0;MULT*pi;nc.T]);
end
aux(1:3)=aux(1:3)/MULT;
nc.R=mountMatrix(aux(1),aux(2),aux(3));
nc.T=aux(4:6);
nc.RT=[nc.R nc.T];

xu=projection(nc,X,1);


%% plotting results
pl=input(sprintf('Plot the reprojected points with the ESTIMATIVE of RT? (error=%d) []=no ',fval),'s');
if (~isempty(pl))
    figure,
    plot(xu(1,:),xu(2,:),'or');
    hold on
    plot(x(1,:),x(2,:),'xb');
    title('Blue = correct / Red = Reprojection results');
end
%returning values
R=nc.R;
T=nc.T;


    function sum_error=fcn_RT(vector)
        nc.R=mountMatrix(vector(1)/MULT,vector(2)/MULT,vector(3)/MULT);
        nc.T=vector(4:6);
        nc.RT=[nc.R nc.T];
        sum_error=sum(sum( (projection(nc,X,1)-x).^2));
    end

    %error function for T1 e T2 optimization
    % Tries do minimize the distance between the mean of the two groups of
    % points - calibration and reprojected
    function e=f_t12(t12)
        nc.T(1)=t12(1);
        nc.T(2)=t12(2);
        nc.RT=[nc.R nc.T];
        xu=projection(nc,X,1);
        mu=mean(xu');
        e=sum(sqrt((mx-mu).^2));
    end
        
    %error funtion for T3
    %Tries to minimize the 'scale' diference between the calibration and
    %reprojected points.
    function e=f_t3(t3)
        nc.T(3)=t3;
        nc.RT=[nc.R nc.T];
        xu=projection(nc,X,1);      
        du=max([max(xu(1,:))-min(xu(1,:)) max(xu(2,:))-min(xu(2,:))]);
        e=sum(sqrt((du-dx).^2));
    end
end