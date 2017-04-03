function [P Tail]= MetaHygecdf(A,B,M)
%MetaHygecdf makes use of the output of MetaIntersect to calculate hypergeometric enrichment cdf between columns of tableA and tableB
%Useful for enrichment analysis
%Acount and Bcount are total counts
%Icount are intersect counts 
%                 **B***D*i*m*e*n*s*i*o*n**
%                
%               * *************************
%               A *                       *
%               * *      Icount           *
%               D *                       *
%               i *                       *
%               m *                       *
%               * *************************
%The outputs are a matrix of p values and another of upper tails
%M is a constant representing total population size
%The x, M, k, N are explained in Matlab readme of hypecdf.m

[AA BB I] = MetaIntersect(A,B); 
P=I;    %initialize matrix
Tail=I;

[An Bn]=size(I);

Icount=repmat([0],An,Bn); %initialize the matrix
Acount=repmat([0],An,1);
Bcount=repmat([0],1,Bn);

for i=1:An
    for j=1:Bn
        P(i, j)=hygecdf(I(i,j),M,AA(i),BB(j));
        Tail(i, j)=hygecdf(I(i,j),M,AA(i),BB(j),'upper');
    end
end
HeatMap(P,'Symmetric',false,'Colormap',colormap(jet))
HeatMap(Tail,'Symmetric',false,'Colormap',colormap(jet))

end