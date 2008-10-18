function [KK kc]=wrapper_calcula_calib(F,L,imagem)
%function KK=wrapper_calcula_calib(F,L)
%KK é a aproximação da matrix de parametros intrinsecos,
%usando a toolbox de J. Bouguet
%http://www.vision.caltech.edu/bouguetj/calib_doc/ ou 
%http://research.graphicon.ru/calibration/gml-matlab-camera-calibration-toolbox.html
%
%F São as coordenadas do mundo real (em qualquer sistema de coordenadas). 
% Se possuir mais de 3 colunas, considera-se como multi-imagem 
%(para calibracao com pattern 2D)
%
%L são as coordenadas dos pixels correspondentes
% Se possuir mais de 2 colunas, considera-se como multi-imagem 
%(para calibracao com pattern 2D)
if ((size(F,2)/3)~=(size(L,2)/2))
    error('Incompatible vector size. Wrong number of sample images.');
end

%a toolbox espera os dados "deitados"
F=F';
L=L';

n_ima=size(F,1)/3;
ind_active=1:n_ima;
for i=1:n_ima
    eval(['X_' num2str(i) '=F((3*(i-1)+1):(3*i),:);']);
    eval(['x_' num2str(i) '=L((2*(i-1)+1):(2*i),:);']);
end

global imagem;
if (~isempty(imagem))
    nx=size(imagem,2);
    ny=size(imagem,1);
end

go_calib_optim_iter;
if (~exist('KK','var'))
    KK=[];
end
if (~exist('Kct','var'))
    Kct=[0;0];
end