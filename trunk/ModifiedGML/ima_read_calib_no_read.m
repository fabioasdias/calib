
if ~exist('calib_name','var')||~exist('format_image','var'),
    data_calib_no_read;
    return;
end;

check_directory;

if ~exist('n_ima','var'),
    data_calib_no_read;
    return;
end;

check_active_images;


images_read = active_images;


if exist('image_numbers','var'),
    first_num = image_numbers(1);
end;


% Just to fix a minor bug:
if ~exist('first_num','var'),
    first_num = image_numbers(1);
end;


image_numbers = first_num:n_ima-1+first_num;


no_image_file = 0;

%% Step used to clean the memory if a previous atttempt has been made to read the entire set of images into memory:
for kk = 1:n_ima,
    if (exist(['I_' num2str(kk)],'var')==1),
        clear(['I_' num2str(kk)]);
    end;
end;


fprintf(1,'\nChecking directory content for the calibration images (no global image loading in memory efficient mode)\n');

one_image_read = 0;

i = 1;
if ((strcmpi(format_image,'avi')==0)&&(strcmpi(format_image,'mov')==0))
    while (i <= n_ima), % & (~no_image_file),
        if active_images(i),

            %fprintf(1,'Loading image %d...\n',i);

            if ~type_numbering,
                number_ext =  num2str(image_numbers(i));
            else
                number_ext = sprintf(['%.' num2str(N_slots) 'd'],image_numbers(i));
            end;

            ima_name = [calib_name  number_ext '.' format_image];

            if i == ind_active(1),
                fprintf(1,'Found images: ');
            end;

            if exist(ima_name,'file'),

                fprintf(1,'%d...',i);
                I=imread(ima_name);


                if ~one_image_read

                    if size(I,3)>1,
                        I = 0.299 * I(:,:,1) + 0.5870 * I(:,:,2) + 0.114 * I(:,:,3);
                    end;


                    if size(I,1)<480,
                        small_calib_image = 1;
                    else
                        small_calib_image = 0;
                    end;

                    [Hcal,Wcal] = size(I); 	% size of the calibration image

                    [ny,nx] = size(I);

                    one_image_read = 1;

                end;


            else

                images_read(i) = 0;

            end;

        end;

        i = i+1;

    end;
    ind_read = find(images_read);
else
    ind_read = find(active_images);
    
end





if ~(exist('map','var')==1), map = gray(256); end;

active_images = images_read;

fprintf(1,'\ndone\n');
