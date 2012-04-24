function [K R T]=calibration_dlt(F,L)
% [K R T]=calibra_dlt(F,L)
% Linear calibration using only DLT.
% F: X Y Z
% L: x y
% returns K, R, T
% K: instrinsic
% R: Rotation matrix
% T: Translation vector


tam=size(F,1);

A=zeros(2*tam,11);
B=zeros(2*tam,1);
for ii=1:tam
    A(2*ii-1,:)=[F(ii,:) 1 0 0 0 0 -L(ii,1)*F(ii,:)];
    B(2*ii-1)=L(ii,1);
    A(2*ii  ,:)=[0 0 0 0 F(ii,:) 1 -L(ii,2)*F(ii,:)];
    B(2*ii)=L(ii,2);
end

% 12 elements
X=[A\B;1];

P=unstack_matrix(X,3,4);
[K,R,T,C] = P2KRtC(P);
end