function biog = PlotNetwork(CMatrix)
%PlotBipar plots a network graph based on the square adjacency matrix stored in the file Filename
%The CMatrix in the Filaname is a logical matrix where Cij==1 indicates i -> j
%RowNames and VariableNames have to be identical, stored in the table CMatrix

CMatrix2=table2array(CMatrix);
CMatrix2(CMatrix2>0)=1;

Name1=CMatrix.Properties.RowNames;
Name2=CMatrix.Properties.VariableNames';
if ~isempty(setdiff(Name1,Name2))
    disp('Col and Row Names may not be identical')
end;
biog=biograph(CMatrix2, Name1','LayoutType','radial');

view(biog)
end