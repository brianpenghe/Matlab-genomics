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
The data will be in a folder called "filtered_gene_bc_matrices/hg19"

Add ".txt" to the end of the .mtx and .tsv files to make [readtable()](https://www.mathworks.com/help/matlab/ref/readtable.html) work

Then import matrixmarket data:
```
tempMatrixMarket=readtable('filtered_gene_bc_matrices/hg19/matrix.mtx.txt');
```
And convert matrixmarket data to Table and then to [DataMatrix](https://www.mathworks.com/help/bioinfo/ug/representing-expression-data-values-in-datamatrix-objects.html), a type similar to [CellDataSet](https://rdrr.io/bioc/monocle/man/CellDataSet.html) in [Monocle](https://rdrr.io/bioc/monocle/) and [SeuratObject](https://rdrr.io/github/satijalab/seurat/man/CreateSeuratObject.html) in [Seurat](https://rdrr.io/github/satijalab/seurat/), on R platform.
```
PMBC_data=spconvert(table2array(tempMatrixMarket(2:end,:))); %convert sparse matrix to matrix
PMBC_cells=readtable('filtered_gene_bc_matrices/hg19/barcodes.tsv.txt','ReadVariableNames',false,'Delimiter','\t'); %import cell names
PMBC_genes=readtable('filtered_gene_bc_matrices/hg19/genes.tsv.txt','ReadVariableNames',false,'Delimiter','\t'); %import gene names
temp=table2array(PMBC_genes); %convert gene name table to cell array
tempgenes=array2table(strcat(temp(:,1),'_',temp(:,2))); %concatenate gene ID and gene name so that no duplicates are possible
temptable=[tempgenes(1:height(array2table(PMBC_data)),:) array2table(PMBC_data)]; %add gene names to the table
temptable.Properties.VariableNames=[{'Var1'} ValidizeNames(table2array(PMBC_cells)')]; %add cell names to the table properties
PMBCdm=Table2DataMatrix(temptable); %convert table to DataMatrix format
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

### Clustering and visualization

PMBCClg=clustergram(PMBC_perc_filtered(I(1:500),:),'Standardize',0,'DisplayRange',2.5,'Colormap',colormap(jet),'RowPDist','correlation','ColumnPDist','spearman','Symmetric',true,'linkage','complete', 'OptimalLeafOrder',false)

<img width="661" alt="screen shot 2018-09-03 at 2 17 16 pm" src="https://user-images.githubusercontent.com/4110443/45001694-25d41500-af84-11e8-9632-aeca4e5493e9.png">

Now you get a clustergram which can be annotated interactively following [Matlab Clustergram Manual](https://www.mathworks.com/help/bioinfo/ref/clustergram.html) to make it look like the following

<img width="711" alt="screen shot 2018-09-03 at 2 47 38 pm" src="https://user-images.githubusercontent.com/4110443/45002131-5c139380-af88-11e8-85d5-7ef82b20aff5.png">

#### Check expression of specific gene lists

If you want to see expression levels of a set of genes, you can put the names of them in text.dat
![screen shot 2018-09-28 at 4 29 08 pm](https://user-images.githubusercontent.com/4110443/46237810-c7f4dc00-c33b-11e8-9ace-9cd51846d6bf.png)

And then import this list to an array
```
GenesOfInterest=table2array(readtable('test.dat','ReadVariableNames',false,'Delimiter','\t'))
```
Then plot into a HeatMap matching the cell order of your clustergram
```
HeatMap(PMBC_perc(GenesOfInterest,get(PMBCClg,'ColumnLabels')),'Standardize',2,'Colormap',colormap(jet),'Symmetric',true,'DisplayRange',2.5)
```
<img width="675" alt="screen shot 2018-09-28 at 4 58 52 pm" src="https://user-images.githubusercontent.com/4110443/46238332-e78e0380-c33f-11e8-9811-6623f8a46035.png">

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
ClusterID=[repmat([1],1,451) repmat([0],1,44) repmat([2],1,137) repmat([3],1,23) repmat([0],1,664) repmat([4],1,119) repmat([0],1,20) repmat([5],1,313) repmat([0],1,195) repmat([6],1,54) repmat([7],1,202) repmat([8],1,244) repmat([0],1,15)];
```
Now calculate t-SNE coordinates and plot
```
mappedX=tsne(double(PMBC_perc_filtered(I(1:500),get(PMBCClg,'ColumnLabels')))','Algorithm','barneshut','NumPCAComponents',30,'Distance','spearman','Perplexity',30);
scatter(mappedX(:,1),mappedX(:,2),50,[0.8 0.8 0.8],'.')
``` 
*You should right click mappedX in Workspace window to save it to a file. So that next time you can use mappedX=importdata(); to import it*

Now paint the t-SNE plot with cluster colors.
```
scatter(mappedX(ClusterID==1),1),mappedX(ClusterID==1,2),10,[0 0 1],'.')
scatter(mappedX(ClusterID==1,1),mappedX(ClusterID==1,2),10,[0 0 1],'.')
scatter(mappedX(ClusterID==1,1),mappedX(ClusterID==1,2),50,[0 0 1],'.')
scatter(mappedX(ClusterID==1,1),mappedX(ClusterID==1,2),50,[0 0.45 0.74],'.')
scatter(mappedX(ClusterID==2,1),mappedX(ClusterID==2,2),50,[0.85 0.33 0.1],'.')
scatter(mappedX(ClusterID==3,1),mappedX(ClusterID==3,2),50,[0.93 0.69 0.13],'.')
scatter(mappedX(ClusterID==4,1),mappedX(ClusterID==4,2),50,[0.49 0.18 0.56],'.')
scatter(mappedX(ClusterID==5,1),mappedX(ClusterID==5,2),50,[0.47 0.67 0.19],'.')
scatter(mappedX(ClusterID==6,1),mappedX(ClusterID==6,2),50,[0.3 0.75 0.93],'.')
scatter(mappedX(ClusterID==7,1),mappedX(ClusterID==7,2),50,[0.64 0.08 0.18],'.')
scatter(mappedX(ClusterID==8,1),mappedX(ClusterID==8,2),50,[1 0 0],'.')
```
![untitled](https://user-images.githubusercontent.com/4110443/46250886-1ae09900-c3f9-11e8-8fd1-f76430d665b1.jpg)

#### Check expression of a specific gene
```
scatter(mappedX(:,1),mappedX(:,2),50,PMBC_perc('ENSG00000105369_CD79A',get(PMBCClg,'ColumnLabels')),'.')
colormap(hot)
```
![untitled](https://user-images.githubusercontent.com/4110443/46250929-824b1880-c3fa-11e8-85ef-b31f576d8dd1.jpg)

##Discussions
###Parameter optimizations
This tutorial tries to present an overview of what we can do with a subset of the scripts here. It uses arbitrary parameters, leaving space for users to play around with their own sets of parameters based on their own trade-offs. Please feel free to change parameters, including gene detection threshold, cell rarity threshold, clustering algorithms, which principal components to use, t-SNE perplexity etc. Additional discussions are welcome. Maximal coding flexibility is in the hands of users.

###Data filtering and batch effect control
The author is strongly against the idea of a magic blackbox that beautifies the data. Existing methods usually "regress out" or "eliminate" so-called "batch-effects" instead of understanding what exactly they are. So in this tutorial the author does not intentionally remove certain groups of genes or those that dance with them because they may have biological meanings to users (stress, cell-cycle phases, duplication etc.).

###Other scripts not mentioned here
Due to the limit of time and space. Many other useful scripts are not mentioned in this tutorial. Users are welcome to explore them or raise issues about them.

###Conclusions
This tutorial demonstrates the ease with these scripts to analyze single-cell RNA-seq data. These scripts are welcome to be used and modified for broader studies. The repo here doesn't represent a final product but instead an initial effort to build a Matlab community that has been underrepresented in Genomics field.
