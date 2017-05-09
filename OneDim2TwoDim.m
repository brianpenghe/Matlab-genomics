function NewTable = OneDim2TwoDim(OldTable)
%OneDim2TwoDim is a function to reshape a table based on its first two columns
%Useful for matrix processing
%OldTable must contain three columns like below and must be table type and Column 3 must have a numeric type
%
% A  Alpha  3
% B  Gamma  4               
% A  Beta   2
% B  Alpha  1             
% A  Gamma  2
% A  Alpha  2
%
% The output will be like this
%
%    Alpha Beta Gamma
% A    5     2    2
% B    1     0    4
%
% The sum of the output is equal to the sum of the input

RowName=unique(table2array(OldTable(:,1)));
ColumnName=unique(table2array(OldTable(:,2)));
ValidizeNames(RowName);
ValidizeNames(ColumnName);
[m1 n1]=size(RowName);
[m2 n2]=size(ColumnName);
[m0 n0]=size(OldTable);

NewTable0=repmat([0],m1,m2);
for i=1:m0
    XCor=strmatch(OldTable{i,1},RowName);
    YCor=strmatch(OldTable{i,2},ColumnName);
    NewTable0(XCor,YCor)=NewTable0(XCor,YCor)+OldTable{i,3};
end;

NewTable=array2table(NewTable0);
NewTable.Properties.VariableNames=ValidizeNames(ColumnName);
NewTable.Properties.RowNames=ValidizeNames(RowName);

end