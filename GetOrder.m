function Order = GetOrder(NewArr,OldArr)
%GetOrder gets the order array that transforms the old array to the new one
%Useful for plotting data onto the original matrix layout. Say, plot additional data of a defined gene set
%In matlab, an array is transformed in this way:
%OldArr([3 2 4 1]')=NewArr;
% A'     1     0 0 0 1   C
% B   '  1  .  0 1 0 0 =   B 
% C      1     1 0 0 0       D
% D      1     0 0 1 0         A
%
% Given OldArr={A;B;C;D}; NewArr=OldArr(Order)={C;B;D;A}; we get Order=GetOrder(NewArr,OldArr)
% Because ENSEMBL gene symbols in OldArr usually have duplicates, here we don't use matrix calculation
% since the OldArr would not be invertible
% Therefore, this script just uses a simply string match trick to iterate through the cell array
% For the duplicates, the first occurrence is assumed to be the only one for simplicity

Order=[];
[m n]=size(NewArr);
if m==1 && n>1
    disp('We transposed your array')
    NewArr0=NewArr';
    NewArr=NewArr0;
end;
for i=1:m
test=strmatch(NewArr(i),OldArr,'exact');
if isempty(test)
    Order(i,1)=0;
else
    Order(i,1)=test(1,1);
end
end
