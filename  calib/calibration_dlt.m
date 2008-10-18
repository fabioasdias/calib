function [K R T]=calibra_dlt(F,L)
% [K R T]=calibra_dlt(F,L)
% Calibração linear usando somente DLT.
% entrada nao homogenea :
% F: X Y Z
% L: x y
% retorna K, R, T
% K: parametros intrinsecos
% R: matriz de rotação
% T: Vetor de translação
% minimo 6 pontos!

tam=size(F,1);

A=zeros(2*tam,11);
B=zeros(2*tam,1);
disp('Computando DLT');
%primeira DLT, sem distorção
for ii=1:tam
    A(2*ii-1,:)=[F(ii,:) 1 0 0 0 0 -L(ii,1)*F(ii,:)];
    B(2*ii-1)=L(ii,1);
    A(2*ii  ,:)=[0 0 0 0 F(ii,:) 1 -L(ii,2)*F(ii,:)];
    B(2*ii)=L(ii,2);
end

%completa para ter 12 elementos
X=[A\B;1];
%realiza a normalização, ja que estes valores são parte de uma matriz de
%rotacao e o modulo deles deve ser 1;
%X=X*1/sqrt(sum(X(9:11).^2));

P=unstack_matrix(X,3,4);
[K,R,T,C] = P2KRtC(P);

%Ki=pinv(K);
%[K R]=rq(P(1:3,1:3));

%T=Ki*P(:,4);
end