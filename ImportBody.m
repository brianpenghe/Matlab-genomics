function [name,value,head] = ImportBody(filename,headername,stringNo,floatNo,RowLabelCol)
%ImportBody is a function to import a table of RowLabels with values and a matching file of headers 
%The input files shouldn't contain trailing linebreaks
%input should start with name columns and then value columns
%function [name,value,head] = ImportBody(filename,headername,stringNo,floatNo,RowLabelCol)

%Filename:
%Henry    506    238
%Diane    1322   124
%Sean     823    76

%Headername:
%CP    HP
file1=fopen(headername);
Spec1=repmat('%s ',1,floatNo);
MatHeader=textscan(file1,Spec1);
head={};
for i=1:floatNo
    head=[head MatHeader{i}{1}];
end;

file=fopen(filename);
Spec=[repmat('%s ',1,stringNo) repmat('%f ',1,floatNo)];
MatAll=textscan(file,Spec);
[m n]=size(MatAll);
MatValue=MatAll(stringNo+1:n);
value=cell2mat(MatValue);
name=MatAll{RowLabelCol};
fclose(file);

end

