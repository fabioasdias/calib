d = dir('*.mat');
if (size(d,1)>0)
    str = {d.name};
    [s,v] = listdlg('PromptString','Select a file:',...
        'SelectionMode','single',...
        'ListString',str);
    if (v==1)
        if ~exist(d(s).name,'file'),
            fprintf(1,['\nCalibration file ' d(s).name ' not found!\n']);
            return;
        end
    end;

    fprintf(1,['\nLoading calibration results from ' d(s).name '\n']);

    eval(['load ' d(s).name]);

    fprintf(1,'done\n');
end
