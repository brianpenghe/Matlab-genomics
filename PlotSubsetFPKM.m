function PlotSubsetFPKM = PlotSubsetFPKM(FPKM,Gname,head,type)
%PlotSubsetFPK is a function to plot the heatmap of FPKM values of a subset of genes 
%Useful for investigating the expression patterns of a short list of genes
%PlotSubsetFPKM = PlotSubsetFPKM(FPKM,GeneName,head)
%The gene list should be stored in a single column in test.dat in the
%current directory
if nargin == 3
type = 'c';
end;

A=readtable('test.dat','ReadVariableNames',false);
B=table2cell(A);
[C,ia,ib]=intersect(Gname,B);
if type == 'c'
clustergram(log2(FPKM(ia,:)+0.1),'DisplayRange',12,'Cluster',1,'RowLabels',Gname(ia),'RowPDist','correlation','ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false')
else if type == 'h'
HeatMap(log2(FPKM(ia,:)+0.1),'DisplayRange',12,'RowLabels',Gname(ia),'ColumnLabels',head,'Colormap',colormap(jet),'Symmetric','false')
end
end