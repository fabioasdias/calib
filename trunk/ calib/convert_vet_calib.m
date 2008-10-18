function [KK RT k]=converte_vet_calib(vetor)
%function [KK RT k p s]=converte_vet_calib(vetor)

%% compoe a K
%[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;inicializa_k(Kct)];

k=vetor(11:12);

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
%r=vetor(5)*[cos(vetor(6))*sin(vetor(7));sin(vetor(6))*sin(vetor(7));cos(vetor(7))];
[r(1) r(2) r(3)]=sph2cart(vetor(8),vetor(9),vetor(7));
R=rodrigues(r);

%% agora RT
RT=R;
RT(:,4)=T;
