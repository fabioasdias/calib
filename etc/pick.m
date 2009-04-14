function filename=pick(extension)
%function filename=pick(extension)
% Graphical interface to pick files in the current directory with
% the given extension:
% pick('avi') -> list all avi files
% pick without arguments means all files
% 

try 
    extension;  %#ok<VUNUS>
catch
    extension='*';
end


d=dir(['*.' extension]);
if (~isempty(d))
    %if there are more than just one
    if (size(d,1)>1)
        str = {d.name};
        [s,v] = listdlg('PromptString','Select a file:',...
            'SelectionMode','single',...
            'ListString',str);
        %if just one, go for it
    else
        
        s=1;
        v=1;
    end
    if (v==1)
        filename=d(s).name;
    end
else
    %if none, empty return
    filename=[];
    warning('No file with extension %s was found!',extension); %#ok<WNTAG>
end
