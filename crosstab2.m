function Table = crosstab2(A,B)
%Table = crosstab2(A,B)
%crosstab2 is a modified version of crosstab but with better output format
%A and B should follow the requirement of crosstab, i.e, with same dimensionality

[tbl,chi2,p,labels]=crosstab(A,B);
Table=array2table(tbl);
Table.Properties.RowNames=labels(~cellfun('isempty',labels(:,1)),1);
Table.Properties.VariableNames=ValidizeNames(strcat('Column',labels(~cellfun('isempty',labels(:,2)),2)));

end