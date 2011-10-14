function L=calibration_dltnl(REF,DAT)
% L=calibration_dltnl(F,L)
% non-Linear calibration using only DLT.
% F: X Y Z
% L: x y
% returns L with 16 values - kwon 3d dlt model

EPS=1E-12;

tam=size(REF,1);

X=zeros(2*tam,11);
Y=zeros(2*tam,1);
disp('Linear DLT!');
for ii=1:tam
    X(2*ii-1,:)=[REF(ii,:) 1 0 0 0 0 -DAT(ii,1)*REF(ii,:)];
    Y(2*ii-1)=DAT(ii,1);
    X(2*ii  ,:)=[0 0 0 0 REF(ii,:) 1 -DAT(ii,2)*REF(ii,:)];
    Y(2*ii)=DAT(ii,2);
end

L=[X\Y;1E-6;1E-10;1E-20;1E-3;1E-10];

disp('Non-linear DLT!');

u=DAT(:,1); v=DAT(:,2);
disp(L');

[L,fval,exitflag,output]=fminsearch(@errCal,L,optimset('MaxFunEvals',1E6,'MaxIter',1E6));
disp(L');
disp(fval);
disp(exitflag);
disp(output);
figure
plot(u,v,'xb');
[ul vl]=proj(L);
hold on, grid on,
plot(ul,vl,'or');
legend('cal','reproj');

    function [ul vl]=proj(L)
        u0=(L(1)*L(9)+L(2)*L(10)+L(3)*L(11))/(L(9)^2+L(10)^2+L(11)^2);
        v0=(L(5)*L(9)+L(6)*L(10)+L(7)*L(11))/(L(9)^2+L(10)^2+L(11)^2);
        
        E=u-u0;
        N=v-v0;
        r2=E.^2+N.^2;
        
        du= E.*( L(12).*r2 + L(13).*r2.^2 + L(14).*r2.^3) + L(15).*(r2+2*E.^2) + L(16).*E.*N;
        dv= N.*( L(12).*r2 + L(13).*r2.^2 + L(14).*r2.^3) + L(15).*N.*E        + L(16).*(r2+2.*N.^2);
        
        ul=(L(1).*REF(:,1) + L(2).*REF(:,2) + L(3).*REF(:,3)+ L(4) )./( L(9).*REF(:,1) + L(10).*REF(:,2) + L(11).*REF(:,3) +1 ) + du;
        vl=(L(5).*REF(:,1) + L(6).*REF(:,2) + L(7).*REF(:,3)+ L(8) )./( L(9).*REF(:,1) + L(10).*REF(:,2) + L(11).*REF(:,3) +1 ) + dv;
        
    end
    function erro=errCal(L)
        [ul vl]=proj(L);
        erro=sum(((u-ul).^2+(v-vl).^2));
    end

end