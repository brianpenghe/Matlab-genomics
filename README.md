# Matlab-genomics
Matlab-genomics is a collection of Matlab scripts to perform genomics analysis especially single-cell analysis.

## Citation
These scripts were developed for [He and Williams et al. 2020 Nature](https://www.nature.com/articles/s41586-020-2536-x) 

The codes and resources related to gthe paper are [here](https://github.com/brianpenghe/Matlab-genomics/tree/master/He_2020_ENCODE3_RNA).

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

### Other scripts not mentioned here
Due to the limit of time and space. Many other useful scripts are not explained in detail here. Users are welcome to explore them or raise issues about them.

### Conclusions
This repo demonstrates the possibility with these scripts to analyze genomics data including single-cell RNA-seq data. These scripts are welcome to be used and modified for broader studies. The repo here doesn't represent a final product but instead an initial effort to build a MATLAB community that has been underrepresented in the genomics field.
