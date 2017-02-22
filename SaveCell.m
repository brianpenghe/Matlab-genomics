function SaveCell = SaveCell(cell,filename)
%SaveCell is a function to write a nX1 cell array into a file named filename
%Useful for saving lists of genes, for example
%SaveCell(cell_array,filename)
fileID = fopen(filename,'w');
formatSpec='%s\n';
[sizem, sizen]=size(cell);
for row=1:sizem
    fprintf(fileID,formatSpec,cell{row,1});
end
fclose(fileID);
end