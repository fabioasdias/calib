%if exist('images_read');
%   active_images = active_images & images_read;
%end;

var2fix = 'dX_default';

fixvariable;

var2fix = 'dY_default';

fixvariable;

var2fix = 'map';

fixvariable;


if ~exist('n_ima','var'),
    data_calib_no_read;
end;

check_active_images;

%if ~exist(['I_' num2str(ind_active(1))]),
%    ima_read_calib;
%    if isempty(ind_read),
%        disp('Cannot extract corners without images');
%        return;
%    end;
%end;


%% Step used to clean the memory if a previous atttempt has been made to read the entire set of images into memory:
for kk = 1:n_ima,
    if (exist(['I_' num2str(kk)],'var')==1),
        clear(['I_' num2str(kk)]);
    end;
end;



fprintf(1,'\nExtraction of the grid corners on the images\n');


if (exist('map','var')~=1), map = gray(256); end;


%disp('WARNING!!! Do not forget to change dX_default and dY_default in click_calib.m!!!')

if exist('dX','var'),
    dX_default = dX;
end;

if exist('dY','var'),
    dY_default = dY;
end;

if exist('n_sq_x','var'),
    n_sq_x_default = n_sq_x;
end;

if exist('n_sq_y','var'),
    n_sq_y_default = n_sq_y;
end;


if ~exist('dX_default','var')||~exist('dY_default','var');

    % Setup of JY - 3D calibration rig at Intel (new at Intel) - use units in mm to match Zhang
    dX_default = 19.1;
    dY_default = 19.1;

end;


if ~exist('n_sq_x_default','var')||~exist('n_sq_y_default','var'),
    n_sq_x_default = 5;
    n_sq_y_default = 8;
end;


if ~exist('wintx_default','var')||~exist('winty_default','var'),
    if ~exist('nx','var'),
        wintx_default = 5;
        winty_default = wintx_default;
        clear wintx winty
    else
        wintx_default = max(round(nx/128),round(ny/96));
        winty_default = wintx_default;
        clear wintx winty
    end;
end;


if ~exist('wintx','var') || ~exist('winty','var'),
    clear_windows; % Clear all the window sizes (to re-initiate)
end;



if ~exist('dont_ask','var'),
    dont_ask = 0;
end;


if ~dont_ask,
    ima_numbers = input('Number(s) of image(s) to process ([] = all images) = ');
else
    ima_numbers = [];
end;

if isempty(ima_numbers),
    ima_proc = 1:n_ima;
else
    ima_proc = ima_numbers;
end;


% Useful option to add images:
kk_first = ima_proc(1); %input('Start image number ([]=1=first): ');

%if isempty(kk_first), kk_first = 1; end;


if exist(['wintx_' num2str(kk_first)],'var'),

    eval(['wintxkk = wintx_' num2str(kk_first) ';']);

    if isempty(wintxkk) || isnan(wintxkk),

        disp('Window size for corner finder (wintx and winty):');
        wintx = input(['wintx ([] = ' num2str(wintx_default) ') = ']);
        if isempty(wintx), wintx = wintx_default; end;
        wintx = round(wintx);
        winty = input(['winty ([] = ' num2str(winty_default) ') = ']);
        if isempty(winty), winty = winty_default; end;
        winty = round(winty);

        fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);

    end;

else

    disp('Window size for corner finder (wintx and winty):');
    wintx = input(['wintx ([] = ' num2str(wintx_default) ') = ']);
    if isempty(wintx), wintx = wintx_default; end;
    wintx = round(wintx);
    winty = input(['winty ([] = ' num2str(winty_default) ') = ']);
    if isempty(winty), winty = winty_default; end;
    winty = round(winty);

    fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);

end;

% << Modified by DMoroz (Vezhnevets Vladimir)

% Do we need autodetect?
g_bAutoDetect = 1;
g_bAutoDetect = input('Do you want to use the automatic object detection? (0, 1=[]=default)');
if isempty(g_bAutoDetect)
    g_bAutoDetect = 1;
end;

manual_squares = 0;

if ~g_bAutoDetect
    if ~dont_ask,
        fprintf(1,'Do you want to use the automatic square counting mechanism (0=[]=default)\n');
        manual_squares = input('  or do you always want to enter the number of squares manually (1,other)? ');
        if isempty(manual_squares),
            manual_squares = 0;
        else
            manual_squares = ~~manual_squares;
        end;
    else
        manual_squares = 0;
    end;
end;
% >> end Modified by DMoroz (Vezhnevets Vladimir)
if ((strcmpi(format_image,'avi')==1)||(strcmpi(format_image,'mov')==1))
    ima_name=[calib_name '.' format_image];
    Ivid=mmreader(ima_name);
end

for kk = ima_proc,

    read_ok=0;
    % by F
    if ((strcmpi(format_image,'avi')==1)||(strcmpi(format_image,'mov')==1))
        I=read(Ivid,kk);
        auxWriteSkip(ima_name,kk);
        I=double(I);
        read_ok=1;
    else
        if ~type_numbering,
            number_ext =  num2str(image_numbers(kk));
        else
            number_ext = sprintf(['%.' num2str(N_slots) 'd'],image_numbers(kk));
        end;

        ima_name = [calib_name  number_ext '.' format_image];


        if exist(ima_name,'file'),

            fprintf(1,'\nProcessing image %d...\n',kk);

            fprintf(1,'Loading image %s...\n',ima_name);
            read_ok=1;

        end
    end
    if (read_ok==1)
        if (length(size(I))==3)
            I=rgb2gray(I);
        end

        [ny,nx,junk] = size(I);
        Wcal = nx; % to avoid errors later
        Hcal = ny; % to avoid errors later


        if (~exist('sowhat','var'))
            sowhat=[];
        end
        
        disp(sprintf('_\n\n Frame %g\n',kk));
        % << Modified by DMoroz (Vezhnevets Vladimir)
        if (g_bAutoDetect)
            if (auxCheckSkip(ima_name,kk)==0)
                click_dm_calib_noread;
                auxRemoveSkip(ima_name,kk);
            else
                disp(sprintf('Frame marked to skip automatic detection: %d',kk));
                bResult=0;
            end
            
            if (bResult ~= 1)

                if ((isempty(sowhat))|| (sowhat(1)~='A'))
                    sowhat=upper(input('Skip frame or manual procedure? []=manual / A= skip all ','s'));
                    
                    if (isempty(sowhat))
                        fprintf(1, 'Falling back to manual.\n');
                        active_images(kk)=1;
                        click_ima_calib_no_read;
                    else
                        disp(sprintf('Automatic detection failed.\nDeactivating image %d',kk));
                        active_images(kk) = 0;
                        last_position=[];
                    end
                else
                    active_images(kk)=0;
                end
            else
                active_images(kk) = 1;
            end
        else
            active_images(kk)=1;
            click_ima_calib_no_read;
        end
        % >> end Modified by DMoroz (Vezhnevets Vladimir)

    else
        eval(['dX_' num2str(kk) ' = NaN;']);
        eval(['dY_' num2str(kk) ' = NaN;']);

        eval(['wintx_' num2str(kk) ' = NaN;']);
        eval(['winty_' num2str(kk) ' = NaN;']);

        eval(['x_' num2str(kk) ' = NaN*ones(2,1);']);
        eval(['X_' num2str(kk) ' = NaN*ones(3,1);']);

        eval(['n_sq_x_' num2str(kk) ' = NaN;']);
        eval(['n_sq_y_' num2str(kk) ' = NaN;']);
    end;
end;


check_active_images;


% Fix potential non-existing variables:

for kk = 1:n_ima,
    if ~exist(['x_' num2str(kk)],'var'),
        eval(['dX_' num2str(kk) ' = NaN;']);
        eval(['dY_' num2str(kk) ' = NaN;']);

        eval(['x_' num2str(kk) ' = NaN*ones(2,1);']);
        eval(['X_' num2str(kk) ' = NaN*ones(3,1);']);

        eval(['n_sq_x_' num2str(kk) ' = NaN;']);
        eval(['n_sq_y_' num2str(kk) ' = NaN;']);
    end;

    if ~exist(['wintx_' num2str(kk)],'var') || ~exist(['winty_' num2str(kk)],'var'),

        eval(['wintx_' num2str(kk) ' = NaN;']);
        eval(['winty_' num2str(kk) ' = NaN;']);

    end;
end;


string_save = 'save calib_data active_images ind_active wintx winty n_ima type_numbering N_slots first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default dX dY';

for kk = 1:n_ima,
    string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
end;

eval(string_save);

disp('done');

