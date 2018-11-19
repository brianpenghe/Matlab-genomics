# Matlab-genomics
Matlab-genomics is a collection of Matlab scripts to perform genomics analysis especially single-cell analysis.
## Introduction
Single-cell analysis has been dominated by packages on open-source platforms such as R and python. However, Matlab has its own advantages and consistency. It has also been a first choice among many researchers originally in Physics and Neuroscience fields who are seeking to dive into the modern Bioinformatics realm.
Therefore, I've assembled a set of handy scripts, some of which are borrowed from other repositories from GitHub and MathWork Fileexhange, if not created on my own, to accelerate Matlab fans' adaption to the Bioinformatics field.

## Installing
Download the whole folder, and then point Matlab to this folder as one of customer scripts. This is the code for Mac Users:

```
addpath(genpath('/Users/Brian/path_to_your_downloaded_and_extracted_codes')); 
```
*PC and Linux users need to pay attention to the path especially forward slash versus backward slash*

## Getting Started
We will use [Seurat package](https://satijalab.org/seurat/pbmc3k_tutorial.html)'s sample data [here](https://s3-us-west-2.amazonaws.com/10x.files/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz) with Matlab 2018a on Mac.

### Import Data
Extracting the file on Unix terminal (or double click on MatLab Finder)
```
tar -xzf pbmc3k_filtered_gene_bc_matrices.tar.gz
```
The data will be in a folder called "filtered_gene_bc_matrices/hg19". Go to that folder.
```
cd filtered_gene_bc_matrices/hg19/
```
Then import matrixmarket data to [DataMatrix](https://www.mathworks.com/help/bioinfo/ug/representing-expression-data-values-in-datamatrix-objects.html), a type similar to [CellDataSet](https://rdrr.io/bioc/monocle/man/CellDataSet.html) in [Monocle](https://rdrr.io/bioc/monocle/) and [SeuratObject](https://rdrr.io/github/satijalab/seurat/man/CreateSeuratObject.html) in [Seurat](https://rdrr.io/github/satijalab/seurat/), on R platform.
```
PMBCdm=read10XCount('matrix.mtx','genes.tsv','barcodes.tsv');
```
or, by default if you used CellRanger to generate matrix.mtx, genes.tsv and barcodes.tsv in the current folder
```
PMBCdm=read10XCount();
```

### Normalize and Filter Data
Log normalize the data
```
PMBC_perc=log2(PMBCdm./sum(PMBCdm)*10000+1);
```
Check Data Quality
```
test=Gene10XCount(PMBCdm,1);
```
The plot shows the numbers of genes with 1 count/2 count/3count etc. The height of each bar represents the total number of genes detected in each cell. 

![untitled](https://user-images.githubusercontent.com/4110443/45000178-a6d8df80-af77-11e8-946e-997b35d97c1d.jpg)

Filter out low-quality cells (less than 500 genes detected) and low-quality genes (detected in less than 0.5% cells)
```
PMBC_perc_filtered=PMBC_perc(sum((PMBC_perc>0),2)>sum(sum(test)>500,2)/200,sum(test)>500);
```
Calculate high-dispersion genes
```
Dispersion=var(PMBC_perc_filtered,0,2)./mean(PMBC_perc_filtered,2);
[P I]=sort(Dispersion,'descend');
```

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
[COEFF,SCORE,latent]=PCAPlot(double(PMBC_perc_filtered(I(1:2000),get(PMBCClg,'ColumnLabels'))),get(PMBCClg,'ColumnLabels'),get(PMBC_perc_filtered(I(1:2000),:),'RowNames'),ClusterID',100,30);
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

## Discussions
### Parameter optimizations
This tutorial tries to present an overview of what we can do with a subset of the scripts here. It uses arbitrary parameters, leaving space for users to play around with their own sets of parameters based on their own trade-offs. Please feel free to change parameters, including gene detection threshold, cell rarity threshold, clustering algorithms, whether to use z-score to do t-SNE, k-means clustering or hierarchical, remove irrelevant PCs first or cluster first, which principal components to use, t-SNE perplexity etc. Additional discussions are welcome. Maximal coding flexibility is in the hands of users.

### Data filtering and batch effect control
The author is strongly against the idea of a magic blackbox that beautifies the data. Existing methods usually "regress out" or "eliminate" so-called "batch-effects" instead of understanding what exactly they are. So in this tutorial the author does not intentionally remove certain groups of genes or those that dance with them because they may have biological meanings to users (stress, cell-cycle phases, duplication etc.).

### Other scripts not mentioned here
Due to the limit of time and space. Many other useful scripts are not mentioned in this tutorial. Users are welcome to explore them or raise issues about them.

### Conclusions
This tutorial demonstrates the ease with these scripts to analyze single-cell RNA-seq data. These scripts are welcome to be used and modified for broader studies. The repo here doesn't represent a final product but instead an initial effort to build a Matlab community that has been underrepresented in Genomics field.
