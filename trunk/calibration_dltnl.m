function L=calibration_dltnl(REF,DAT)
% L=calibra_dlt(F,L)
% Linear calibration using only DLT.
% F: X Y Z
% L: x y
% returns K, R, T
% K: instrinsic
% R: Rotation matrix
% T: Translation vector
% kc: distortion vector


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

L=[X\Y;0;0;0;0;0];

W=eye(16);

disp('Non-linear DLT!');

u0=(L(1)*L(9)+L(2)*L(10)+L(3)*L(11))/(L(9)^2+L(10)^2+L(11)^2);
v0=(L(5)*L(9)+L(6)*L(10)+L(7)*L(11))/(L(9)^2+L(10)^2+L(11)^2);
R=zeros(tam,1);
E=zeros(tam,1);
N=zeros(tam,1);
r2=zeros(tam,1);
X=zeros(2*tam,16);
Y=zeros(16,1);

for ii=1:tam
  R(ii)=REF(ii,:)*L(9:11)+1;
  E(ii)=DAT(ii,1)-u0;
  N(ii)=DAT(ii,2)-v0;
  r2(ii)=E(ii).^2+N(ii).^2;
  
  X(2*ii-1,:)=[REF(ii,:) 1 0 0 0 0 -DAT(ii,1)*REF(ii,:) E(ii)*r2(ii)*R(ii) E(ii)*(r2(ii).^2)*R(ii) E(ii)*(r2(ii).^3)*R(ii) (r2(ii)+2*(E(ii).^2))*R(ii) E(ii)*N(ii)]/R(ii);
  Y(2*ii-1,:)=DAT(ii,1)/R(ii);

  X(2*ii  ,:)=[0 0 0 0 REF(ii,:) 1 -DAT(ii,2)*REF(ii,:) N(ii)*r2(ii)*R(ii) N(ii)*(r2(ii).^2)*R(ii) N(ii)*(r2(ii).^3)*R(ii) N(ii)*E(ii)*R(ii) (r2(ii)+2*N(ii).^2)*R(ii)]/R(ii);
  Y(2*ii  ,:)=DAT(ii,2)/R(ii);
end

L=X\Y;

disp(L);

end