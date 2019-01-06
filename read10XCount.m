function Matrix_dm=read10XCount(MtxFile,GeneFile,CellFile)
%read10XCount is a function to import 10X single-cell RNA-seq UMI counts as MatrixMarket formats and converts it into a DataMatrix format on Matlab 
%Matrix_dm = read10XCount('matrix.mtx','genes.tsv','barcodes.tsv')
%the input arguments are paths or names of the input files
if nargin < 1
    MtxFile='matrix.mtx';
    GeneFile='genes.tsv';
    CellFile='barcodes.tsv';
end

if isfile('matrix.mtx.gz')
gunzip('matrix.mtx.gz')
end
if isfile('genes.tsv.gz')
gunzip('genes.tsv.gz')
end
if isfile('barcodes.tsv.gz')
gunzip('barcodes.tsv.gz')
end
if isfile('features.tsv.gz')
gunzip('features.tsv.gz')
end

copyfile(MtxFile,strcat(MtxFile,'.txt'));
copyfile(GeneFile,strcat(GeneFile,'.txt'));
copyfile(CellFile,strcat(CellFile,'.txt'));
tempMatrixMarket=readtable(strcat(MtxFile,'.txt'));
Matrix_matrix=spconvert(table2array(tempMatrixMarket(2:end,:)));
Cells_table=readtable(strcat(CellFile,'.txt'),'ReadVariableNames',false,'Delimiter','\t');
Genes_table=readtable(strcat(GeneFile,'.txt'),'ReadVariableNames',false,'Delimiter','\t');
Genes_array=table2array(Genes_table);
Genes_table2=array2table(strcat(Genes_array(:,1),'_',Genes_array(:,2))); 
tempMatrix_matrix=zeros(size(Genes_table2,1),size(Matrix_matrix,2));
tempMatrix_matrix(1:size(Matrix_matrix,1),1:size(Matrix_matrix,2))=Matrix_matrix;
Matrix_table=[Genes_table2 array2table(tempMatrix_matrix)];
Matrix_table.Properties.VariableNames=[{'Var1'} ValidizeNames(table2array(Cells_table)')];
Matrix_dm=Table2DataMatrix(Matrix_table);
delete(strcat(MtxFile,'.txt'))
delete(strcat(GeneFile,'.txt'))
delete(strcat(CellFile,'.txt'))
end

