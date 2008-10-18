function vetor=stack_matrix(matrix)
%function vetor=stack_matrix(matrix)
%horizontal, vertical
contador=1; %preguica
vetor=zeros(size(matrix,1)*(size(matrix,2)),1);
for i=1:size(matrix,1)
    for j=1:size(matrix,2)
        vetor(contador)=matrix(i,j);
        contador=contador+1;
    end
end
