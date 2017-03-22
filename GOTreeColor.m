function Tree = GOTree(filename,GO)
%GOTree is a function to plot a tree of given GO term ID's 
%The input should be a [] vector containing integers
%function Tree = GOTree(ID,GO)
%make sure you run this first:  GO = geneont('live',true);
%download the result file from funcassociate
%make sure you replace all the GO:XXXX with XXXX
%Copy paste the original p-value and GO ID columns onto a new file

A=readtable(filename);
[m n]=size(A);
JET=colormap(jet);
ColorCode=-log10(table2array(A(:,1)));
ColorNorm=floor(sqrt((ColorCode-min(ColorCode))./(max(ColorCode)-min(ColorCode)+0.1))*64)+1;
testgo=GO(table2array(A(:,3)));
cm=getmatrix(testgo);
Tree=biograph(cm,get(testgo.Terms,'name'));
for i=1:m
set(Tree.Nodes(i),'Color',JET(ColorNorm(i),:))
end

view(Tree)

end