function SaveCell = SaveCell(cell,filename)
%SaveCell is a function to write a nX1 cell array into a file named filename
%Useful for saving lists of genes, for example
%SaveCell(cell_array,filename)
writetable(cell2table(cell),filename,'WriteVariableNames',false)
end
