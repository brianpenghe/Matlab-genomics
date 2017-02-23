function StrArray = Mat2StrArray(nummat)
%mat2strarray converts a matrix/vector nummat to a cell array of strings converted from the individual numbers
%Useful for generating multiple labels for plotting

StrArray=arrayfun(@num2str,nummat,'unif',0);

end
