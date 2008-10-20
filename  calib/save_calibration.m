function save_calibration(calib,name,clb)
%function save_calibration(calib,name,clb)
%calib -> calibration structure
%name  -> desired filename without extension
%clb   -> 1/0 -> clb/cal -> with/without distortion coefficients

if isempty(name)
    name=input('Please, enter the desired filename (without extension)','s');
end

if (clb==0)
    %% P para dvideo
    dvideo=fopen([name '.cal'],'w');
    Pn=stack_matrix(calib.P);
    Pd=Pn/Pn(12);
    for i=1:12
        fprintf(dvideo,'%6.6f ',Pd(i));
    end
    fclose(dvideo);
    return;
end

%% meu clb
% K
% RT
% k p s
f=fopen([name '.clb'],'w');

%% KK
fprintf(f,'%e ',calib.KK');
fprintf(f,'\n');

%% RT
fprintf(f,'%e ',calib.RT');
fprintf(f,'\n');
%direct model
fprintf(f,'%e %e\n',calib.dir.k(1),calib.dir.k(2));

%inverse model
try
    fprintf(f,'%e %e\n',calib.inv.k(1),calib.inv.k(2));
catch
    %just in case
end

fclose(f);