function MatrixTopRanker = MatrixTopRanker(name,value,head,quota,outfile)
%MatrixTopRanker is a function to write the Top(quota) items ranked by
%their scores stored in value into a text file named "outfile"
%Useful for saving top enriched genes with their scores
%MatrixTopRanker(name,value,head,quota,outfile)

T=table(num2cell([1:quota]'));
[E,I]=sort(value,'descend');
[m n]=size(value);
for i=1:n
temp=name(I(:,i),:);
T=[T table(temp(1:quota,:),E(1:quota,i),'VariableNames',[head(i), strcat(head(i),'Score') ])];
end
writetable(T,outfile)
end
