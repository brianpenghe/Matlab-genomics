# This is a summary of Matlab codes used for bulk RNA-seq analysis in [He and Williams et al. 2020 Nature](https://www.nature.com/articles/s41586-020-2536-x) 

## Load MATLAB scripts
*For Windows*
```
addpath(genpath('D:\Dropbox\Matlab_codes'));
```
*For Mac*
```
addpath(genpath('/Users/Dropbox/Matlab_codes'))
```

## Import RNAseq data
```
[Countname, Countvalue, Counthead]=ImportBody('RSEMcounttime.gene','header.gene',2,156,2);
[FPKMname, FPKMvalue, FPKMhead]=ImportBody('RSEMFPKMtime.gene','header.gene',2,156,2);
%the basic commands are stored in Script_BulkRNASeq.m
```

#### Remove spike genes and ribosomal RNAs
```
Bname=Countname(26249:69594);
FPKMB=FPKMvalue(26249:69594,:);
CountvalueB=Countvalue(26249:69594,:);
```
## Filter out genes with fewer than 10 read counts in all samples
```
Cname=Bname(max(CountvalueB')'>10);
FPKMD=FPKMB((max(CountvalueB'))'>10, :);
```

## Separate dynamic and ubiquitous genes based on the 10-fold cut
```
FPKMFlat=FPKMD(max(FPKMD'+0.1)./min(FPKMD'+0.1)<10,:);
FPKMDyn=FPKMD(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10,:);
Flatgenes=Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)<10);
Dyngenes=Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10);
```

## Set the orders of the samples for heatmap visulization
```
Reorder = [155 156 145 146 93 94 95 96 97 98 99 100 101 102 103 104 105 106 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 131 132 3 4 1 2 73 74 75 76 77 78 79 80 107 108 109 110 111 112 113 114 147 148 149 150 151 152 153 154 65 66 67 68 69 70 71 72 81 82 83 84 85 86 87 88 89 90 91 92 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 133 134 135 136 137 138 139 140 141 142 143 144
]; % This is for all the samples in Fig. 1c

MBReorder=[155 156 145 146 93 94 95 96 97 98 99 100 101 102 103 104 105 106 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 131 132 3 4 1 2 73 74 75 76 77 78 79 80 107 108 109 110 111 112 113 114 147 148 149 150 151 152 153 154 65 66 67 68 69 70 71 72 81 82 83 84 85 86 87 88 89 90 91 92 5 6 7 8 9 10 11 12 13 14 15 16 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130];
% This is for reduced number of samples in Extended Data Fig. 6d 
```

## Plot the clustergrams
```
Flat=clustergram(log2(FPKMFlat(:,Reorder)+1),'OptimalLeafOrder',true,'Cluster',1,'DisplayRange',7.5,'Symmetric','false','ColumnPDist','correlation','Colormap',colormap(jet),'ColumnLabels',FPKMhead(Reorder),'RowLabels',Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)<10))
% This is for Extended Data Fig. 5a
Dyn=clustergram(log2(FPKMDyn(:,Reorder)+0.1),'Cluster',1,'DisplayRange',7.5,'Symmetric','false','ColumnPDist','correlation','RowPDist','correlation','Colormap',colormap(jet),'ColumnLabels',FPKMhead(Reorder),'RowLabels',Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10))
set(Dyn,'Standardize',2,'DisplayRange',2.5,'Symmetric',true)
% This is for Fig. 1c
TwoWayCluster=clustergram(log2(FPKMDyn(:,Reorder)+0.1),'DisplayRange',7.5,'Symmetric','false','ColumnPDist','correlation','RowPDist','correlation','Colormap',colormap(jet),'ColumnLabels',FPKMhead(Reorder),'RowLabels',Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10))
set(TwoWayCluster,'Standardize',2,'Symmetric',true,'DisplayRange',2.5)
% This is for Extended Data Fig. 6b
MBOneWayCluster=clustergram(log2(FPKMDyn(:,MBReorder)+0.1),'Cluster',1,'DisplayRange',7.5,'Symmetric','false','ColumnPDist','correlation','RowPDist','correlation','Colormap',colormap(jet),'ColumnLabels',FPKMhead(MBReorder),'RowLabels',Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10))
set(MBOneWayCluster,'Standardize',2,'Symmetric',true,'DisplayRange',2.5)
% This is for Extended Data Fig. 6d
```
*Note that different MATLAB versions may affect the random seeds. The results may vary a bit.*

## Parse the clustergrams
I then manually annotated the major clusters (at least 30 genes per cluster), and dropped down the cluster node numbers (click and hold the node to see the node number).
The clusters:
```
Group15555 =clusterGroup(Dyn,15555,'row')
Group15564 =clusterGroup(Dyn,15564,'row')
Group15716 =clusterGroup(Dyn,15716,'row')
Group15595 =clusterGroup(Dyn,15595,'row')
Group15692 =clusterGroup(Dyn,15692,'row')
Group15667 =clusterGroup(Dyn,15667,'row')
Group15468 =clusterGroup(Dyn,15468,'row')
Group15357 =clusterGroup(Dyn,15357,'row')
Group15402 =clusterGroup(Dyn,15402,'row')
Group15460 =clusterGroup(Dyn,15460,'row')
Group15637 =clusterGroup(Dyn,15637,'row')
Group15597 =clusterGroup(Dyn,15597,'row')
Group15544 =clusterGroup(Dyn,15544,'row')
Group15262 =clusterGroup(Dyn,15262,'row')
Group15341 =clusterGroup(Dyn,15341,'row')
Group15301 =clusterGroup(Dyn,15301,'row')
Group15704 =clusterGroup(Dyn,15704,'row')
Group15314 =clusterGroup(Dyn,15314,'row')
Group15560 =clusterGroup(Dyn,15560,'row')
Group15627 =clusterGroup(Dyn,15627,'row')
Group15628 =clusterGroup(Dyn,15628,'row')
Group15714 =clusterGroup(Dyn,15714,'row')
Group15662 =clusterGroup(Dyn,15662,'row')
Group15551 =clusterGroup(Dyn,15551,'row')
Group15603 =clusterGroup(Dyn,15603,'row')
Group14769 =clusterGroup(Dyn,14769,'row')
Group15251 =clusterGroup(Dyn,15251,'row')
Group15142 =clusterGroup(Dyn,15142,'row')
Group15090 =clusterGroup(Dyn,15090,'row')
Group15103 =clusterGroup(Dyn,15103,'row')
Group14762 =clusterGroup(Dyn,14762,'row')
Group14574 =clusterGroup(Dyn,14574,'row')
Group14104 =clusterGroup(Dyn,14104,'row')
Group14225 =clusterGroup(Dyn,14225,'row')
```
## Add group labels
```
colors3=distinguishable_colors(34);
Groups=[15555	15564	15716	15595	15692	15667	15468	15357	15402	15460	15637	15597	15544	15262	15341	15301	15704	15314	15560	15627	15628	15714	15662	15551	15603	14769	15251	15142	15090	15103	14762	14574	14104	14225];
NewClusterID={'    1'
'2'
'    3'
'4'
'    5'
'6'
'    7'
'8'
'    9'
'10'
'    11'
'12'
'    13'
'14'
'    15'
'16'
'    17'
'18'
'    19'
'20'
'    21'
'22'
'    23'
'24'
'    25'
'26'
'    27'
'28'
'    29'
'30'
'    31'
'32'
'    33'
'34'
};
set(A,'RowGroupMarker',struct('GroupNumber',num2cell(Groups,1),'Annotation',NewClusterID','Color',mat2cell(colors3,repmat([1],1,34))'));
```

## Pick colors and shapes for bulk samples

```
MarkerColor=repmat({'o'},156,1); % In fact, it contains the shapes not colors
MarkerColor(1:2)={'o'};
MarkerColor(3:4)={'s'};
MarkerColor(131:132)={'d'};
MarkerColor(145:146)={'p'};
MarkerColor(155:156)={'h'};
```

Then I picked colors from [here](http://www.rapidtables.com/web/color/RGB_Color.htm)
```
BarbaraColors=[
0    0    0    ;
0    0    0    ;
0    0    0    ;
0    0    0    ;
255    153    204    ;
255    153    204    ;
255    102    178    ;
255    102    178    ;
255    0    127    ;
255    0    127    ;
204    0    102    ;
204    0    102    ;
153    0    76    ;
153    0    76    ;
102    0    51    ;
102    0    51    ;
229    204    255    ;
229    204    255    ;
204    153    255    ;
204    153    255    ;
178    102    255    ;
178    102    255    ;
153    51    255    ;
153    51    255    ;
127    0    255    ;
127    0    255    ;
102    0    204    ;
102    0    204    ;
76    0    153    ;
76    0    153    ;
51    0    102    ;
51    0    102    ;
255    204    204    ;
255    204    204    ;
255    153    153    ;
255    153    153    ;
255    102    102    ;
255    102    102    ;
255    51    51    ;
255    51    51    ;
255    0    0    ;
255    0    0    ;
204    0    0    ;
204    0    0    ;
153    0    0    ;
153    0    0    ;
102    0    0    ;
102    0    0    ;
204    229    255    ;
204    229    255    ;
153    204    255    ;
153    204    255    ;
102    178    255    ;
102    178    255    ;
51    153    255    ;
51    153    255    ;
0    128    255    ;
0    128    255    ;
0    102    204    ;
0    102    204    ;
0    76    153    ;
0    76    153    ;
0    51    102    ;
0    51    102    ;
153    255    204    ;
153    255    204    ;
51    255    153    ;
51    255    153    ;
0    204    102    ;
0    204    102    ;
0    153    76    ;
0    153    76    ;
255    204    153    ;
255    204    153    ;
255    153    51    ;
255    153    51    ;
204    102    0    ;
204    102    0    ;
153    76    0    ;
153    76    0    ;
255    204    255    ;
255    204    255    ;
255    153    255    ;
255    153    255    ;
255    102    255    ;
255    102    255    ;
255    0    255    ;
255    0    255    ;
204    0    204    ;
204    0    204    ;
153    0    153    ;
153    0    153    ;
224    224    224    ;
224    224    224    ;
192    192    192    ;
192    192    192    ;
160    160    160    ;
160    160    160    ;
128    128    128    ;
128    128    128    ;
96    96    96    ;
96    96    96    ;
80    80    80    ;
80    80    80    ;
64    64    64    ;
64    64    64    ;
255    255    153    ;
255    255    153    ;
255    255    51    ;
255    255    51    ;
204    204    0    ;
204    204    0    ;
153    153    0    ;
153    153    0    ;
204    204    255    ;
204    204    255    ;
153    153    255    ;
153    153    255    ;
102    102    255    ;
102    102    255    ;
51    51    255    ;
51    51    255    ;
0    0    255    ;
0    0    255    ;
0    0    204    ;
0    0    204    ;
0    0    153    ;
0    0    153    ;
0    0    102    ;
0    0    102    ;
0    0    0    ;
0    0    0    ;
204    255    255    ;
204    255    255    ;
153    255    255    ;
153    255    255    ;
51    255    255    ;
51    255    255    ;
0    204    255    ;
0    204    255    ;
0    153    153    ;
0    153    153    ;
0    102    102    ;
0    102    102    ;
0    0    0    ;
0    0    0    ;
204    255    153    ;
204    255    153    ;
153    255    51    ;
153    255    51    ;
102    204    0    ;
102    204    0    ;
76    153    0    ;
76    153    0    ;
0    0    0    ;
0    0    0    ;
];
MBBarbaraColors=BarbaraColors(MBReorder,:);
MBMarkerColor=MarkerColor(MBReorder,:);

```

## Plot PCA plots
Start with a simple color scheme first only separating organs
```
d=[0 0 1 1 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 8 8 8 8 8 8 8 8 8 8 8 8 9 9 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 10 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 12 12 13 13 13 13 13 13 13 13 13 13 13 13 14 14 15 15 15 15 15 15 15 15 16 16];
```

#### Then calculate the PCA scores and loadings
```
[COEFF,SCORE,Latent] = PCAPlot(log2(FPKMD(:,Reorder)+0.1),FPKMhead(Reorder),Cname,d(Reorder));
[mbCOEFF,mbSCORE,mbLatent] = PCAPlot(log2(FPKMD(:,MBReorder)+0.1),FPKMhead(MBReorder),Cname,d(MBReorder));
```
#### Make plots using the updated color scheme
```
hold on

for i=1:156
scatter3(SCORE(i,1),SCORE(i,2),SCORE(i,3),50,BarbaraColors(i,:)/255,'filled', MarkerColor{i},'MarkerEdgeColor','black');
end
ylabel(strcat('PC2(',strcat(num2str(round(latent(2)/sum(latent)*100)),'%'),')'))
zlabel(strcat('PC3(',strcat(num2str(round(latent(3)/sum(latent)*100)),'%'),')'))
xlabel(strcat('PC1(',strcat(num2str(round(latent(1)/sum(latent)*100)),'%'),')'))
```
#### Auto rotate and save as a video
```
OptionZ.FrameRate=60;OptionZ.Duration=11;OptionZ.Periodic=true;
CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10],'testvid',OptionZ)
```

#### Plot the companion heat map of the PC loadings in Fig. 1c
```
GeneIndex=[];
DynName=Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10);
DynRow=get(Dyn,'RowLabels');
COEFFDyn=COEFF(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10,:);
GeneIndex=GetOrder(DynRow,DynName);
PCloading=HeatMap(COEFFDyn(GeneIndex(:,1),1:20),'Displayrange',2.5,'Standardize',2,'colormap',colormap(jet))
```



