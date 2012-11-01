function L=read_dat_dvideo(nome_arq)
%function L=read_dat_dvideo(nome_arq)
%Esta função converte do formato do dvideo para o formato usado na funcao
%calibra. Ainda contém -1 na saída.
%Entrada: Nome do arquivo .dat
%Saida: Vetor Nx2 com os pontos da imagem 


%ler o arquivo .dat
buf=textread(nome_arq);

%vamos excluir o primeiro número - numero do quadro
buf=buf(:,2:end);
L=zeros(size(buf,1),2,size(buf,2)/2);
for i=1:size(buf,1)
    for j=1:size(buf,2)/2
        L(i,:,j)=buf(i,(j*2-1):(j*2));
    end
end


% tam=2*floor(size(buf,2)/2);
% buf(buf==-1)=nan;
% unico=nanmean(buf,1);
% unico(isnan(unico))=-1;

% il=1;
% for i=1:2:tam
%     L(il,:)=[unico(i) unico(i+1)];
%     il=il+1;
% end
%      
%     
