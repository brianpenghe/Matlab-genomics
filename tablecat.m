function BigTable = tablecat(A,B)
%tablecat concatenates two lists(columns) of string items stored in tableA and tableB. These two tables should have different variable names. They do not have to have the same sizes
%Useful for preparing scripts for MetaIntersect

BigTable=array2table(repmat({''},max(height(A),max(height(B))),width(A)+width(B)));
BigTable(1:height(A),1:width(A))=A;
BigTable(1:height(B),width(A)+1:end)=B;
BigTable.Properties.VariableNames=[A.Properties.VariableNames,B.Properties.VariableNames];
end