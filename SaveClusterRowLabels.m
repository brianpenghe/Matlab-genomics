function SaveClusterRowLabels = SaveClusterRowLabels(Cluster)
%SaveClusterRowLabels is a function to write the RowLabels of a 1x1
%clustergram into a file named as the clustergram
%Useful for saving RowLabels of subclusters
%SaveClusterRowLabels(Cluster)

s=inputname(1);
RowLabels=flipud(get(Cluster,'RowLabels'));
writetable(cell2table(RowLabels),s,'WriteVariableNames',false)
end