function MatrixHighRanker = MatrixHighRanker(name,value,head,cutoff,outfile)
%MatrixTopRanker is a function to write the high(above cutoff) items into a text file named "outfile"
%Useful for saving significant genes with their p-values
%MatrixHighRanker(name,value,head,cutoff,outfile)


[E,I]=sort(value,'descend');
[m n]=size(value);
T=table(num2cell([1:m]'));
for i=1:n
    temp=name(I(:,i));
    temp((E(:,i)<=cutoff))={''}; 
T=[T table(temp,E(:,i),'VariableNames',[head(i), strcat(head(i),'Score') ])];
end
writetable(T,outfile)
end