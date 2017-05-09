function NewCell = ValidizeNames(OldCell)
%ValidizeNames is a function to sightly modify a cell array so that it can be used for directly naming variables
%Useful for creating tables
%better than genvarname
%NewCell=ValidizeNames(OldCell)
[m n]=size(OldCell);
if m > 1 && n==1
    SaveCell(OldCell','temp')
    disp('We transposed your array')
else
    SaveCell(OldCell,'temp');
end
NewCell0=readtable('temp.txt');
NewCell=NewCell0.Properties.VariableNames;

end
