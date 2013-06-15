%function bResult = click_dm_calib
% Dead Moroz version of click_ima_calib
% tries evaluates the corners of the checkerboard automatically through an
% OpenCV procedure
%
% Sets bResult variable to 1 on success, 0 on failure

bResult = 0;

figure(2);
image(I);
colormap(map);
set(2,'color',[1 1 1]);
hold off;

if exist(['wintx_' num2str(kk)],'var'),
    eval(['wintxkk = wintx_' num2str(kk) ';']);
    if ~isempty(wintxkk) && ~isnan(wintxkk),
        eval(['wintx = wintx_' num2str(kk) ';']);
        eval(['winty = winty_' num2str(kk) ';']);
    end;
end;

fprintf(1,'Using (wintx,winty)=(%d,%d) - Window size = %dx%d      (Note: To reset the window size, run script clearwin)\n',wintx,winty,2*wintx+1,2*winty+1);

%==========================================
% Ask about squares size  & % Ask about squares number

if (~exist('n_sq_x','var'))||(isempty(n_sq_x))
    n_sq_x = n_sq_x_default; 
end;

if (~exist('n_sq_y','var'))||(isempty(n_sq_y))
    n_sq_y = n_sq_y_default; 
end;


if (exist('dX','var')~=1)||(exist('dY','var')~=1), % This question is now asked only once
    % Enter the size of each square


    n_sq_x = input(['Number of squares along the X direction, not counting the border ([]=' num2str(n_sq_x_default) ') = ']); %6
    n_sq_y = input(['Number of squares along the Y direction, not counting the border  ([]=' num2str(n_sq_y_default) ') = ']); %6
    if isempty(n_sq_x), n_sq_x = n_sq_x_default; end;
    if isempty(n_sq_y), n_sq_y = n_sq_y_default; end;
    n_sq_x_default = n_sq_x;
    n_sq_y_default = n_sq_y;


    % Check the squares number
    if (mod(n_sq_x, 2) +  mod(n_sq_y, 2) ~= 1)
        fprintf(1, 'Automatic detection only works with "even x odd" or "odd x even" squares configuration\n');
        fprintf(1, 'to remove ambiguity of the origin point\n');
        return;
    end;



    dX = input(['Size dX of each square along the X direction ([]=' num2str(dX_default) 'mm) = ']);
    dY = input(['Size dY of each square along the Y direction ([]=' num2str(dY_default) 'mm) = ']);
    if isempty(dX), dX = dX_default; else dX_default = dX; end;
    if isempty(dY), dY = dY_default; else dY_default = dY; end;

else

    fprintf(1,['Size of each square along the X direction: dX=' num2str(dX) 'mm\n']);
    fprintf(1,['Size of each square along the Y direction: dY=' num2str(dY) 'mm   (Note: To reset the size of the squares, clear the variables dX and dY)\n']);
    %fprintf(1,'Note: To reset the size of the squares, clear the variables dX and dY\n');

end;

%==========================================
% detect image points through DMoroz + OpenCV procedure
%I=imadjust(255-(imclose(I,strel('disk',20))-I));
[XX, Xgrid] = dmCornerDetect(I, n_sq_x + 2, n_sq_y + 2);


n_corners_x = n_sq_x + 1;
n_corners_y = n_sq_y + 1;

if (size(XX, 2) ~= n_corners_x * n_corners_y)
    fprintf(1, 'Automatic detection failed, sorry.\n');
    return;
end;


% reverse rows of the found corners for Z axis to point 'up'
XXTemp = reshape(XX, 2, n_corners_x, n_corners_y);
XXTemp = flipdim(XXTemp, 2);
XX = reshape(XXTemp, 2, n_corners_x * n_corners_y);

% to MatLab coordinates
XX = XX + 1;

% refine corners
grid_pts = cornerfinder(XX, I, winty, wintx); %%% Finds the exact corners at every points!
% to pixel coordinates
grid_pts = grid_pts - 1;

% Complete size of the rectangle
Xgrid(1, :) = Xgrid(1, :) * dX;
Xgrid(2, :) = Xgrid(2, :) * dY;


Np = n_corners_x * n_sq_y;

%==================================
% just drawing
delta = 30;

ind_corners = [1 n_corners_x (n_corners_x) * (n_corners_y - 1) + 1 (n_corners_x)*(n_corners_y)]; % index of the 4 corners
ind_orig = 1;
xorig = grid_pts(1, ind_orig);
yorig = grid_pts(2, ind_orig);
dxpos = mean([grid_pts(:,ind_orig) grid_pts(:,ind_orig + 1)]'); %#ok<UDIM>
dypos = mean([grid_pts(:,ind_orig) grid_pts(:,ind_orig + n_corners_x)]'); %#ok<UDIM>

% Direction of displacement for the X axis:
vX = dxpos - [xorig, yorig];
vX = vX / norm(vX);

% Direction of displacement for the X axis:
vY = dypos - [xorig, yorig];
vY = vY / norm(vY);

% Direction of diagonal:
vO = (dxpos + dypos) - [xorig, yorig];
vO = vO / norm(vO);

x_box_kk = [grid_pts(1,:)-(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)-(wintx+.5);grid_pts(1,:)-(wintx+.5)];
y_box_kk = [grid_pts(2,:)-(winty+.5);grid_pts(2,:)-(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)-(winty+.5)];

figure(3);
image(I); colormap(map); hold on;

plot(grid_pts(1,:)+1,grid_pts(2,:)+1,'r+');
plot(x_box_kk + 1, y_box_kk + 1,'-b');
plot(grid_pts(1, ind_corners) + 1, grid_pts(2, ind_corners) + 1, 'mo');
plot(xorig + 1, yorig + 1,'*m');
h = text(xorig+delta*vO(1),yorig+delta*vO(2),'O');
set(h,'Color','m','FontSize',14);
vTextPos = dxpos + delta * (vX - 0.5 * vY);
h2 = text(vTextPos(1), vTextPos(2),'dX');

set(h2,'Color','g','FontSize',14);
vTextPos = dypos + delta * (vY - 0.5 * vX);
h3 = text(vTextPos(1), vTextPos(2), 'dY');

set(h3,'Color','g','FontSize',14);
xlabel('Xc (in camera frame)');
ylabel('Yc (in camera frame)');
title('Extracted corners');
zoom on;
drawnow;
hold off;

%==================================
% save data

% All the point coordinates (on the image, and in 3D) - for global optimization:
x = grid_pts;
X = Xgrid;

% Saves all the data into variables:
eval(['dX_' num2str(kk) ' = dX;']);
eval(['dY_' num2str(kk) ' = dY;']);

eval(['wintx_' num2str(kk) ' = wintx;']);
eval(['winty_' num2str(kk) ' = winty;']);

eval(['x_' num2str(kk) ' = x;']);
eval(['X_' num2str(kk) ' = X;']);

eval(['n_sq_x_' num2str(kk) ' = n_sq_x;']);
eval(['n_sq_y_' num2str(kk) ' = n_sq_y;']);

bResult = 1;
return;