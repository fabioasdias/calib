function nome=escolhe_graf(extensao)
%funcao que cria uma mini-interface para escolha de um arquivo .ref para
%ser utilizado nas funções
%retorna o nome do arquivo escolhido
%Usada em várias outras funções

try 
    extensao; 
catch
    extensao='*';
end

d=dir(['*.' extensao]);
if (~isempty(d))
    if (size(d,1)>1)
        str = {d.name};
        [s,v] = listdlg('PromptString','Select a file:',...
            'SelectionMode','single',...
            'ListString',str);
    else
        s=1;
        v=1;
    end
    if (v==1)
        nome=d(s).name;
    end
else
    nome='';
end
