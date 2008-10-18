function L=le_dat_dvideo(nome_arq)
%Esta função converte do formato do dvideo para o formato usado na funcao
%calibra. Ainda contém -1 na saída.
%Entrada: Nome do arquivo .dat
%Saida: Vetor Nx2 com os pontos da imagem 

%ler o arquivo .dat
buf=textread(nome_arq);

%vamos excluir o primeiro número (nao sei para que serve!)
buf=buf(2:end);
tam=size(buf,2);


%Alocar memória para a saída
L=zeros(tam/2,2);
il=1;
for i=1:2:tam
    L(il,:)=[buf(i) buf(i+1)];
    il=il+1;
end
     
    