function [name,value,head] = ImportBody(filename,Delimiter)
%ImportBody is a function to import a table from a csv file with header and measurement names
%The input file should be a complete .csv or other file
%If no Delimiter specified, we assume it is a csv.
%function [name,value,head] = ImportBody(filename,Delimiter)
%Delimiter can be c(comma) or t(tab)

%File example:
%Name     ID    HP
%Henry    506    238
%Diane    1322   124
%Sean     823    76


if nargin == 1
Delimiter = 'c';
end;

if Delimiter=='t'
Table=readtable(filename,'Delimiter','\t');
else if Delimiter=='c'
Table=readtable(filename,'Delimiter',',');
end;

DataColumns=varfun(@isnumeric,Table(1,:),'output','uniform');
head=Table.Properties.VariableNames(DataColumns);
name=table2cell(Table(2:end,1));
value=table2array(Table(2:end,DataColumns));

end;