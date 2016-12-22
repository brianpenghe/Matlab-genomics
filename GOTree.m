function Tree = GOTree(ID,GO)
%GOTree is a function to plot a tree of given GO term ID's 
%The input should be a [] vector containing integers

%function Tree = GOTree(ID)
%make sure you run this first:  GO = geneont('live',true);
%ID = [35116	35115	35136	35137	30326	35113	35107	35108	7275]

testids=num2goid(ID);
testgo=GO(ID);
cm=getmatrix(testgo);
Tree=biograph(cm,get(testgo.Terms,'name'))
view(Tree)

end