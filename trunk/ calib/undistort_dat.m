function undistort_dat(origem,destino,nome_clb,computa_cal)
% undistort_dat(origem,destino,nome_clb,computa_cal)
%origem: nome do arquivo .dat original - string
%destino: nome do arquivo .dat de destino - string
%nome_clb: Nome do arquivo de calibracao correspondente
%computa_cal: Devo computar a calibração mesmo se o arquivo .cal existir? 1/0
%usa os arquivos camXim.txt camXref.txt ou camX.cal

%Caso queira plotar os pontos e comparar faça esta variavel =1;
mostra=0;


%le o arquivo de origem
if (exist(origem,'file'))
    dat=textread(origem);
else
    dat=escolhe_graf('dat');
end

%abre o arquivo de destino
f=fopen(destino,'w');


%realiza a calibração da camera
calib=carrega_camera(nome_clb,computa_cal)

%sequencia para exibicao de resultados
if (mostra==1)
    figure(1)
    hold on
end

%iterando nos frames
for frame=1:size(dat,1)
    %mantendo a numeracao original dos pontos
    pontos_corrigidos(frame,1)=dat(frame,1);
    %iterando nos pontos
    for coluna=1:(size(dat,2)-1)/2
        %efetuando a correção
        pontos_corrigidos(frame,2*coluna:2*coluna+1)=corrige_ponto(calib,[dat(frame,2*coluna);dat(frame,2*coluna+1)]);
        %novamente,somente para exibição, antes X depois da correção
        if (mostra==1)
            plot(dat(frame,2*coluna),dat(frame,2*coluna+1),'xred');
            plot(pontos_corrigidos(frame,2*coluna),pontos_corrigidos(frame,2*coluna+1),'oblue');
        end
    end
    %vamos salvar a linha processada
    for c=1:size(dat,2)
        fprintf(f,' %6.6d',pontos_corrigidos(frame,c));
    end
    %pulando linha no final
    fprintf(f,'\n');
end
%se nao fechar o arquivo nao funciona
fclose(f);
