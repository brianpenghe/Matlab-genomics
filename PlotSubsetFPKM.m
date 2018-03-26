function [MyClg MyMat MyLabels] = PlotSubsetFPKM(FPKM,Gname,head,type,PDist,Standardize,pseudocount)
%PlotSubsetFPKM is a function to plot the heatmap of FPKM values of a subset of genes 
%function [MyClg MyMat MyLabels] = PlotSubsetFPKM(FPKM,Gname,head,type,PDist,Standardize,pseudocount)
%Since this script is dedicated for FPKM visualization, we log transform it.Other scripts like PCA.. and tSNE.. ask you to do the transformation 
%Useful for investigating the expression patterns of a short list of genes
%PlotSubsetFPKM = PlotSubsetFPKM(FPKM,GeneName,head,type,PDist)
%The gene list should be stored in a single column in test.dat in the
%current directory
%possible types out plots: c(luster) d(ouble cluster) h(eatmap) o(rdered heatmap) o(rdered)c(lustergram)
%PDist specifies the distance used for clustering cells under d mode
if nargin < 4
type = 'c';
end;
if nargin < 5
PDist = 'euclidean';
end;
if nargin < 6
Standardize = 0;
end;
if nargin < 7
pseudocount = 0.1;
end;
A=readtable('test.dat','ReadVariableNames',false);
B=table2cell(A);
OrderIndex=GetOrder(flipud(B),Gname);
MyMat = FPKM(OrderIndex(OrderIndex>0),:);
MyLabels = Gname(OrderIndex(OrderIndex>0));
if type == 'c'
MyClg = clustergram(log2(MyMat+pseudocount),'DisplayRange',12,'Cluster',1,'RowLabels',MyLabels,'RowPDist','correlation','ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)    %use average linkage which works better for Pearson
elseif type == 'd'
MyClg = clustergram(log2(MyMat+pseudocount),'DisplayRatio',[0.1 0.1],'DisplayRange',7.5,'RowLabels',MyLabels,'RowPDist','correlation','ColumnPDist',PDist,'ColumnLabels',head,'Linkage','complete','Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'h'
MyClg = HeatMap(log2(MyMat+pseudocount),'RowLabels',MyLabels,'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'o'
MyClg = HeatMap(log2(MyMat+pseudocount),'RowLabels',MyLabels,'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'oc'
MyClg = clustergram(log2(MyMat+pseudocount),'OptimalLeafOrder','true','Cluster',2,'Linkage','complete','DisplayRatio',[0.1 0.1],'DisplayRange',12,'RowLabels',MyLabels,'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
end

