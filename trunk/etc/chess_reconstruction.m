function X=chess_reconstruction(nFrames,x_left,x_right,om,T,fc_left,fc_right,cc_left,cc_right,kc_left,kc_right)

% x_left=read_dat_dvideo(pick('dat'));
% x_right=read_dat_dvideo(pick('dat'));
% load('Calib_Results_stereo.mat');

%nFrames=650;%1100;%size(x_left,1);
x_left=x_left(1:nFrames,:,:);
x_right=x_right(1:nFrames,:,:);
nPoints=size(x_left,3);

sParam=0.1;
for p=1:nPoints
    %figure(p),subplot(2,1,1),plot(x_left(:,1,p),x_left(:,2,p),'+r');hold on;grid on;
    x_left(:,:,p) =csaps(1:nFrames,squeeze(x_left (:,:,p))',sParam,1:nFrames)';
    %figure(p),subplot(2,1,1),plot(x_left(:,1,p),x_left(:,2,p),'ob-');hold on;grid on;
%    figure(p),subplot(2,1,2),plot(x_right(:,1,p),x_right(:,2,p),'+r');hold on;grid on;
    x_right(:,:,p)=csaps(1:nFrames,squeeze(x_right(:,:,p))',sParam,1:nFrames)';
%    figure(p),subplot(2,1,2),plot(x_right(:,1,p),x_right(:,2,p),'ob-');hold on;grid on;
end

X=zeros(nFrames,3,nPoints);
for f=1:nFrames
    for p=1:nPoints
        xlc=x_left(f,:,p)';
        xrc=x_right(f,:,p)';
        X(f,:,p)=fsolve(@fcn_opt,[1;1;1],optimset('MaxFunEvals',1E6,'Algorithm','levenberg-marquardt','TolFun',1e-26));%,'TolX',1e-6));
    end
end

save temp1

    function err=fcn_opt(Xt)
       xl=project_points2(Xt,[0 0 0]',[0 0 0]',fc_left,cc_left,kc_left,0);
       xr=project_points2(Xt,om,T,fc_right,cc_right,kc_right,0);
       err= sum(sum((xl-xlc).^2+(xr-xrc).^2));
    end

end