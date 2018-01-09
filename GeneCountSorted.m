function GeneCountSorted = GeneCountSorted(FPKM)
%GeneCountSorted is a function to plot the stacked bars of gene counts at different abundance levels 
%Useful for investigating the qualities of RNA-seq libraries
%GeneCountSorted = GeneCountSorted(FPKM)
%The input array table should have rows for genes and columns for samples

[m n]=size(FPKM);
GeneFPKM=[];
CutOffs=[1 2 3 4 5 6 7 10 20 50 Inf];
for i=1:n
for j=1:10
GeneFPKM(j,i)=sum(FPKM(:,i)>=CutOffs(j) & FPKM(:,i)<CutOffs(j+1));
end
end
[temp index]=sort(sum(GeneFPKM));
figure;bar(GeneFPKM(10:-1:1,index)','stack')
colormap(flipud(colormap(jet)))
end

