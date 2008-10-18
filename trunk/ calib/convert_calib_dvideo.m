function [F L]=converte_calib_dvideo(Fd,Ld)
%function [F L]=converte_calib_dvideo(Fd,Ld)
%remove os -1 nos Ld e seu correspondente no Fd
%Tambem remove o indice no .ref (Fd)
validos=sum(Ld(:,1)>-1);
Fd=Fd(:,2:end);
F=zeros(validos,3);
L=zeros(validos,2);
contador=1;
for i=1:size(Fd,1)
    if (any(Ld(i,:)~=-1))
        F(contador,:)=Fd(i,:);
        L(contador,:)=Ld(i,:);
        contador=contador+1;
    end
end