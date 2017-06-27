function biog = PlotBipar(Filename,Cap,TransformMethod,Watershed,GraphSize)
%PlotBipar plots a bipartite graph based on the matrix stored in the file Filename
%The matrix in the Filaname is a logical matrix where Cij~=0 indicates i -> j. Cij is the weight of the edge
%RowNames and VariableNames have to be included in the Filename
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
%TransformMethod is optional. It can be 'l'(og) or 's'(qrt) or 'n'(one)
%Censor ultrahigh values to Cap
%Turn small values lower than Watershed to zero
%If nargin==1, weighting is ignored

CMatrix=readtable(Filename,'ReadRowNames',true,'ReadVariableNames',true);
Name1=CMatrix.Properties.RowNames;
Name2=CMatrix.Properties.VariableNames';
[m1 n1]=size(Name1);
[m2 n2]=size(Name2);

CMatrix2=repmat([0],m1+m2);
CMatrix2(1:m1,end-m2+1:end)=table2array(CMatrix);

if nargin<5
    GraphSize=3;
end;
if nargin>3
CMatrix2(CMatrix2<Watershed)=0;
end;

CMatrix3=CMatrix2;
CMatrix3(CMatrix3>0)=1;

CMatrix4=array2table(CMatrix3);
CMatrix4.Properties.RowNames=ValidizeNames([Name1;Name2]);
CMatrix4.Properties.VariableNames=ValidizeNames([Name1;Name2]);
writetable(CMatrix4,'OutputMatrixFromPlotBipar.csv','WriteVariableNames',1,'WriteRowNames',1,'Delimiter',';');
biog=biograph(CMatrix3,[Name1;Name2]','LayoutType','radial','Scale',1,'LayoutScale',GraphSize,'NodeAutoSize','off');
for i=1:m1
    set(biog.Nodes(i),'Color',[1,0.7,0.7])
end
for i=m1+1:m1+m2
    set(biog.Nodes(i),'Color',[0.7,0.7,1])
    set(biog.Nodes(i),'Shape','Circle')
end

if nargin>1
              
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

    Weights(Weights>Cap)=Cap;
              
    Weights=Mat2Colormap(Weights,'cool');
    [m n] = size(Weights);
    for i=1:m
        temp=biog.Edges(i);
        temp.LineColor=Weights(i,:);
        biog.Edges(i)=temp;
    end;
end;              
view(biog)
end