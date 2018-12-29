# Matlab-genomics
Matlab-genomics is a collection of Matlab scripts to perform genomics analysis especially single-cell analysis.
## Introduction
Single-cell analysis has been dominated by packages on open-source platforms such as R and python. However, Matlab has its own advantages and consistency. It has also been a first choice among many researchers originally in Physics and Neuroscience fields who are seeking to dive into the modern Bioinformatics realm.
Therefore, I've assembled a set of handy scripts, some of which are borrowed from other repositories from GitHub and MathWork Fileexhange, if not created on my own, to accelerate Matlab fans' adaption to the Bioinformatics field.

## Installing
Download the whole folder, and then point Matlab to this folder as one of customer scripts. This is the code for Mac Users:

```
addpath(genpath('/Users/path_to_your_downloaded_and_extracted_codes')); 
```
*PC and Linux users need to pay attention to the path especially forward slash versus backward slash*

## Getting Started
We will use [Seurat package](https://satijalab.org/seurat/pbmc3k_tutorial.html)'s sample data [here](https://s3-us-west-2.amazonaws.com/10x.files/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz) with Matlab 2018a on Mac.

### Import Data
*These commands are for Unix terminal*

Extracting the file on Unix terminal (or double click on MatLab Finder)
```
tar -xzf pbmc3k_filtered_gene_bc_matrices.tar.gz
```
The data will be in a folder called "filtered_gene_bc_matrices/hg19". Go to that folder.
```
cd filtered_gene_bc_matrices/hg19/
```
*Below are commands for Matlab. Please make sure your current directory is correct (see picture below)*
![screen shot 2018-12-27 at 11 00 24 am](https://user-images.githubusercontent.com/4110443/50491358-bff21a00-09c6-11e9-8582-9b3dab309583.png)

Then import matrixmarket data to [DataMatrix](https://www.mathworks.com/help/bioinfo/ug/representing-expression-data-values-in-datamatrix-objects.html), a type similar to [CellDataSet](https://rdrr.io/bioc/monocle/man/CellDataSet.html) used by [Monocle](https://rdrr.io/bioc/monocle/) and [SeuratObject](https://rdrr.io/github/satijalab/seurat/man/CreateSeuratObject.html) in [Seurat](https://rdrr.io/github/satijalab/seurat/), on R platform.
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

![untitled](https://user-images.githubusercontent.com/4110443/48728535-0bf0b880-ebea-11e8-8f87-d1ea53cde1cc.jpg)

Filter out low-quality cells (less than 500 genes detected) and low-quality genes (detected in less than 0.5% cells)
```
PMBC_perc_filtered=PMBC_perc(sum((PMBC_perc>0),2)>sum(sum(test)>500,2)/200,sum(test)>500);
```
Calculate high-dispersion genes
```
Dispersion=var(PMBC_perc_filtered,0,2)./mean(PMBC_perc_filtered,2);
[P I]=sort(Dispersion,'descend');
```


## Discussions
### Parameter optimizations
This tutorial tries to present an overview of what we can do with a subset of the scripts here. It uses arbitrary parameters, leaving space for users to play around with their own sets of parameters based on their own trade-offs. Please feel free to change parameters, including gene detection threshold, cell rarity threshold, clustering algorithms, whether to use z-score to do t-SNE, k-means clustering or hierarchical, remove irrelevant PCs first or cluster first, which principal components to use, t-SNE perplexity etc. Additional discussions are welcome. Maximal coding flexibility is in the hands of users.

### Data filtering and batch effect control
The author is strongly against the idea of a magic blackbox that beautifies the data. Existing methods usually "regress out" or "eliminate" so-called "batch-effects" instead of understanding what exactly they are. So in this tutorial the author does not intentionally remove certain groups of genes or those that dance with them because they may have biological meanings to users (stress, cell-cycle phases, duplication etc.).

### Other scripts not mentioned here
Due to the limit of time and space. Many other useful scripts are not mentioned in this tutorial. Users are welcome to explore them or raise issues about them.

### Conclusions
This tutorial demonstrates the ease with these scripts to analyze single-cell RNA-seq data. These scripts are welcome to be used and modified for broader studies. The repo here doesn't represent a final product but instead an initial effort to build a Matlab community that has been underrepresented in Genomics field.
