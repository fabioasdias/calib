function und_dat_dltnl(datFile,LFile)
L=textread(LFile);

u0=(L(1)*L(9)+L(2)*L(10)+L(3)*L(11))/(L(9)^2+L(10)^2+L(11)^2);
v0=(L(5)*L(9)+L(6)*L(10)+L(7)*L(11))/(L(9)^2+L(10)^2+L(11)^2);


dat=textread(datFile);


f=fopen(['corr_' datFile],'w');

for line=1:size(dat,1)
    E=dat(line,2:2:end)-u0;
    N=dat(line,3:2:end)-v0;
    r2=E.^2+N.^2;
    
    u=dat(line,2:2:end)- E.*(L(12).*r2+L(13).*(r2.^2)+L(14).*(r2.^3)) + L(15).*(r2+2*(E.^2)) + L(16).*E.*N;
    v=dat(line,3:2:end)- N.*(L(12).*r2+L(13).*(r2.^2)+L(14).*(r2.^3)) + L(15).*E.*N          + L(16).*(r2+2*(N.^2));
    
    fprintf(f,'%d ',line-1);
    
    for i=1:size(u,2)
        fprintf(f,' %f %f',u(i),v(i));
    end
    
    fprintf(f,'\n');
end
fclose(f);
end