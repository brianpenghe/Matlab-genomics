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
We will use data from the [Mouse Cell Atlas paper](https://www.cell.com/cell/abstract/S0092-8674(18)30116-8) as an example. Data can be downloaded [here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM2906444).
