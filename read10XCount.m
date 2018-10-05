function Matrix_dm=read10XCount(MtxFile,GeneFile,CellFile)
%read10XCount is a function to import 10X single-cell RNA-seq UMI counts as MatrixMarket formats and converts it into a DataMatrix format on Matlab 
%Matrix_dm = read10XCount(MtxFile,GeneFile,CellFile)
%the input arguments are paths or names of the input files
copyfile(MtxFile,strcat(MtxFile,'.txt'));
copyfile(GeneFile,strcat(GeneFile,'.txt'));
copyfile(CellFile,strcat(CellFile,'.txt'));
tempMatrixMarket=readtable(strcat(MtxFile,'.txt'));
Matrix_matrix=spconvert(table2array(tempMatrixMarket(2:end,:)));
Cells_table=readtable(strcat(CellFile,'.txt'),'ReadVariableNames',false,'Delimiter','\t');
Genes_table=readtable(strcat(GeneFile,'.txt'),'ReadVariableNames',false,'Delimiter','\t');
Genes_array=table2array(Genes_table);
Genes_table2=array2table(strcat(Genes_array(:,1),'_',Genes_array(:,2))); 
Matrix_table=[Genes_table2(1:height(array2table(Matrix_matrix)),:) array2table(Matrix_matrix)];
Matrix_table.Properties.VariableNames=[{'Var1'} ValidizeNames(table2array(Cells_table)')];
Matrix_dm=Table2DataMatrix(Matrix_table);
end

