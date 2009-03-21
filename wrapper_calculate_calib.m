function [KK kc mat]=wrapper_calculate_calib(F,L,imagem)
%function [KK kc mat]=wrapper_calculate_calib(F,L,imagem)
%KK -> intrinsic parameters
%using  J. Bouguet's toolbox
%http://www.vision.caltech.edu/bouguetj/calib_doc/ or
%http://research.graphicon.ru/calibration/gml-matlab-camera-calibration-too
%lbox.html
KK=[];
kc=[];
mat=[];
if ((size(F,2)/3)~=(size(L,2)/2))
    error('Incompatible vector size. Wrong number of sample images.');
end

%the toolbox expects  them this way
F=F';
L=L';
kc=0; %just to stop the warning

est_alpha=1;
est_dist=[1;1;0;0;0];

n_ima=size(F,1)/3;
ind_active=1:n_ima;
for i=1:n_ima
    eval(['X_' num2str(i) '=F((3*(i-1)+1):(3*i),:);']);
    eval(['x_' num2str(i) '=L((2*(i-1)+1):(2*i),:);']);
end

global imagem; %#ok<REDEF>
if (~isempty(imagem)) %#ok<NODEF>
    nx=size(imagem,2); %#ok<NODEF>
    ny=size(imagem,1); %#ok<NODEF>
end

go_calib_optim_iter;
if (~exist('KK','var'))
    KK=[];
else
    if (~isempty(KK))
        mat.fc=fc;
        mat.cc=cc;
        mat.kc=kc;
        mat.alpha_c=alpha_c;
    end
end
