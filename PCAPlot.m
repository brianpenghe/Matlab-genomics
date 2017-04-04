function [COEFF,SCORE,latent] = PCAPlot(Matrix,Head,GeneName,d)
%PCAPlot is a function to calculate PCs and plot out an image and .avi video
%The Matrix is to be transposed if you do Sample PCA for a gene table
%filtering and log transformation may have to be performed before using this function
%array d is required for specifying colors
%array Head is needed for labeling Sample Names
%This function depends on other functions in the same folder
%function [COEFF,SCORE,Latent] = PCAPlot(Matrix,Head,d);
%This function depends on discretize.m which only works on Matlab R2016b or later

[COEFF,SCORE,latent] = princomp(Matrix);
figure;
colormap(jet)
scatter3(SCORE(:,1),SCORE(:,2),SCORE(:,3),50,d,'filled');
ylabel(strcat('PC2(',strcat(num2str(round(latent(2)/sum(latent)*100)),'%'),')'))
zlabel(strcat('PC3(',strcat(num2str(round(latent(3)/sum(latent)*100)),'%'),')'))
xlabel(strcat('PC1(',strcat(num2str(round(latent(1)/sum(latent)*100)),'%'),')'))
text(SCORE(:,1)+0.5,SCORE(:,2)+0.5,SCORE(:,3)+0.5,Head);
OptionZ.FrameRate=60;OptionZ.Duration=11;OptionZ.Periodic=true;
CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10],'testvid.avi',OptionZ)
Index=COEFF; %This is just for getting the same dimentionality
for i=1:20
    [test,Index(:,i)]=sort(COEFF(:,i));
    SaveCell(GeneName(Index(1:100,i)),strcat(num2str(i),'_neg.txt'));
    SaveCell(GeneName(Index(end:-1:end-99,i)),strcat(num2str(i),'_pos.txt'));
end

PlotSet=reshape(Index([1:100 end:-1:end-99],1:3),600,1);
[Y,E]=discretize(COEFF(:,1),100);
figure;
scatter3(COEFF(:,1),COEFF(:,2),COEFF(:,3),20,Y,'filled')
text(COEFF(PlotSet,1),COEFF(PlotSet,2),COEFF(PlotSet,3),GeneName(PlotSet))
end

