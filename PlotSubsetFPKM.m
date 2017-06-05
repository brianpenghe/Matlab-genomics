function [MyClg MyMat MyLabels] = PlotSubsetFPKM(FPKM,Gname,head,type,PDist,Standardize)
%PlotSubsetFPK is a function to plot the heatmap of FPKM values of a subset of genes 
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

A=readtable('test.dat','ReadVariableNames',false);
B=table2cell(A);
OrderIndex=GetOrder(flipud(B),Gname);
MyMat = FPKM(OrderIndex(OrderIndex>0),:);
MyLabels = Gname(OrderIndex(OrderIndex>0));
if type == 'c'
MyClg = clustergram(log2(MyMat+0.1),'DisplayRange',12,'Cluster',1,'RowLabels',MyLabels,'RowPDist','correlation','ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'd'
MyClg = clustergram(log2(MyMat+0.1),'DisplayRatio',[0.1 0.1],'DisplayRange',12,'RowLabels',MyLabels,'RowPDist','correlation','ColumnPDist',PDist,'ColumnLabels',head,'Linkage','complete','Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'h'
MyClg = HeatMap(log2(MyMat+0.1),'DisplayRange',12,'RowLabels',MyLabels,'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'o'
MyClg = HeatMap(log2(MyMat+0.1),'DisplayRange',12,'RowLabels',MyLabels,'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
elseif type == 'oc'
MyClg = clustergram(log2(MyMat+0.1),'OptimalLeafOrder','true','Cluster',2,'Linkage','complete','DisplayRatio',[0.1 0.1],'DisplayRange',12,'RowLabels',MyLabels,'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false','Standardize',Standardize)
end

