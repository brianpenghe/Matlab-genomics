function PlotSubsetFPKM = PlotSubsetFPKM(FPKM,Gname,head,type)
%PlotSubsetFPK is a function to plot the heatmap of FPKM values of a subset of genes 
%Useful for investigating the expression patterns of a short list of genes
%PlotSubsetFPKM = PlotSubsetFPKM(FPKM,GeneName,head,type)
%The gene list should be stored in a single column in test.dat in the
%current directory
%possible types out plots: c(luster) d(ouble cluster) h(eatmap) o(rdered heatmap)
if nargin == 3
type = 'c';
end;

A=readtable('test.dat','ReadVariableNames',false);
B=table2cell(A);
if type == 'c'
clustergram(log2(FPKM(ismember(Gname,B),:)+0.1),'DisplayRange',12,'Cluster',1,'RowLabels',Gname(ismember(Gname,B)),'RowPDist','correlation','ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false')
elseif type == 'd'
clustergram(log2(FPKM(ismember(Gname,B),:)+0.1),'DisplayRange',12,'RowLabels',Gname(ismember(Gname,B)),'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false')
elseif type == 'h'
HeatMap(log2(FPKM(ismember(Gname,flipud(B)),:)+0.1),'DisplayRange',12,'RowLabels',Gname(ismember(Gname,flipud(B))),'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false')
elseif type == 'o'
HeatMap(log2(FPKM(GetOrder(flipud(B),Gname),:)+0.1),'DisplayRange',12,'RowLabels',Gname(GetOrder(flipud(B),Gname)),'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false')
end

