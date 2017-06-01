function biog = PlotBipar(Filename,Cap,TransformMethod)
%PlotBipar plots a bipartite graph based on the matrix stored in the file Filename
%The matrix in the Filaname is a logical matrix where Cij~=0 indicates i -> j. Cij is the weight of the edge
%RowNames and VariableNames have to be included in the Filaname
%It also converts the matrix into a square one
% Old matrix               New Matrix
%                          -------
% *#*%^                    -------
% #^%!#                    -------
%                          -------
%                          -------
%                          *#*%^--
%                          #^%!#--
%
%TransformMethod is optional. It can be 'l'(og) or 's'(qrt)
%Censor ultrahigh values to Cap

CMatrix=readtable(Filename,'ReadRowNames',true,'ReadVariableNames',true);
Name1=CMatrix.Properties.RowNames;
Name2=CMatrix.Properties.VariableNames';
[m1 n1]=size(Name1);
[m2 n2]=size(Name2);

CMatrix2=repmat([0],m1+m2);
CMatrix2(1:m1,end-m2+1:end)=table2array(CMatrix);

CMatrix3=CMatrix2;
CMatrix3(CMatrix3>0)=1;
biog=biograph(CMatrix3,[Name1;Name2]','LayoutType','radial');
for i=1:m1
    set(biog.Nodes(i),'Color',[1,0.5,0.5])
end
for i=m1+1:m1+m2
    set(biog.Nodes(i),'Color',[0.7,0.7,1])
    set(biog.Nodes(i),'Shape','Circle')
end

Weights=reshape(CMatrix2,[],1);
Weights(Weights==0)=[];
              
if nargin<3
    'No Transformation'
else
    if TransformMethod=='l'
        Weights=log10(Weights);
    elseif TransformMethod=='s'
        Weights=sqrt(Weights);
    end;
end;

if nargin>1
    Weights(Weights>Cap)=Cap;
end;
              
Weights=Weights./max(Weights)*2;
[m n] = size(Weights);
for i=1:m
    biog.Edges(i).LineWidth=Weights(i);
end;
              
view(biog)
end