function Index = strcontain(str,strarray)
%Similar to strmatch, this also prints out the indices.
%But strcontain only requires the str to be contained as substrings, not necessarily as prefix

Index=find(cellfun(@isempty,strfind(strarray,str)));
end
