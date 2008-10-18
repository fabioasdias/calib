

imagem=le_video(escolhe_graf('avi'),1);
tam=size(imagem);
k2=0;
%1000 eh mais perto do mundo real - camerasvai
%[K(1,1);K(1,2);K(1,3);K(2,2);K(2,3);K(3,3);mr;teta;phi;T;inicializa_k(Kct)
%];

for k1=0:-0.1:-0.5
    tic
    vetor=[1000;   0; tam(2)/2;...
        1000; tam(1)/2;...
        1;...
        0;0;0;...
        0;0;0;...
        k1;k2];
    [calib.KK calib.RT calib.dir.k]=converte_vet_calib(vetor);
    calib.KKi=pinv(calib.KK);
    calib.P=calib.KK*calib.RT;

    imwrite(undistort_imagem(imagem,calib),sprintf('k1.%g.png',abs(k1)));
    disp(sprintf('Done k1=%g',k1));
    toc
end
