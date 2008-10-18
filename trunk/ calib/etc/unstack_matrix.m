function matrix=unstack_matrix(vetor,tamx,tamy)
%function matrix=unstack_matrix(vetor,tamx,tamy)
%horizontal, vertical
contador=1; %preguica
for i=1:tamx
    for j=1:tamy
        matrix(i,j)=vetor(contador);
        contador=contador+1;
    end
end