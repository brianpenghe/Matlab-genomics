# These are the codes used to Extended Data Fig. 10d.

## Calculate 3' UTR lengths
### Get 3' UTR coordinates
> #These are Linux shell script commands
> 
> python [~/programs/CDS-UTR-from-gtf-V2.py](https://github.com/brianpenghe/gtfgff-scripts/blob/master/CDS-UTR-from-gtf-V2.py) gencode.vM4-tRNAs-ERCC.gff gencode.vM4-tRNAs-ERCC.CDS-UTR
> 
> grep -w UTR3 gencode.vM4-tRNAs-ERCC.CDS-UTR > gencode.vM4-tRNAs-ERCC.UTR3

### Get 3' UTR lengths
```
# These are Linux shell script commands
awk '{array[$6"\t"$8]=array[$6"\t"$8]+$3-$2} END { for (i in array) {print i"\t" array[i]}}' gencode.vM4-tRNAs-ERCC.UTR3 > gencode.vM4-tRNAs-ERCC.UTR3.length
awk '{array[$1]+=$3;array2[$1]+=1} END { for (i in array) {print i"\t" array[i]/array2[i]}}' gencode.vM4-tRNAs-ERCC.UTR3.length > gencode.vM4-tRNAs-ERCC.UTR3.length.gene
```

## Plot the correlation plot
### Import files to MATLAB

```
%These are MATLAB codes
GRO=readtable('mm10-M4-male_anno_rsem.genes.results.txt','Delimiter','\t');
High=readtable('NewFlatHigh.txt','ReadVariableName',false);
Med=readtable('NewFlatMed.txt','ReadVariableName',false);
Low=readtable('NewFlatLow.txt','ReadVariableName',false);
```
Please make sure you have run the scripts in Notebook_1 to import bulk PolyA RNA-seq data

```
[C,ih,ib]=intersect(Cname,table2cell(High));
[C,im,ib]=intersect(Cname,table2cell(Med));
[C,il,ib]=intersect(Cname,table2cell(Low));
FPKMDlogmean=mean(log2(FPKMD+0.1)')';
UTR3=readtable('gencode.vM4-tRNAs-ERCC.UTR3.length.gene.txt','Delimiter','\t','readVariableName',false);
UTR3.Properties.VariableNames{'Var1'} = 'gene_id';
test=outerjoin(GRO,UTR3);
GROFPKMUTRB=table2array(test(26249:69594,[3:9 11]));
GROFPKMUTRD=GROFPKMUTRB((max(CountvalueB'))'>10, :);
```
### Plot the meta correlation figure
```
figure;[R P]=corrplot_dot(log2([FPKMD([ih;im;il],[131 107]) GROFPKMUTRD([ih;im;il],:)]+0.1),'varNames',{'muscle p0','liver e14.5','C2C12 GRO0seq','MEF1','MEF2','ES1','ES2','ES3','ES Bruseq','UTR3'});
```
