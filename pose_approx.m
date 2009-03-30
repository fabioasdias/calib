function [R T]=pose_approx(c,x,X)
%function [R T]=pose_approx(c,x,X)
%estimates extrinsic parameters
% REQUIRES "TRIOD" CALIBRATION PATTERN

if (size(x,1)~=2)
    x=x';
end
%% temporary calibration data
nc=c;
nc.R=eye(3);
nc.T=[0;0;1];
nc.RT=[nc.R nc.T];

disp('To use this code, always measure the points of each direction in order, from the center.');
disp('IT WILL NOT WORK OTHERWISE!');

%% estimating T3

% average size of the calibration pattern - approx. square
dx=max([max(x(1,:))-min(x(1,:)) max(x(2,:))-min(x(2,:))]);

xu=projection(nc,X,1);

tol=dx/10; % 10% tolerance
previous=Inf;
current=f_t3;
%T3 is bigger than 1!
while any(any(isnan(xu)))||(abs(current-previous)>tol)
    nc.T(3)=nc.T(3)*1.1; % 10% increase each iteration - ESTIMATION -> doesn't work properly with tol too low.
    nc.RT=[nc.R nc.T];
    xu=projection(nc,X,1);
    previous=current;
    current=f_t3;
end


%% Now we estimate T1 e T2
mx=mean(x');

%supposing zero
x0=[0;0];
aux=fminsearch(@f_t12,x0);
nc.T(1)=aux(1);
nc.T(2)=aux(2);
nc.RT=[nc.R nc.T];
xu=projection(nc,X,1); %updating values

%% finding rotation matrix R

id1=find(X(:,1)==max(X(:,1))); %ids of each extremity
id2=find(X(:,2)==max(X(:,2)));
id3=find(X(:,3)==max(X(:,3)));

tx1=calculateAngle(x(:,id1-1),x(:,id1));
tx2=calculateAngle(x(:,id2-1),x(:,id2));
tx3=calculateAngle(x(:,id3-1),x(:,id3));

aux=fminsearch(@f_R,[0;0;0]);
nc.R=mountMatrix(aux(1),aux(2),aux(3));
nc.RT=[nc.R nc.T];

R=nc.R;
T=nc.T;

%% plotting results
xu=projection(nc,X,1);
pl=input('Plot the reprojected points with the ESTIMATIVE of RT? []=no ','s');
if (~isempty(pl))
    figure,
    plot(xu(1,:),xu(2,:),'or');
    hold on
    plot(x(1,:),x(2,:),'xb');
    title('Blue = correct / Red = Reprojection results');
end


    %calculates de angle between two points
    function th=calculateAngle(center,extremity)
        extremity=extremity-center;
        th=rad2deg(cart2pol(extremity(1),extremity(2)));
        if (th<0)
            th=th+360;
        end
        
    end

    %error function for R optimization. 
    %Tries to minimize the relative angles of each extremity wrt to the
    %center
    function e=f_R(vector)
        nc.R=mountMatrix(vector(1),vector(2),vector(3));
        nc.RT=[nc.R nc.T];
        xu=projection(nc,X,1); 
        txu1=calculateAngle(xu(:,id1-1),xu(:,id1));
        txu2=calculateAngle(xu(:,id2-1),xu(:,id2));
        txu3=calculateAngle(xu(:,id3-1),xu(:,id3));
        e=sum(sqrt((tx1-txu1)^2+(tx2-txu2)^2+(tx3-txu3)^2));
    end

    %Given three angles, returns the rotation matrix
    function R=mountMatrix(a1,a2,a3)
        R1=[1         0         0        ;...
            0         cosd(a1)  -sind(a1);...
            0         sind(a1)  cosd(a1) ];
        
        R2=[cosd(a2)  0         sind(a2) ;...
            0         1         0        ;...
            -sind(a2) 0         cosd(a2) ];
        
        R3=[cosd(a3)  -sind(a3) 0        ;...
            sind(a3)  cosd(a3)  0        ;...
            0         0         1        ];
        R=R1*R2*R3;
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
    function e=f_t3
        du=max([max(xu(1,:))-min(xu(1,:)) max(xu(2,:))-min(xu(2,:))]);
        e=sum(sqrt((du-dx).^2));
    end
end