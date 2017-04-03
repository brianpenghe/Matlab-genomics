function [Acount Bcount Icount] = MetaIntersect(A,B)
%MetaIntersect intersects the lists(columns) of string items stored in tableA and tableB in a pairwise fashion
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

[Am An]=size(A);
[Bm Bn]=size(B);
Icount=repmat([0],An,Bn); %initialize the matrix
Acount=repmat([0],An,1);
Bcount=repmat([0],1,Bn);

for i=1:An
    A1=table2cell(A(:,i));
    A2=A1(~cellfun('isempty',A1));
    [Acount(i) test]=size(A2);
    for j=1:Bn
        B1=table2cell(B(:,j));
        B2=B1(~cellfun('isempty',B1));
        [Bcount(j) test]=size(B2);
        [Icount(i,j) test]=size(intersect(A2,B2));
    end
end

