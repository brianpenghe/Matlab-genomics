function GeneFPKM = GeneFPKM(FPKM,head)
%GeneFPKM is a function to plot the stacked bars of gene counts at different abundance levels 
%Useful for investigating the qualities of RNA-seq libraries
%GeneFPKM = GeneFPKM(FPKM,head)
%The FPKM table should have rows for genes and columns for samples

[m n]=size(FPKM);
GeneFPKM=[];
CutOffs=[0.1 1 2 5 10 50 500 5000 Inf];
for i=1:n
for j=1:8
GeneFPKM(j,i)=sum(FPKM(:,i)>=CutOffs(j) & FPKM(:,i)<CutOffs(j+1));
end
end

figure;bar(GeneFPKM(8:-1:1,:)','stack')
colormap(flipud(colormap(jet)))
end

