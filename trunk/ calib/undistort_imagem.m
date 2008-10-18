function saida=undistort_imagem(original,calib)
%function saida=undistort_imagem(original,nome_clb)
%original: imagem original
%saida: imagem corrigida
%calib: dados de calibracao ou nome do arquivo .clb

tic
if (~isstruct(calib))
    calib=carrega_camera(calib,0);
end
%para facilitar a escrita
k=calib.dir.k;
%s=calib.dir.s;
%p=calib.dir.p;

tam=size(original);
original=double(original);
%vamos criar uma imagem maior, pois fica complicado calcular o quao maior
%ela deve ser para compensar a distorcao
map=nan(2*tam(1),2*tam(2),2);

for i=1:size(map,1)
    for j=1:size(map,2)

        %[i,j] representam o ponto na imagem de resultado
        %Façamos o centro da "undistorção" no centro da imagem, para
        %garantir.
        xu=calib.KKi*[j-tam(2)/2+1;i-tam(1)/2+1;1];
        %normaliza a coordenada homogenea
        xu=xu/xu(3);

        %coloquei em u e v para facilitar nas equações
        u=xu(1);
        v=xu(2);

        %supondo o centro de distorção como o centro de projeção.
        %Não é totalmente seguro, mas resolve bastante
        u2v2=u^2+v^2;

        %distorções, indo do ponto não distorcido para o distorcido
        du=k(1)*u*u2v2+k(2)*u*(u2v2)^2;%+s(1)*u2v2+(p(1)*(3*u^2+v^2)+2*p(2)*u*v);
        dv=k(1)*v*u2v2+k(2)*v*(u2v2)^2;%+s(2)*u2v2+(p(2)*(3*v^2+u^2)+2*p(1)*u*v);

        %aplica a KK para descobrir o pixel correspondente na imagem
        %distorcida
        xd=calib.KK*[u+du;v+dv;1];
        xd=round(xd/xd(3));

        %caso esteja nos limites da imagem original (distorcida)
        if ((xd(1)>0)&&(xd(2)>0)&&(xd(1)<=tam(2))&&(xd(2)<=tam(1)))
            map(i,j,:)=[xd(2);xd(1)];
        end
                    
    end
end

%%

%calcular a "bounding box" contendo somente a imagem endireitada
i=1;
j=1;
max_i=-1;
min_i=-1;

while (i<=size(map,1))&&((max_i==-1)||(min_i==-1))
    while (j<=size(map,2))&&((max_i==-1)||(min_i==-1))

        if  (min_i==-1)&&(not (isnan(map(i,j,1))))
            min_i=i;
        end
        if (max_i==-1)&&(not (isnan(map(size(map,1)+1-i,j,1))))
            max_i=size(map,1)+1-i;
        end
        j=j+1;
    end
    i=i+1;
    j=1;
end

i=1;
j=1;
max_j=-1;
min_j=-1;

while (j<=size(map,2))&&((max_j==-1)||(min_j==-1))
    while (i<=size(map,1))&&((max_j==-1)||(min_j==-1))

        if  (min_j==-1)&&(not (isnan(map(i,j,1))))
            min_j=j;
        end
        if (max_j==-1)&&(not (isnan(map(i,size(map,2)+1-j,1))))
            max_j=size(map,2)+1-j;
        end
        i=i+1;
    end
    j=j+1;
    i=1;
end

if ((min_i==-1)||(min_j==-1)||(max_j==-1)||(max_i==-1))
    error('Isto não deveria acontecer!');
end
%retorna só o retangulo com a imagem
map=map(min_i:max_i,min_j:max_j,:);
toc

%%
%daqui pra cima é quase a undistort padrao. daqui pra baixo, usamos o
%mapeamento computado pra fazer undistort no video inteiro de um jeito mais
%rapido


imaux=zeros(size(map,1),size(map,2),3);
tic
for i=1:size(map,1)
    for j=1:size(map,2)
        if (~isnan(map(i,j,1)))
            imaux(i,j,:)=original(map(i,j,1),map(i,j,2),:);
        end
    end
end
saida=uint8(imaux);
toc
end
