function [MyClg MyMat MyLabels PCAOutput tSNEOutput] = subsetFPKMDimensionReduction(FPKM,Gname,head,type,PDist,Standardize)
%PlotSubsetFPKM, PCAPlot and tsnePlot are called together 
%Useful for quickly reduce FPKM matrix dimensionality
%[MyClg MyMat MyLabels PCAOutput tSNEOutput] = subsetFPKMDimensionReduction(FPKM,Gname,head,type,PDist,Standardize)
%The gene list should be stored in a single column in test.dat in the current directory

if nargin < 4
    type = 'c';
end;
if nargin < 5
    PDist = 'euclidean';
end;
if nargin < 6
    Standardize = 0;
end;

[MyClg MyMat MyLabels]=PlotSubsetFPKM(FPKM,Gname,head,type,PDist,Standardize);
PCAOutput=PCAPlot(log2(MyMat+0.1),head,MyLabels,'black',100);
tSNEOutput=tsnePlot(log2(MyMat+0.1),'black',50,2,Head);

end

