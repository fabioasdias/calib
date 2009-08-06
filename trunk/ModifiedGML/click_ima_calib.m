% Actually a wrap-function for the generic detection function
% click_ima_calib_int

fprintf(1,'\nProcessing image %d...\n',kk);

% load image from memory
eval(['I = I_' num2str(kk) ';']);

% go to object detection
click_ima_calib_int;