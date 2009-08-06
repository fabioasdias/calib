% Dead Moroz version of click_ima_calib
% Actually a wrap-function for the generic detection function click_dm_calib

fprintf(1,'\nProcessing image %d...\n',kk);
eval(['I = I_' num2str(kk) ';']);

click_dm_calib;