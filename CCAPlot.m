function [ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = CCAPlot(MatrixA,MatrixB, Head,GeneName,MetaName,d,N)
%The input matrices are a gene X sample matrix and a metadata matrix
%             Sample1 Sample2 Sample3
%      loggene1
%      loggene2
%      loggene3
%
%      meta1
%      meta2
%      meta3

%CCAPlot is a function to conduct Canonical correlation analysis and generate plots
%The Matrix is to be transposed if you do Sample PCA for a gene table, by this program
%filtering and log transformation may have to be performed before using this function
%array d is required for specifying colors
%array Head is needed for labeling Sample Names
%This function depends on other functions in the same folder
%function [ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = CCAPlot(MatrixA,MatrixB, Head,GeneName,MetaName,d,N)
%This function depends on discretize.m which only works on Matlab R2016b or later
figure;
if nargin < 7
    N=100
end
if nargin < 6
    error('Not enough input arguments.')
end

[ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = canoncorr(MatrixA',MatrixB');
colormap(jet);

AIndex=ACOEFF; %This is just for getting the same dimentionality
BIndex=BCOEFF;
[Am An]=size(ACOEFF);
[Bm Bn]=size(BCOEFF);
iend=min(20,min(An,Bn))
for i=1:iend
    [testA,AIndex(:,i)]=sort(ACOEFF(:,i));
    [testB,BIndex(:,i)]=sort(BCOEFF(:,i));
    SaveCell([GeneName(AIndex(testA<0,i)) Mat2StrArray(testA(testA<0))],strcat(num2str(i),'_gene_neg.txt'));
    SaveCell(flipud([GeneName(AIndex(testA>0,i)) Mat2StrArray(testA(testA>0))]),strcat(num2str(i),'_gene_pos.txt'));
    SaveCell([MetaName(BIndex(testB<0,i)) Mat2StrArray(testB(testB<0))],strcat(num2str(i),'_meta_neg.txt'));
    SaveCell(flipud([MetaName(BIndex(testB>0,i)) Mat2StrArray(testB(testB>0))]),strcat(num2str(i),'_meta_pos.txt'));
end



end

