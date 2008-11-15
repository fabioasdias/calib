function [KK RT k]=convert_vet_calib(vetor)
%function [KK RT k p s]=convert_vet_calib(vetor)
% vetor=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;inicializa_k(Kct)];


%% compoe a K
KK=[vetor(1) vetor(2) vetor(3); 0 vetor(4) vetor(5);0 0 vetor(6)];
%% compoe os coeficientes de distorcao
if (size(vetor,1)==14)
    k=vetor(13:14);
else
    k=[0;0];
end

%% vetor T
T=vetor(10:12)';
%% ajeitar o R 
%trocando de esféricas para euclidianas

R=rodrigues(vetor(7:9));

%% agora RT
RT=R;
RT(:,4)=T;
