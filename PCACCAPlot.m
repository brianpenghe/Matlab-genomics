function [COEFF,SCORE,latent,ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = PCACCAPlot(Matrix,MatrixB,Head,GeneName,MetaName,d,N)
%The input matrix is a gene X sample matrix
%             Sample1 Sample2 Sample3
%      gene1
%      gene2
%      gene3
%
%The input MatrixB is a metadata matrix
%             Sample1 Sample2 Sample3
%      meta1
%      meta2
%      meta3
%PCACCAPlot is a function to run PCAPlot, CCAPlot and additional coefficient calculations
%function [COEFF,SCORE,latent,ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats,UltiCOEFF] = PCAPlot(Matrix,Head,GeneName,d,N)
%This function depends on discretize.m which only works on Matlab R2016b or later
figure;
[COEFF,SCORE,latent] = PCAPlot(Matrix,Head,GeneName,d,N);
[ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = CCAPlot(SCORE(:,1:20)',MatrixB,Head,Mat2StrArray([1:20]'),MetaName,d,N);
              
end

