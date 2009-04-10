function [KK RT k p s]=convert_vet_calib(vetor)
%function [KK RT k p s]=convert_vet_calib(vetor)
% vetor=[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);r;T;k1,k2,p1,p2,s1,s2];


%% compoe a K
KK=[vetor(1) vetor(2) vetor(3); 0 vetor(4) vetor(5);0 0 vetor(6)];
%% compoe os coeficientes de distorcao
k=[0;0];
p=[0;0];
s=[0;0];
if (size(vetor,1)>=14)
    k=vetor(13:14);
    if (size(vetor,1)>=16)
        p=vetor(15:16);
        if (size(vetor,1)>=18)
            s=vetor(17:18);
        end
    end
end

%% vetor T
T=vetor(10:12)';
%% ajeitar o R 
%trocando de esféricas para euclidianas
R=rodrigues(vetor(7:9));

%% agora RT
RT=R;
RT(:,4)=T;
