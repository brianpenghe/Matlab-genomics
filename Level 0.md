### Supervised manual hierarchical clustering and visualization

PMBCClg=clustergram(PMBC_perc_filtered(I(1:2000),:),'Standardize',0,'DisplayRange',7.5,'Colormap',colormap(jet),'RowPDist','correlation','ColumnPDist','spearman','Symmetric',false,'linkage','complete', 'OptimalLeafOrder',false)

<img width="735" alt="screen shot 2018-10-05 at 3 15 41 pm" src="https://user-images.githubusercontent.com/4110443/46562583-8c18c400-c8b1-11e8-9b8c-6d3828650f16.png">

Now you get a clustergram which can be annotated interactively following [Matlab Clustergram Manual](https://www.mathworks.com/help/bioinfo/ref/clustergram.html) to make it look like the following

<img width="816" alt="screen shot 2018-10-05 at 4 10 16 pm" src="https://user-images.githubusercontent.com/4110443/46563949-321bfc80-c8b9-11e8-91a8-a37fd0e8f0ea.png">

And save (by right clicking) individual clusters into workspace as Cluster1, Cluster2 etc.

<img width="472" alt="screen shot 2018-10-05 at 3 33 42 pm" src="https://user-images.githubusercontent.com/4110443/46563037-1f52f900-c8b4-11e8-846c-14735f7538d1.png">

#### Check expression of specific gene lists

If you want to see expression levels of a set of genes, you can put the names of them in text.dat
![screen shot 2018-09-28 at 4 29 08 pm](https://user-images.githubusercontent.com/4110443/46237810-c7f4dc00-c33b-11e8-9ace-9cd51846d6bf.png)

And then import this list to an array
```
GenesOfInterest=table2array(readtable('test.dat','ReadVariableNames',false,'Delimiter','\t'))
```
Then plot a HeatMap matching the cell order of your clustergram
```
HeatMap(PMBC_perc(GenesOfInterest,get(PMBCClg,'ColumnLabels')),'Standardize',2,'Colormap',colormap(jet),'Symmetric',true,'DisplayRange',2.5)
```
<img width="771" alt="screen shot 2018-10-05 at 6 12 10 pm" src="https://user-images.githubusercontent.com/4110443/46565895-37ce0e00-c8ca-11e8-97c1-dcb391241ee4.png">


*If you only know the gene name (e.g. HOPX) but not the gene ID, you can look it up using this:*
```
get(PMBCdm(strcontain('HOPX',get(PMBCdm,'RowNames')),:),'RowNames')
```
*It will show*

![screen shot 2018-09-28 at 5 04 58 pm](https://user-images.githubusercontent.com/4110443/46238414-aa764100-c340-11e8-8554-5be376fa6801.png)

### t-SNE plot
Before we do this, let's first drop down our manually assigned cell clusters from clustering analysis.
Based on the coloring in the example image, the clusters are:
```
ClusterID=repmat([0],size(get(PMBCClg,'ColumnLabels')));
ClusterID(GetOrder(get(Cluster1,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=1;
ClusterID(GetOrder(get(Cluster2,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=2;
ClusterID(GetOrder(get(Cluster3,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=3;
ClusterID(GetOrder(get(Cluster4,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=4;
ClusterID(GetOrder(get(Cluster5,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=5;
ClusterID(GetOrder(get(Cluster6,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=6;
ClusterID(GetOrder(get(Cluster7,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=7;
ClusterID(GetOrder(get(Cluster8,'ColumnLabels'),get(PMBCClg,'ColumnLabels')))=8;
```
Now inspect top 30 PCs for the normalized dataset (you can use normalized values, if you use the function [zscore()](https://www.mathworks.com/help/stats/zscore.html?searchHighlight=zscore&s_tid=doc_srchtitle)).
```
[COEFF,SCORE,latent]=PCAPlot(double(PMBC_perc_filtered(I(1:2000),get(PMBCClg,'ColumnLabels'))),get(PMBCClg,'ColumnLabels'),get(PMBC_perc_filtered(I(1:2000),:),'RowNames'),UMICount,100,30);
```
Among the outputs you get an image of PC scores, where each row represents each PC's scores across individual cells, ordered in the same way as the clustergram you generated.
<img width="515" alt="screen shot 2018-10-05 at 6 41 52 pm" src="https://user-images.githubusercontent.com/4110443/46566430-29382480-c8d3-11e8-8796-3a69eb74c33c.png">

Based on this diagram, we see that only the top 10 PCs show cell-type specificity. So we only use these 10 PCs to plot t-SNE.

Now calculate t-SNE coordinates and plot
```
mappedX=tsne(double(PMBC_perc_filtered(I(1:2000),get(PMBCClg,'ColumnLabels')))','Algorithm','barneshut','NumPCAComponents',10,'Distance','spearman','Perplexity',30);
scatter(mappedX(:,1),mappedX(:,2),50,[0.8 0.8 0.8],'.')
``` 
![untitled](https://user-images.githubusercontent.com/4110443/46567228-7375d180-c8e4-11e8-9364-a1ac24ae106e.jpg)

*You should right click mappedX in Workspace window to save it to a file. So that next time you can use mappedX=importdata(); to import it*

Now paint the t-SNE plot with cluster colors.
```
hold on
scatter(mappedX(ClusterID==1,1),mappedX(ClusterID==1,2),50,[0 0.45 0.74],'.')
scatter(mappedX(ClusterID==2,1),mappedX(ClusterID==2,2),50,[0.85 0.33 0.1],'.')
scatter(mappedX(ClusterID==3,1),mappedX(ClusterID==3,2),50,[0.93 0.69 0.13],'.')
scatter(mappedX(ClusterID==4,1),mappedX(ClusterID==4,2),50,[0.49 0.18 0.56],'.')
scatter(mappedX(ClusterID==5,1),mappedX(ClusterID==5,2),50,[0.47 0.67 0.19],'.')
scatter(mappedX(ClusterID==6,1),mappedX(ClusterID==6,2),50,[0.3 0.75 0.93],'.')
scatter(mappedX(ClusterID==7,1),mappedX(ClusterID==7,2),50,[0.64 0.08 0.18],'.')
scatter(mappedX(ClusterID==8,1),mappedX(ClusterID==8,2),50,[1 0 0],'.')
```

![untitled](https://user-images.githubusercontent.com/4110443/46567238-b89a0380-c8e4-11e8-931d-a4ba22b8c7d7.jpg)

#### Unsupervised k-means clustering
Of course, you can do an unsupervised clustering using the top 10 PCs I mentioned above.
kmeans_colors=distinguishable_colors(10);
scatter(mappedX(:,1),mappedX(:,2),50,kmeans_colors(kmeans(SCORE(:,1:10),10),:),'.');

![untitled](https://user-images.githubusercontent.com/4110443/46567688-c30bcb80-c8eb-11e8-94bf-9cbfe379af40.jpg)

#### Check expression of a specific gene
```
figure
scatter(mappedX(:,1),mappedX(:,2),50,PMBC_perc('ENSG00000105369_CD79A',get(PMBCClg,'ColumnLabels')),'.')
colormap(hot)
```
![untitled](https://user-images.githubusercontent.com/4110443/46567725-acb23f80-c8ec-11e8-8858-c5ff76de3a3f.jpg)
