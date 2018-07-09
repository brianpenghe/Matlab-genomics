function [ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = CCAPlot(MatrixA,MatrixB, Head,GeneName,MetaName,d,N,dim)
%The input matrices are a gene X sample matrix and a metadata matrix
%             Sample1 Sample2 Sample3
%      loggene1
%      loggene2
%      loggene3
%
%      meta1
%      meta2
%      meta3

%CCAPlot is a function to conduct Canonical correlation analysis and generate plots
%filtering and log transformation may have to be performed before using this function
%array d is required for specifying colors
%array Head is needed for labeling Sample Names
%This function depends on other functions in the same folder
%function [ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = CCAPlot(MatrixA,MatrixB, Head,GeneName,MetaName,d,N)
%This function depends on discretize.m which only works on Matlab R2016b or later
if nargin < 8
    dim = 20;
end
if nargin < 7
    N=100
end
if nargin < 6
    error('Not enough input arguments.')
end

[m n]=size(GeneName);
if m==1 && n>1
disp('We transposed your new array')
NewArr0=GeneName';
GeneName=NewArr0;
end;
[m n]=size(MetaName);
if m==1 && n>1
disp('We transposed your new array')
NewArr0=MetaName';
MetaName=NewArr0;
end;

[ACOEFF,BCOEFF,rCORR,USCORE,VSCORE,stats] = canoncorr(MatrixA',MatrixB');
colormap(jet);

AIndex=ACOEFF; %This is just for getting the same dimentionality
BIndex=BCOEFF;
[Am An]=size(ACOEFF);
[Bm Bn]=size(BCOEFF);
iend=min(dim,min(An,Bn))
for i=1:iend
    [testA,AIndex(:,i)]=sort(ACOEFF(:,i));
    [testB,BIndex(:,i)]=sort(BCOEFF(:,i));
    SaveCell([GeneName(AIndex(testA<0,i)) Mat2StrArray(testA(testA<0))],strcat(num2str(i),'_PC_neg.txt'));
    SaveCell(flipud([GeneName(AIndex(testA>0,i)) Mat2StrArray(testA(testA>0))]),strcat(num2str(i),'_PC_pos.txt'));
    SaveCell([MetaName(BIndex(testB<0,i)) Mat2StrArray(testB(testB<0))],strcat(num2str(i),'_meta_neg.txt'));
    SaveCell(flipud([MetaName(BIndex(testB>0,i)) Mat2StrArray(testB(testB>0))]),strcat(num2str(i),'_meta_pos.txt'));
end

figure;
colormap(jet)
scatter3(USCORE(:,1),USCORE(:,2),USCORE(:,3),50,d,'filled');
ylabel(strcat('CC2(',strcat(num2str(rCORR(2))),')'))
zlabel(strcat('CC3(',strcat(num2str(rCORR(3))),')'))
xlabel(strcat('CC1(',strcat(num2str(rCORR(1))),')'))
text(USCORE(:,1),USCORE(:,2),USCORE(:,3),Head);
title('U scores');

figure;
colormap(jet)
scatter3(VSCORE(:,1),VSCORE(:,2),VSCORE(:,3),50,d,'filled');
ylabel(strcat('CC2(',strcat(num2str(rCORR(2))),')'))
zlabel(strcat('CC3(',strcat(num2str(rCORR(3))),')'))
xlabel(strcat('CC1(',strcat(num2str(rCORR(1))),')'))
text(VSCORE(:,1),VSCORE(:,2),VSCORE(:,3),Head);
title('V scores');

figure;
gplotmatrix_corrheat(USCORE,VSCORE,[],[],'.',2,[],'hist',Mat2StrArray(1:An),Mat2StrArray(1:Bn),corr(USCORE,VSCORE))
Acof=clustergram(ACOEFF,'Standardize',1,'Colormap',colormap(jet),'Cluster',1,'ColumnLabels',Mat2StrArray(1:An),'RowLabels',GeneName)
addTitle(Acof,'X vs. U')
Bcof=clustergram(BCOEFF,'Standardize',1,'Colormap',colormap(jet),'Cluster',1,'ColumnLabels',Mat2StrArray(1:Bn),'RowLabels',MetaName)
addTitle(Bcof,'Y vs. V')
AcofHM=HeatMap(ACOEFF,'Standardize',1,'Colormap',colormap(jet),'DisplayRange',2.5,'ColumnLabels',Mat2StrArray(1:An),'RowLabels',GeneName)
addTitle(AcofHM,'X vs. U')
BcofHM=HeatMap(BCOEFF,'Standardize',1,'Colormap',colormap(jet),'DisplayRange',2.5,'ColumnLabels',Mat2StrArray(1:Bn),'RowLabels',MetaName)
addTitle(BcofHM,'Y vs. V')
uscoreHM=HeatMap(transpose(USCORE(:,An:-1:1)),'Standardize',2,'DisplayRange',2.5,'Symmetric','true','Colormap',colormap(jet),'RowLabels',[An:-1:1],'ColumnLabels',Head)
addTitle(uscoreHM,'U scores')
vscoreHM=HeatMap(transpose(VSCORE(:,Bn:-1:1)),'Standardize',2,'DisplayRange',2.5,'Symmetric','true','Colormap',colormap(jet),'RowLabels',[Bn:-1:1],'ColumnLabels',Head)
addTitle(vscoreHM,'V scores')
end

