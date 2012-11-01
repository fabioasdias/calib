function X=chess_reconstruction(x_left,x_right,om,T,fc_left,fc_right,cc_left,cc_right,kc_left,kc_right)

% x_left=read_dat_dvideo(pick('dat'));
% x_right=read_dat_dvideo(pick('dat'));
% load('Calib_Results_stereo.mat');

nFrames=size(x_left,1);
nPoints=size(x_left,3);

X=zeros(nFrames,3,nPoints);
for f=1:nFrames
    for p=1:nPoints
        xlc=x_left(f,:,p)';
        xrc=x_right(f,:,p)';
        X(f,:,p)=fminsearch(@fcn_opt,[0;0;0]);
    end
end



    function err=fcn_opt(Xt)
       xl=project_points2(Xt,[0 0 0]',[0 0 0]',fc_left,cc_left,kc_left,0);
       xr=project_points2(Xt,om,T,fc_right,cc_right,kc_right,0);
       err= sum(sum((xl-xlc).^2+(xr-xrc).^2));
    end

end