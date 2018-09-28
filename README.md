# Matlab-genomics
Matlab-genomics is a collection of Matlab scripts to perform genomics analysis especially single-cell analysis.
## Introduction
Single-cell analysis has been dominated by packages on open-source platforms such as R and python. However, Matlab has its own advantages and consistency. It has also been a first choice among many researchers originally in Physics and Neuroscience fields who are seeking to dive into the modern Bioinformatics realm.
Therefore, I've assembled a set of handy scripts, some of which are borrowed from other repositories from GitHub and MathWork Fileexhange, if not created on my own, to accelerate Matlab fans' adapting to the Bioinformatics field.

## Installing
Download the whole folder, and then point Matlab to this folder as customer folder of scripts. This is the code for Mac Users

```
addpath(genpath('/Users/Brian/path_to_your_downloaded_and_extracted_codes')); 
```
PC and Linux users need to pay attention to the path especially forward slash versus backward slash

## Getting Started
We will use [Seurat package](https://satijalab.org/seurat/pbmc3k_tutorial.html)'s sample data [here](https://s3-us-west-2.amazonaws.com/10x.files/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz) with Matlab 2018a on Mac.

### Import Data
Extracting the file
```
tar -xzf pbmc3k_filtered_gene_bc_matrices.tar.gz
```
The data will be in a folder called "filtered_gene_bc_matrices/hg19"

Add ".txt" to the end of the .mtx and .tsv files to make readtable() work

Then import matrixmarket data:
```
tempMatrixMarket=readtable('filtered_gene_bc_matrices/hg19/matrix.mtx.txt');
```
And convert matrixmarket data to Table and then to DataMatrix, a type similar to CellDataSet in Bioconductor
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

clustergram(PMBC_perc_filtered(I(1:500),:),'Standardize',0,'DisplayRange',2.5,'Colormap',colormap(jet),'RowPDist','correlation','ColumnPDist','spearman','Symmetric',true,'linkage','complete', 'OptimalLeafOrder',false)

<img width="661" alt="screen shot 2018-09-03 at 2 17 16 pm" src="https://user-images.githubusercontent.com/4110443/45001694-25d41500-af84-11e8-9632-aeca4e5493e9.png">

Now you get a clustergram which can be annotated interactively following [Matlab Clustergram Manual](https://www.mathworks.com/help/bioinfo/ref/clustergram.html) to make it look like this:
<img width="711" alt="screen shot 2018-09-03 at 2 47 38 pm" src="https://user-images.githubusercontent.com/4110443/45002131-5c139380-af88-11e8-85d5-7ef82b20aff5.png">

#### Check expression of specific gene lists

If you want to 
