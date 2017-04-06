function SortBoard2 = IntersectChecker(A,ColorMap)
%IntersectChecker plots a checkerboard for a table whose columns represent lists that may have elements in common
%An alternative to high dimensional Venn Diagram


[Am An]=size(A);

Pool=unique(reshape(table2cell(A),Am*An,1));
Pool2=Pool(~cellfun('isempty',Pool));
[Pm Pn]=size(Pool2);
Board=repmat([0],Pm,An+1);  %Initialize

for i=1:An
    A1=table2cell(A(:,i));
    A2=unique(A1(~cellfun('isempty',A1)));
    Board(GetOrder(A2,Pool2),i)=1;
end

Board(:,An+1)=sum(Board')';
[SortBoard Index]=sortrows(Board,[An+1 1:An]);

cg=clustergram(SortBoard(:,1:An),'Symmetric',false,'Colormap',colormap(ColorMap),'Cluster',2,'ColumnLabels',A.Properties.VariableNames,'RowLabels',Pool2(Index));

[SortBoard Index]=sortrows(Board,[An+1 GetOrder(get(cg,'ColumnLabels')',(A.Properties.VariableNames)')']);

cg=clustergram(SortBoard(:,1:An),'Symmetric',false,'Colormap',colormap(ColorMap),'Cluster',2,'ColumnLabels',A.Properties.VariableNames,'RowLabels',Pool2(Index));

SortBoard2=SortBoard(:,1:An);
end
