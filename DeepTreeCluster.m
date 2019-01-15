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
%Inspect is the mode you want to run
%  Mode -1 is the fastest mode. Mode 2 is the most informative one.
%function DTClg = DeepTreeCluster(LogMatrix,CutOff,CladeSize)
%function [GeneOrder CellOrder] = DeepTreeCluster(LogMatrix,CutOff,CladeSize,1)
if nargin < 3
    CutOff=0.8;
    CladeSize=2;
end

if nargin < 4
    Inspect=2
end

Y=pdist(LogMatrix,'correlation');        
Z=linkage(Y,'complete');
dendrogram(Z,size(LogMatrix,1),'ColorThreshold',CutOff,'Orientation','left')
T=cluster(Z,'cutoff',CutOff,'criterion','distance');
temp=tabulate(T);
cdfplot(temp(:,2))
if Inspect>0
    if Inspect>1
        Clg=clustergram(LogMatrix,'Standardize',0,'RowPDist','correlation','ColumnPDist','spearman','DisplayRange',7.5,'Colormap',colormap(jet),'Symmetric',false,'linkage','complete', 'OptimalLeafOrder',false,'dendrogram',[CutOff 0]);
        set(Clg,'Standardize',2,'DisplayRange',2.5,'Symmetric',true)
    end
    DTClg=clustergram(LogMatrix(ismember(T,temp(temp(:,2)>CladeSize,1)),:),'Standardize',0,'RowPDist','correlation','ColumnPDist','spearman','DisplayRange',7.5,'Colormap',colormap(jet),'Symmetric',false,'linkage','complete', 'OptimalLeafOrder',false);
    set(DTClg,'Standardize',2,'DisplayRange',2.5,'Symmetric',true)
else
    Y2Row=pdist(LogMatrix(ismember(T,temp(temp(:,2)>CladeSize,1)),:),'correlation');
    Y2Col=pdist(LogMatrix(ismember(T,temp(temp(:,2)>CladeSize,1)),:)','spearman');
    LogMatrixIndex=1:size(LogMatrix,1);
    LogMatrixIndex2=LogMatrixIndex(ismember(T,temp(temp(:,2)>CladeSize,1)));
    Z2Row=linkage(Y2Row,'complete');
    Z2Col=linkage(Y2Col,'complete');
    figure;
                [DTClg.H2Row,DTClg.T2Row,outperm2Row]=dendrogram(Z2Row,size(LogMatrixIndex2,2),'Orientation','left');
    DTClg.outperm2Row=LogMatrixIndex2(outperm2Row);
    if Inspect<0
    else
        figure;
        [DTClg.H2Col,DTClg.T2Col,DTClg.outperm2Col]=dendrogram(Z2Col,size(LogMatrix,2));
    end
end
end
