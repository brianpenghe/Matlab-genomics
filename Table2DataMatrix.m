function NewDataMatrix = Table2DataMatrix(OldTable)
%This script converts a table to DataMatrix
%The first column of the table should contain the ID/RowLabels
%VariableNames will be used as ColumnLabels
%Useful for clustergram / heatmap analysis

import bioma.data.DataMatrix;
NewDataMatrix=DataMatrix(double(table2array(OldTable(:,2:end))),table2array(OldTable(:,1)),OldTable(:,2:end).Properties.VariableNames);

end
