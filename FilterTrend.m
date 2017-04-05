function [GenesPos GenesNeg] = FilterTrend(FPKM,Trend,Gname,head,Cutoff)
%FilterTrend is a function to filter out the genes with a specified trend(increasing or decreasing) 
%Useful for analyzing time-course data
%[Genes Index] = FilterTrend(FPKM,Gname,head,Cutoff)
%Cutoff is the significance threshold alpha for p-value
%Trend is a vector like [1 1 2 2 3 3] as seeds for Spearman

if nargin == 4
Cutoff = 0.01;
end;

[RHO,PVAL]=corr(Trend',log2(FPKM'+0.1),'type','Spearman');
tempPos=log2(FPKM((PVAL<Cutoff & RHO>0),:)+0.1);
tempNeg=log2(FPKM((PVAL<Cutoff & RHO<0),:)+0.1);
tempPosName=Gname(PVAL<Cutoff & RHO>0);
tempNegName=Gname(PVAL<Cutoff & RHO<0);
[MPos,IPos]=sort(RHO(PVAL<Cutoff & RHO>0));
[MNeg,INeg]=sort(RHO(PVAL<Cutoff & RHO<0));
GenesPos=tempPosName(IPos);
GenesNeg=tempNegName(INeg);
HeatMap(flipud([tempNeg(INeg,:);tempPos(IPos,:)]),'standardize',2,'DisplayRange',2.5,'Symmetric','true','Colormap',colormap(jet),'RowLabels',flipud([GenesNeg;GenesPos]),'ColumnLabels',head)

end

