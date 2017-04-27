function mappedX = tsnePlot(Matrix,d,sc)
%Please remember to transpose if you want do reduce rows!!!!!!!
%tsnePlot is a function to reduce the dimension of columns
%The Matrix is to be transposed if you do Sample tsne for a gene table
%filtering and log transformation may have to be performed before using this function
%array d is required for specifying colors
%array sc is optional for specifying sizes, default is all 50
%array Head is needed for labeling Sample Names
%This function depends on other functions in the same folder
%function mappedX = tsnePlot(Matrix,Head,d);

if nargin < 3
    sc = 50;
end;

mappedX = tsne(Matrix,[], 2, 30, 30);
figure;
colormap(jet)
scatter(mappedX(:,1),mappedX(:,2),sc,d,'filled');
end

