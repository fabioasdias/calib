function xc=corrige_ponto(calib,x)
%function x=corrige_ponto(calib,im)
%Função que corrige a distorção de um dado ponto (distorcido) im, de acordo
%com os dados da estrutura calib, retornada pelo carrega_camera
%Retorna x, sem arredondamentos
if (isstruct(calib))
    k=calib.inv.k;
    KK=calib.KK;
    KKi=calib.KKi;
else
    [KK RT k]=converte_calib(dados);
    KKi=pinv(KK);
end

if (min(size(x))>=2)
    if (size(x,1)>size(x,2))
        x=x';
    end
end
x(3,:)=1;

%coloca o ponto da imagem no plano da imagem
xd=KKi*x;


%distorções Xd=>Xu
u=xd(1,:);
v=xd(2,:);

%Assume como centro de distorção o centro de projeção (0,0) no
%plano da imagem
u2v2=u.^2+v.^2;
du=k(1).*u.*u2v2+k(2).*u.*(u2v2).^2;%+s(1).*u2v2+(p(1).*(3.*u.^2+v.^2)+2.*p(2).*u.*v);
dv=k(1).*v.*u2v2+k(2).*v.*(u2v2).^2;%+s(2).*u2v2+(p(2).*(3.*v.^2+u.^2)+2.*p(1).*u.*v);

xu=[u+du;v+dv;xd(3,:)];

xc=KK*xu;
xc=xc(1:2,:)./repmat(xc(3,:),[2 1]);
