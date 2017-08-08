function SaveClusterColumnLabels = SaveClusterColumnLabels(Cluster)
%SaveClusterColumnLabels is a function to write the ColumnLabels of a 1x1
%clustergram into a file named as the clustergram
%Useful for saving ColumnLabels of subclusters
%SaveClusterColumnLabels(Cluster)

s=inputname(1);
ColumnLabels=flipud(get(Cluster,'ColumnLabels'))';
SaveCell(ColumnLabels,s);
end
