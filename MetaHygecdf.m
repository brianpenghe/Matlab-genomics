function [P Tail]= MetaHygecdf(A,B,M)
%MetaHygecdf makes use of the output of MetaIntersect to calculate hypergeometric enrichment cdf between columns of tableA and tableB
%Useful for enrichment analysis
%A and B are total counts
%I are intersect counts 
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
[AA BB I] = MetaIntersect(A,B); 
P=I;    %initialize matrix
Tail=I;

[An Bn]=size(I);

for i=1:An
    for j=1:Bn
        P(i, j)=hygecdf(I(i,j),M,AA(i),BB(j));
        Tail(i, j)=hygecdf(I(i,j),M,AA(i),BB(j),'upper');
    end
end

figure
colormap(jet)
imagesc(max(-log10(P*An*Bn),0));

for i = 1:An
    for j = 1:Bn
    textHandles(j,i) = text(j,i,num2str(I(i,j)),...
                        'horizontalAlignment','center');
    end
end
set(gca,'XTick',[1:Bn],'XTickLabel',strrep(B.Properties.VariableNames,'_','\_'),'XTickLabelRotation',90)
set(gca,'YTick',[1:An],'YTickLabel',strrep(A.Properties.VariableNames,'_','\_'))


figure
colormap(pink)
imagesc(max(-log10(Tail*An*Bn),0))
% add count labels

for i = 1:An
    for j = 1:Bn
    textHandles(j,i) = text(j,i,num2str(I(i,j)),...
                        'horizontalAlignment','center');
    end
end
set(gca,'XTick',[1:Bn],'XTickLabel',strrep(B.Properties.VariableNames,'_','\_'),'XTickLabelRotation',90)
set(gca,'YTick',[1:An],'YTickLabel',strrep(A.Properties.VariableNames,'_','\_'))

end
