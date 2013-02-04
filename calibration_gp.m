function [fval x_best]=calibration_gp(F,L,model)
%function calib=calibration(F,L,model)
% F: X Y Z -> real world
% L: u v   -> image plane
% model: distortion model ( char - eval "like")


%multiplier/divisor to reduce the effect of the variation of the
%distortions in the optimizations
MULT=10;

a=1;
for i=1:size(F,1)
    if (L(i,1)>0)
        Fl(a,:)=F(i,:);
        Ll(a,:)=L(i,:);
        a=a+1;
    end
end

F=Fl;
L=Ll;

[K R T]=calibration_dlt(F,L);

%% makes the model 'eval'luable

vars=regexp(model,'x[0-9]+','match');
nConst=size(vars,2);
for i=1:nConst
    model=strrep(model,vars{i},sprintf('x(%d)',12+i));
end


%% Gibbs vector for rotation
r=rodrigues(R);
x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;zeros(nConst,1)];
[x  fval] = fminsearch(@fcn_dir,x0,optimset('Display','off','MaxIter',1000,'MaxFunEvals',1000,'TolX',1e-8));
x(13:end)=x(13:end)/MULT;
x_best=aux_proj(x);

% aux(13:end)=aux(13:end)/MULT;
% % rebuilding the matrix of the result
 % [calib.KK calib.RT]=convert_vet_calib(aux(1:12));
 % calib.R=calib.RT(1:3,1:3);
 % calib.T=calib.RT(:,4);
 % calib.Ri=pinv(calib.R);
 % calib.P=calib.KK*calib.RT;
 % calib.KKi=pinv(calib.KK);
 %
 % disp('P matrix');
 % disp(calib.P);
    function xl=aux_proj(x)
        x(13:end)=x(13:end)/MULT;
        %X=projection(x,F,0);
        [KK RT]=convert_vet_calib(x);
        X=RT*[F ones(size(F,1),1)]';
        X=X(1:2,:)./repmat(X(3,:),[2 1]);
        xl=eval(model);
        if ((size(xl,2)~=size(X,2))||(size(xl,1)~=2))
            xl=NaN;
        else
            xl=KK*[xl;ones(1,size(xl,2))];
            xl=xl(1:2,:)./repmat(xl(3,:),[2 1]);
        end
    end
    function sum_error=fcn_dir(x)
        xl=aux_proj(x);
        if any(isnan(xl))
            sum_error=Inf;
        else
            if (all(all(xl==0)))
                sum_error=Inf;
            else
                sum_error=sum(sum( (xl-(L(:,1:2)')).^2));
            end
        end
    end

end



    



    

