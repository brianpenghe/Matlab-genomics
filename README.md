# Matlab-genomics
Matlab-genomics is a collection of Matlab scripts to perform genomics analysis especially single-cell analysis.

## Citation
These scripts were developed for [He and Williams et al. 2020 Nature](https://www.nature.com/articles/s41586-020-2536-x) 

The codes and resources related to the paper are [here](https://github.com/brianpenghe/Matlab-genomics/tree/master/He_2020_ENCODE3_RNA).

![image](https://user-images.githubusercontent.com/4110443/90067837-9b57cc80-dce7-11ea-9d31-8f5e49d07964.png)


## Introduction
Single-cell analysis has been dominated by packages on open-source platforms such as R and python. However, Matlab has its own advantages and consistency. It saves users efforts trying to figure out package inter-compatibility and dependency. It has also been a first choice among many researchers originally in Physics and Neuroscience fields who are seeking to dive into the modern Bioinformatics realm.
Therefore, I've assembled a set of handy scripts, some of which are borrowed from other repositories from GitHub and MathWork Fileexhange, if not created on my own, to accelerate Matlab fans' adaption to the Bioinformatics field.

## Installing
Download the whole folder, and then point MATLAB to this folder as one of customer scripts. This is the code for Mac Users:

```
addpath(genpath('/Users/path_to_your_downloaded_and_extracted_codes')); 
```
*PC and Linux users need to pay attention to the path especially forward slash versus backward slash*

## DeepTree Algorithm MATLAB tutorial
An example tutorial using DeepTree algorithm for single-cell analysis can be found [here](https://github.com/brianpenghe/Matlab-genomics/blob/master/DeepTree_Tutorial.md)

### Other scripts
#### Dimension reduction

`PCAPlot` performs PCA of a matrix and plots multiple useful plots.

`CCAPlot` conduct Canonical correlation analysis of a datamatrix (usually Principal Component scores) and a metadata matrix (usually boolean and quantitative variables) and generate plots.

`PCACCAPlot` is similar to `CCAPlot` but performs a PCA for the datamatrix (which is usually a sample-by-gene matrix).

`tsnePlot_old` reduces the dimension of columns before Matlab 2018a

#### Correlations
`FilterTrend` looks for genes highly correlated with a specified trend among a matrix in a rudimentary way. For example, for a matrix of 6 RNA-seq samples (Early Rep1, Early Rep2, Mid Rep1, Mid Rep2, Late Rep1, Late Rep2), setting *Trend* to [1 1 2 2 3 3] looks for genes that increase strictly linearly according to the sample state.

`corrplot_dot` is a third-party script modified by me to plot pairwise correlation values with scatterplot dots.

`gplotmatrix` dedicated for `corrplot`

`gscatterTable` plots a scatter plot with colors indicating classvar identities

#### Gene ontology
`GOTree` plots a tree of GO terms specified. `GOTreeColor` is the colored version.

#### Data QC and plotting
`Gene10XCount` plots the stacked bars of (fractions of) gene counts (usually a single-cell end-tagging UMI count matrix) at different abundance cutoffs. `GeneCountSorted` is a version that sorts bars. `GeneFPKM` is the equivalent version with cutoffs designed for SMART-seq (single-cell and bulk).

`MetaCdfplot` plots multiple cdf curves on the same figure.

`donut` is a third-party script that plots a donut plot, similar to a pie chart.

`subplot1` is a third-party script that plots multiple panels.

`venn` is a third-party script to make Venn diagrams.

`violin` is a third-party script to make violin plots.

#### Manipulating strings

`ValidizeNames` sightly modifies a cell array so that it can be used for directly naming variables.

`caseconvert` is a third-party script to convert cases.

`strcontain` prints out the indices of elements that contains a substring.
`strnotcontain` does the opposite.

#### Manipulating matrices and arrays (linear algebra)
`GetOrder` compares two arrays with different orders and figures out how it was transformed from A to B. This is particularly useful when different metadata categories were stored in separate variables. The return of this function is a index array that can be used to reorder other companion arrays from the old order to the new order.

`MatrixHighRanker` takes a table of multiple columns of values writes the high-value (above cutoff) items into a text file named "outfile". 

`MatrixTopRanker` takes a table of multiple columns of values writes the top rankers into a text file named "outfile".

`MetaIntersect` intersects the lists(columns) of string items stored in tableA and tableB in a pairwise fashion.

`MetaHygecdf` makes use of the output of `MetaIntersect` to calculate hypergeometric enrichment cdf between columns of tableA and tableB.

`OneDim2TwoDim` calculates the sum of Column C of each type of combinations of the elements in the first two columns (A & B) of a table.

`Outersect` outputs elements in A that are not in B.

`TableHygecdf` makes use of the intersect matrix (contingency table) to calculate hypergeometric enrichment cdf.

`crosstab2` is a modified version of crosstab but with better output format.

`tablecat` concatenates two tables (columns of items) of string items stored in tableA and tableB

#### Cluster and heatmap
`HeatMap2` plots a heatmap.

`IntersectChecker` compares multiple lists and summaries the intersection counts in a heatmap.

`Mat2Colormap` generates a heatmap color scheme.

`redblue` is a third-party script that generates a red-to-blue color scheme for color-blinded people.

`rgb2map` is a third-party script that converts RGB colors to indexed colormap colors.

`scatplot` is a third-party script to make scatter plots.

`distinguishable_colors` pick colors that are maximally perceptually distinct.

`PlotSubsetFPKM` generates a heatmap of a subset of genes from a gene-by-sample matrix.

`subsetFPKMDimensionReduction` wraps up `PlotSubsetFPKM`, `PCAPlot` and `tsnePlot` together.

`SaveClusterColumnLabels` write the ColumnLabels of a 1x1 clustergram into a file named as the clustergram.
`SaveClusterRowLabels` write the RowLabels of a 1x1 clustergram into a file named as the clustergram.

#### Import/Export and file/variable format conversion
![image](https://user-images.githubusercontent.com/4110443/184497593-3e2f53f1-454b-4c41-9c35-252da2fb3959.png)

`ImportBody` and `ImportBody2` read data in files and store them as variables. These primitive scripts are not recommended.

`Mat2StrArray` converts a matrix/vector nummat to a cell array of strings.

`Table2DataMatrix` converts a table into a datamatrix.

`TableStr2Double` converts a column of a table to the Double type.

`mminfo` is a third-party that reads the contents of the Matrix Market file 'filename' and extracts size and storage information.

`mmread` is a third-party script that reads Matrix Market file stores it into a matrix.

`mmwrite` is a third-party script that writes a matrix into a Matrix Market file.

`msm_to_mm` is a third-party script that writes a MATLAB Sparse Matrix to a Matrix Market file.

`read10XCount` imports 10X single-cell RNA-seq UMI counts in Matrix Market formats and converts it into a DataMatrix format.

`write10XCount` saves DataMatrix-format 10X single-cell RNA-seq UMI counts as MatrixMarket formats.

#### Networks
`PlotBipar` takes a matrix of connection values between Group A (row names) and Group B (column names) and plots a bipartite graph.

`PlotNetwork` plots a network graph based on the square adjacency matrix.

`SaveCell` write a nX1 cell array into a file named filename.


### Conclusions
This repo demonstrates the possibility with these scripts to analyze genomics data including single-cell RNA-seq data. MATLAB is not open sourced. But it also doesn't have as much the pain as installing open-source python or R packages which have complicated compatibility issues. The repo here doesn't represent a final product but instead an initial effort to build a MATLAB community that has been underrepresented in the genomics field.
