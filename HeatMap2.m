function MyClustergram = HeatMap2(P,RowLabels,ColumnLabels,I)
%HeatMap2 is a function to plot heatmaps, similar to HeatMap2 but it doesn't flip upside-down the matrix'
%Value matrix I is Optional
%Data matrix P is required
figure;
imagesc(P);

[An Bn]=size(P);
if nargin == 4
    for i = 1:An
        for j = 1:Bn
            textHandles(j,i) = text(j,i,num2str(I(i,j)),...
                        'horizontalAlignment','center');
        end
    end
end

if nargin > 1
    set(gca,'XTick',[1:Bn],'XTickLabel',strrep(ColumnLabels,'_','\_'),'XTickLabelRotation',90)
    set(gca,'YTick',[1:An],'YTickLabel',strrep(RowLabels,'_','\_'))
end;

end