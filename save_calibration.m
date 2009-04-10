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
    fprintf(dvideo,'%6.6g ',Pd(1));
    fprintf(dvideo,'%6.6g ',Pd(5));
    fprintf(dvideo,'%6.6g ',Pd(9));
    fprintf(dvideo,'%6.6g ',Pd(2));
    fprintf(dvideo,'%6.6g ',Pd(6));    
    fprintf(dvideo,'%6.6g ',Pd(10));
    fprintf(dvideo,'%6.6g ',Pd(3));
    fprintf(dvideo,'%6.6g ',Pd(7));
    fprintf(dvideo,'%6.6g ',Pd(11));
    fprintf(dvideo,'%6.6g ',Pd(4));
    fprintf(dvideo,'%6.6g ',Pd(8));

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
fprintf(f,'%e %e\n',calib.dir.p(1),calib.dir.p(2));
fprintf(f,'%e %e\n',calib.dir.s(1),calib.dir.s(2));

fprintf(f,'%e %e\n',calib.inv.k(1),calib.inv.k(2));
fprintf(f,'%e %e\n',calib.inv.p(1),calib.inv.p(2));
fprintf(f,'%e %e\n',calib.inv.s(1),calib.inv.s(2));

fclose(f);