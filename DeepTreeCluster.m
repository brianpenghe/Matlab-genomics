function DTClg = DeepTreeCluster(LogMatrix,CutOff,CladeSize,Inspect)
%The input LogMatrix is a gene X sample DataMatrix that has been loged
%             Sample1 Sample2 Sample3
%      gene1
%      gene2
%      gene3
%DeepTreeCluster is a function to do automatic filtering and clustering to capture the most important features of single-cell RNA-seq data
%pre-filtering and log transformation have to be performed before using this function
%CutOff has to be a number less than 1
%CladeSize is an integer
%function DTClg = DeepTreeCluster(LogMatrix,CutOff,CladeSize)

if nargin < 3
    CutOff=0.8;
    CladeSize=2;
end

if nargin < 4
    Inspect=1
end

Y=pdist(LogMatrix,'correlation');        
Z=linkage(Y,'complete');
dendrogram(Z,50000,'ColorThreshold',CutOff)
T=cluster(Z,'cutoff',CutOff,'criterion','distance');
temp=tabulate(T);
cdfplot(temp(:,2))
if Inspect==1
    Clg=clustergram(LogMatrix,'Standardize',0,'RowPDist','correlation','ColumnPDist','spearman','DisplayRange',7.5,'Colormap',colormap(jet),'Symmetric',false,'linkage','complete', 'OptimalLeafOrder',false,'dendrogram',[CutOff 0]);
    set(Clg,'Standardize',2,'DisplayRange',2.5,'Symmetric',true)
end
DTClg=clustergram(LogMatrix(ismember(T,temp(temp(:,2)>CladeSize,1)),:),'Standardize',0,'RowPDist','correlation','ColumnPDist','spearman','DisplayRange',7.5,'Colormap',colormap(jet),'Symmetric',false,'linkage','complete', 'OptimalLeafOrder',false);
set(DTClg,'Standardize',2,'DisplayRange',2.5,'Symmetric',true)
end

