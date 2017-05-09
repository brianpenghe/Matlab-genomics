function NewCell = ValidizeNames(OldCell)
%ValidizeNames is a function to sightly modify a cell array so that it can be used for directly naming variables
%Useful for creating tables
%better than genvarname
%NewCell=ValidizeNames(OldCell)
SaveCell(OldCell,'temp');
NewCell0=readtable('temp.txt');
NewCell=NewCell0.Properties.VariableNames;

end
