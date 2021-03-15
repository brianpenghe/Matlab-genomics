addpath(genpath('/Users/Brian/Dropbox/scripts/Matlab_codes')); 
cd '/Users/Brian/Box Sync/Project_RNAseq/5thRun'
[Countname, Countvalue, Counthead]=ImportBody('RSEMcounttime.gene','header.gene',2,156,2);
[FPKMname1, FPKMvalue, FPKMhead]=ImportBody('RSEMFPKMtime.gene','header.gene',2,156,1);
Bname=strcat(FPKMname1(26249:69594),'_',Countname(26249:69594));
FPKMB=FPKMvalue(26249:69594,:);
CountvalueB=Countvalue(26249:69594,:);
Cname=Bname(max(CountvalueB')'>10);
FPKMD=FPKMB((max(CountvalueB'))'>10, :);
FPKMFlat=FPKMD(max(FPKMD'+0.1)./min(FPKMD'+0.1)<10,:);
FPKMDyn=FPKMD(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10,:);
Flatgenes=Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)<10);
Dyngenes=Cname(max(FPKMD'+0.1)./min(FPKMD'+0.1)>=10);
Reorder = [155 156 145 146 93 94 95 96 97 98 99 100 101 102 103 104 105 106 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 131 132 3 4 1 2 73 74 75 76 77 78 79 80 107 108 109 110 111 112 113 114 147 148 149 150 151 152 153 154 65 66 67 68 69 70 71 72 81 82 83 84 85 86 87 88 89 90 91 92 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 133 134 135 136 137 138 139 140 141 142 143 144
];