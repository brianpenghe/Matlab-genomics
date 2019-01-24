function write10XCount=write10XCount(Matrix_dm,MtxFile,GeneFile,CellFile)
%write10XCount is a function to save DataMatrix-format 10X single-cell RNA-seq UMI counts as MatrixMarket formats
%read10XCount(Matrix_dm,'matrix.mtx','genes.tsv','barcodes.tsv')
%read10XCount(Matrix_dm)
if nargin < 2
    MtxFile='matrix.mtx';
    GeneFile='genes.tsv';
    CellFile='barcodes.tsv';
end

delete 'matrix.mtx.txt' 'genes.tsv.txt' 'barcodes.tsv.txt'
SaveCell(split(get(Matrix_dm,'RowNames'),'_'),strcat(GeneFile,'.txt'));
SaveCell(get(Matrix_dm,'ColNames')',strcat(CellFile,'.txt'));

fileID=fopen(strcat(MtxFile,'.txt'),'w');
fprintf(fileID,'%s\n','%%MatrixMarket matrix coordinate integer general');
fprintf(fileID,'%s\n','%metadata_json: {"format_version": 2, "software_version": "3.0.1"}');
fclose(fileID);
[row col v]=find(double(Matrix_dm));
dlmwrite(strcat(MtxFile,'.txt'),[size(Matrix_dm,1),size(Matrix_dm,2),sum(sum(Matrix_dm>0));[row col v]],'precision',16,'delimiter','\t','-append');
         
copyfile(strcat(MtxFile,'.txt'),MtxFile);
copyfile(strcat(GeneFile,'.txt'),GeneFile);
copyfile(strcat(CellFile,'.txt'),CellFile);
end

