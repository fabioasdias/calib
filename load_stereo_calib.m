function [cRef c2]=load_stereo_calib(filename)
load(filename);
cRef.KK=KK_left;
cRef.KKi=pinv(cRef.KK);

c2.KK=KK_right;
c2.KKi=pinv(c2.KK);

cRef.R=eye(3,3);
cRef.Ri=pinv(cRef.R);
cRef.T=zeros(3,1);
cRef.RT=[cRef.R cRef.T];

c2.R=R;
c2.Ri=pinv(c2.R);
c2.T=T;
c2.RT=[R T];

cRef.P=cRef.KK*cRef.RT;
c2.P=c2.KK*c2.RT;

cRef.c=-cRef.Ri*cRef.KKi*cRef.P(:,4);
c2.c=-c2.Ri*c2.KKi*c2.P(:,4);