function GeneFPKM = GeneFPKM(FPKM, SortYes)
%GeneFPKM is a function to plot the stacked bars of gene counts at different abundance levels 
%Useful for investigating the qualities of RNA-seq libraries
%GeneFPKM = GeneFPKM(FPKM,head)
%The FPKM table should have rows for genes and columns for samples

if nargin < 2
    SortYes = 0;
end;

[m n]=size(FPKM);
GeneFPKM=[];
CutOffs=[0 0.1 1 5 10 50 500 5000 Inf];
for i=1:n
    for j=1:8
        GeneFPKM(j,i)=sum(FPKM(:,i)>CutOffs(j) & FPKM(:,i)<=CutOffs(j+1));
    end
end

figure;
if SortYes == 0
    b=bar(GeneFPKM(8:-1:1,:)','stack','FaceColor','flat');
    for k=1:size(GeneFPKM(8:-1:1,:)',2)
        b(k).CData = k;
    end
else
    [P I]=sort(sum(GeneFPKM));
    b=bar(GeneFPKM(8:-1:1,I)','stack','FaceColor','flat');
    for k=1:size(GeneFPKM(8:-1:1,:)',2)
        b(k).CData = k;
    end
end
colormap(flipud(colormap(jet)))
end

