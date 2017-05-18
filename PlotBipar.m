function biog = PlotBipar(Filename)
%PlotBipar plots a bipartite graph based on the matrix stored in the file Filename
%The matrix in the Filaname is a logical matrix where Cij==1 indicates i -> j
%RowNames and VariableNames have to be included in the Filaname

CMatrix=readtable(Filename,'ReadRowNames',true,'ReadVariableNames',true);
Name1=CMatrix.Properties.RowNames;
Name2=CMatrix.Properties.VariableNames';
[m1 n1]=size(Name1);
[m2 n2]=size(Name2);

CMatrix2=repmat([0],m1+m2);
CMatrix2(1:m1,end-m2+1:end)=table2array(CMatrix);
biog=biograph(CMatrix2,[Name1;Name2]','LayoutType','radial');
for i=1:m1
    set(biog.Nodes(i),'Color',[1,0.5,0.5])
end
for i=m1+1:m1+m2
    set(biog.Nodes(i),'Color',[0.7,0.7,1])
    set(biog.Nodes(i),'Shape','Circle')
end
view(biog)
end