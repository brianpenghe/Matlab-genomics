function Index = strnotcontain(str,strarray)
%opposite to strcontain
%Similar to strmatch, strcontain also prints out the indices.
%But strcontain only requires the str to be contained as substrings, not necessarily as prefix

Index=find(cellfun(@isempty,strfind(strarray,str)));
end
