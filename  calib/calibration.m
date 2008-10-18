function calib=calibra(F,L)
%P k p s=calibra(F,L) ATUALIZAR
% entrada nao homogenea :
% F: X Y Z
% L: x y
% retorna p: 3x4
% k 2x1 = distorcao radial
% p 2x1 = (uma eh a decentering, a outra prisma fino)
% s 2x1 = (qual eh qual, olhe no Wang2008)
% minimo 6 pontos!

global radial;
if isempty(radial)
    radial=0;
end

%% sempre util ter o numero de pontos
tam=size(F,1);

%% toolbox
[K Kct]=wrapper_calcula_calib(F,L);
Ll=L;
if (~isempty(K))
    %caso a wrapper tenha funcionado como estimativa inicial
    Ki=pinv(K);

    Ll(:,3)=1;
    for i=1:tam
        Ll(i,:)=(Ki*Ll(i,:)')';
    end
    % x = K[R|T]X
    % K^{-1} x = [R | T]X
    Ll=Ll(:,1:2)./repmat(Ll(:,3),[1 2]);


    %% KLT
    A=zeros(2*tam,11);
    B=zeros(2*tam,1);
    disp('Computando KLT');
    %sem distorção
    for ii=1:tam
        A(2*ii-1,:)=[F(ii,:) 1 0 0 0 0 -Ll(ii,1)*F(ii,:)];
        B(2*ii-1)=Ll(ii,1);
        A(2*ii  ,:)=[0 0 0 0 F(ii,:) 1 -Ll(ii,2)*F(ii,:)];
        B(2*ii)=Ll(ii,2);
    end
    %completa para ter 12 elementos
    RT=[A\B;1];
    % realiza a normalização, ja que estes valores são parte de uma matriz de
    %rotacao e o modulo deles deve ser 1;
    RT=RT*1/sqrt(sum(RT(9:11).^2));
    RT=unstack_matrix(RT,3,4);
    R=RT(1:3,1:3);
    T=RT(:,4);

else
    % se nao funcionou, vamos de dlt mesmo.    
    disp('Usando DLT para estimativa');
    [K R T]=calibra_dlt(F,L);
end
    

%% Daqui pra baixo eu tenho K,R e T
% preciso encontrar as distorcoes
% e otimizar os parametros


%% parametrizando a rotacao
%vetor de rotação
r=rodrigues(R);
[teta phi mr]=cart2sph(r(1),r(2),r(3));

%% preparar e otimizar MODELO DIRETO
%[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;k1;k2];
if (radial==1)
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;inicializa_k(Kct)];
else
    x0=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T];%;inicializa_k(Kct)];
end
    

[aux fval exitflag output] = fminsearch(@fcn_dir,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-8,'LevenbergMarquardt','on')) 



%% recompor as matrizes para o resultado
if (radial==0)
    aux=[aux' 0 0]';
end
[calib.KK calib.RT calib.dir.k]=converte_vet_calib(aux);
calib.KKi=pinv(calib.KK);
calib.R=calib.RT(1:3,1:3);
calib.T=calib.RT(:,4);
calib.Ri=pinv(calib.R);
calib.P=calib.KK*calib.RT;


%% MODELO INVERSO
%x0=inicializa_k(-Kct);
if (radial==1)
    [aux fval exitflag output] = fminsearch(@fcn_inv,x0,optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-8,'LevenbergMarquardt','on'))

    %% ajeita a resposta
    calib.inv.k=aux(1:2);
end
    function erro=fcn_dir(x)
        erro=sum(sum( (calcula_projecao(x,F)-L').^2));
    end
    function erro=fcn_inv(x)
        Fl=F';
        Fl(4,:)=1;
        xup=calib.P*(Fl);
        xup=xup(1:2,:)./repmat(xup(3,:),[2 1]);
        calib.inv.k=x(1:2);
        erro=sum(sum((corrige_ponto(calib,L)-xup).^2));
    end
    function vetor= inicializa_k(kct)
        k1=input(['Estimativa inicial para K1: ([]=' num2str(kct(1)) ') ']);
        if (isempty(k1))
            k=[0;0];
        else
            k=[k1;0];
        end
        vetor=k;
    end
end