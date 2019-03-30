function [P Tail]= TableHygecdf(I)
%TableHygecdf makes use of the Intersect matrix to calculate hypergeometric enrichment cdf. The table is a contingency table. Rows and Columns are two different set of mutually exclusive catogaries. The category labels are VariableNames and RowNames of the table variable.
%Useful for enrichment analysis
%I: intersect counts 
%                 **B***D*i*m*e*n*s*i*o*n**
%                
%               * *************************
%               A *                       *
%               * *      I                *
%               D *                       *
%               i *                       *
%               m *                       *
%               * *************************
%The outputs are a matrix of p values and another of upper tails
%M is a constant representing total population size
%The x, M, k, N are explained in Matlab readme of hypecdf.m

%Sometimes your heatmap may have 0 count sitting at red boxes. This may be caused by the fact that one of the input lists is too small. Remember Matlab defines cdf(X=0)=pmf(X=0) instead of 0.

[An Bn]=size(I);

A = sum(table2array(I)');
B = sum(table2array(I));
M = sum(A); 
%%%%%Calculate head(including i) and tail(excluding i) probablity
for i=1:An
    for j=1:Bn
        P(i, j)=hygecdf(I{i,j},M,A(i),B(j));
        Tail(i, j)=hygecdf(I{i,j},M,A(i),B(j),'upper');
    end
end

%%%%Plot the head figure for depletion
figure
colormap(pink)
imagesc(max(-log10(P*An*Bn),0));
title('Depletion')
hcb=colorbar
colorTitleHandle = get(hcb,'Title');
titleString = '-log_{10}P_{adj}';
set(colorTitleHandle ,'String',titleString);
        
for i = 1:An
    for j = 1:Bn
        textHandles(j,i) = text(j,i,num2str(I{i,j}),...
                        'horizontalAlignment','center');
    end
end
set(gca,'XTick',[1:Bn],'XTickLabel',strrep(I.Properties.VariableNames,'_','\_'),'XTickLabelRotation',90)
set(gca,'YTick',[1:An],'YTickLabel',strrep(I.Properties.RowNames,'_','\_'))

%%%%Plot the tail figure for enrichment
figure
colormap(pink)
imagesc(max(-log10(Tail*An*Bn),0))
title('Enrichment')
hcb=colorbar
colorTitleHandle = get(hcb,'Title');
titleString = '-log_{10}P_{adj}';
set(colorTitleHandle ,'String',titleString);
        
% add count labels

for i = 1:An
    for j = 1:Bn
        textHandles(j,i) = text(j,i,num2str(I{i,j}),...
                        'horizontalAlignment','center');
    end
end
set(gca,'XTick',[1:Bn],'XTickLabel',strrep(I.Properties.VariableNames,'_','\_'),'XTickLabelRotation',90)
set(gca,'YTick',[1:An],'YTickLabel',strrep(I.Properties.RowNames,'_','\_'))

end
