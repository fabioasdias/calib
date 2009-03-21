function undistort_dat(original,new_dat,name_clb,compute_calibration)
% undistort_dat(original,new_dat,name_clb,compute_calibration)
%original: filename of the .dat original - string
%new_dat:      filename of the new_dat .dat - string
%name_clb: clb calibration file
%compute_calibration: 0/1 forces calibration calculation

option_show=input('Plot the corrected points? []=no ','s');
if (~isempty(option_show))
    show_points=1;
else
    show_points=0;
end

%reads the original file
if (exist(original,'file'))
    dat=textread(original);
else
    %or tries another one
    dat=textread(pick('dat'));
end

%opens the new_dat file
f=fopen(new_dat,'w');


%loads the camera calibration
calib=load_calibration(name_clb,compute_calibration,1);

%preparing points figure
if (show_points==1)
    figure
    hold on
end

%for each frame
for frame=1:size(dat,1)
    %keeping the original frame number
    corrected_points(frame,1)=dat(frame,1);
    %for each point
    for coluna=1:(size(dat,2)-1)/2
        if ((dat(frame,2*coluna)~=-1)&&(dat(frame,2*coluna+1)~=-1))
            %undistort
            corrected_points(frame,2*coluna:2*coluna+1)=undistort_point(calib,[dat(frame,2*coluna);dat(frame,2*coluna+1)]);
            %displays the data
            if (show_points==1)
                plot(dat(frame,2*coluna),dat(frame,2*coluna+1),'xred');
                plot(corrected_points(frame,2*coluna),corrected_points(frame,2*coluna+1),'oblue');
            end
        else
            corrected_points(frame,2*coluna:2*coluna+1)=-1;
        end
    end
    %saving the results in the new .dat file
    for c=1:size(dat,2)
        fprintf(f,' %6.6g',corrected_points(frame,c));
    end
    %to keep the defined format
    fprintf(f,'\n');
end
fclose(f);
