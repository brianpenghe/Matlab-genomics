function SaveCell = SaveCell(cell,filename,dlm)
%SaveCell is a function to write a nX1 cell array into a file named filename
%Useful for saving lists of genes, for example
%SaveCell(cell_array,filename)
%SaveCell(cell_array,filename,'\t')
if nargin < 3
dlm=',';
end
writetable(cell2table(cell),filename,'WriteVariableNames',false,'Delimiter',dlm)
end
