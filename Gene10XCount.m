function Gene10XCount = Gene10XCount(CountTable, SortYes)
%Gene10XCount is a function to plot the stacked bars of (fractions of) gene counts at different abundance cutoffs 
%Useful for investigating the qualities of RNA-seq libraries
%Gene10XCount = Gene10XCount(CountTable,head)
%The CountTable table should have rows for genes and columns for samples. It is already scaled by yourself (or not)
%This program does not scale the counts within each cell.

if nargin < 2
    SortYes = 0;
end;

[m n]=size(CountTable);
Gene10XCount=[];
CutOffs=[0 1 2 5 10 50 100 1000 Inf];
for i=1:n
    for j=1:8
        Gene10XCount(j,i)=sum(CountTable(:,i)>CutOffs(j) & CountTable(:,i)<=CutOffs(j+1));
    end
end

figure;
if SortYes == 0
    b=bar(Gene10XCount(8:-1:1,:)','stack','FaceColor','flat');
    for k=1:size(Gene10XCount(8:-1:1,:)',2)
        b(k).CData = k;
    end
else
    [P I]=sort(sum(Gene10XCount));
    b=bar(Gene10XCount(8:-1:1,I)','stack','FaceColor','flat');
    for k=1:size(Gene10XCount(8:-1:1,I)',2)
        b(k).CData = k;
    end
end
cmap = colormap(flipud(colormap(jet))); %Create Colormap
cbh = colorbar ; %Create Colorbar
cbh.TickLabels = num2cell(fliplr(CutOffs(1:8))) ;    %Replace the labels of these 8 ticks 

end

