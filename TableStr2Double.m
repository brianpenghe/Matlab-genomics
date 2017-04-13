function NewTable = TableStr2Double(OldTable,Col)
%This script converts a column of a table to Double-type
%Please make sure this column only contains stringified doubles but not other strings
% Example:
% ID  P-value
% A4  '3.4e-08'
% B3  '5.2e-07'
%

temp=array2table(str2double(table2array(OldTable(:,Col))));
NewTable(:,1:Col-1)=OldTable(:,1:Col-1);
NewTable(:,Col)=temp;
NewTable(:,Col+1:end)=OldTable(:,Col+1:end);
NewTable.Properties.VariableNames=OldTable.Properties.VariableNames;
end
