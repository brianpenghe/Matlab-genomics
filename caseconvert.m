function[data]=caseconvert(data,casetype)

%CASECONVERT Case converter.
%
%  CASECONVERT(S,T) converts the case of string S to type T. S can be a
%  single string, or a cell/char array of strings. Type T also can be a
%  single string, or a cell/char array of strings with size(T)==size(S).
%  Where applicable, output generally resembles that obtained using the
%  'Change Case' feature within Microsoft Word 2003.
%
%  If T is a a cell/char array with size(T)==size(S), each value of T
%  applies to each respective value of S.
%   
%  EXAMPLES:
%
%    caseconvert('sample text','title')  returns 'Sample Text'
%    caseconvert('Sample Text','toggle') returns 'sAMPLE tEXT'
%
%    caseconvert({'new york' 'california'},'randomized')
%      returns {'neW yoRk' 'CAlIFORnIA'}
%
%    caseconvert({'This Is A Test.' 'Matlab'},{'sentence' 'upper'})
%      returns {'This is a test.' 'MATLAB'}
%
%  USABLE TYPES:
%
%    |-------------|------------------|------------------|
%    | TYPE        | SAMPLE INPUT     | SAMPLE OUTPUT    |
%    |-------------|------------------|------------------|
%    | upper       | upper Case       | UPPER CASE       |
%    | lower       | Lower Case       | lower case       |
%    | title       | title case       | Title Case       |
%    | sentence    | sentence case    | Sentence case    |
%    | toggle      | Toggle Case      | tOGGLE cASE      |
%    | randomized  | randomized case  | RaNDoMizEd cASe  |
%    |-------------|------------------|------------------|
%
%  REMARKS:
%
%    An initial test is recommended, especially when using non-standard or
%    non-English characters, or characters with numbers or punctuations.
%
%  VERSION DATE: 2005.06.10
%  MATLAB VERSION: 7.0.1.24704 (R14) Service Pack 1
%
%  See also LOWER, UPPER.

%{
REVISION HISTORY:
2005.06.10: Made a few minor changes as suggested by M-Lint.
2005.06.05: Vectorized two 'for' loops, and made minor comment updates.
2004.12.28: Added support for char and cell arrays.
2004.11.26: Changed to use 'switch' and 'case' instead of 'if'.
2004.11.16: Fixed bug so "Jane's" in 'title' case changes to "Jane's"
            instead of "Jane'S".
2004.11.15: Original version.

KEYWORDS:
case, case convert, case conversion, lower, upper, 
title case, proper case, sentence case, toggle case, randomized case, 
random case
%}

%**************************************************************************

if isempty(data) || isnumeric(data)
    return
elseif ischar(data)
    data=cellstr(data);
    data_type='char';
elseif iscell(data)
    data_type='cell';
end
casetype=cellstr(casetype);

for i=1:numel(data)
    data_i=caseconvert_do(cell2mat(data(i)),...
                          cell2mat(selectcur(casetype,i)));
    if ischar(data_i)
        data(i)=cellstr(data_i);
    end
end

if strcmp(data_type,'char')
    data=cell2mat(data);
end

%**************************************************************************

function[item]=selectcur(item,i)

if numel(item)==1
    return
else
    item=item(i);
end

%**************************************************************************

function[data_full]=caseconvert_do(data_full,casetype)

if isempty(data_full) || ~ischar(data_full)
    return
end

    %----------------------------------------------------------------------

data=data_full;
data_prefix=[];

for count=1:numel(data_full)
    
    if isstrprop(data(1),'alphanum')==1
        break
    else
        data_prefix=[data_prefix,data(1)];
        data(1)=[];
    end
    
end

    %----------------------------------------------------------------------

data_num=numel(data);

%**************************************************************************

switch casetype
    
    %----------------------------------------------------------------------

    case 'upper'
        
        data=upper(data);
        
    %----------------------------------------------------------------------

    case 'lower'
        
        data=lower(data);
        
    %----------------------------------------------------------------------

    case 'title'

        data(1)=upper(data(1));

        for count=2:data_num

            if isstrprop(data(count-1),'alphanum')==1
                data(count)=lower(data(count));
            else
                data(count)=upper(data(count)); 
            end

            if (count>=3 && count<=data_num-1 && ...
                data(count-2)~=' ' && data(count-1)=='''' && ...
                data(count+1)==' ') ...
                || (count>=3 && ...
                data(count-2)~=' ' && data(count-1)=='''')

                data(count)=lower(data(count));

            end

        end
        
    %----------------------------------------------------------------------

    case 'sentence'

        data(1)=upper(data(1));
        data(2:end)=lower(data(2:end));
        
    %----------------------------------------------------------------------

    case 'toggle'
        
        data_lower=find(isstrprop(data,'upper'));
        data_upper=find(isstrprop(data,'lower'));
        
        data(data_lower)=lower(data(data_lower));
        data(data_upper)=upper(data(data_upper));
    
    %----------------------------------------------------------------------
        
    case 'randomized'
        
        data_rand=rand(1,data_num);
        
        data_lower=find(data_rand<=.5);
        data_upper=find(data_rand>.5);
                
        data(data_lower)=lower(data(data_lower));
        data(data_upper)=upper(data(data_upper));

    %----------------------------------------------------------------------

end
data_full=[data_prefix,data];

%**************************************************************************