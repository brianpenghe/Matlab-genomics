function varargout = corrplot(X,varargin)
%CORRPLOT Plot variable correlations
%
% Syntax:
%
%   corrplot(X)
%   corrplot(X,param,val,...)
%   [R,PValue] = corrplot(...)
%
% Description:
%
%   Creates a matrix of plots showing correlations among pairs of variables
%   in X. Histograms of the variables appear along the matrix diagonal;
%   scatter plots of variable pairs appear off-diagonal. The slopes of the
%   least-squares reference lines in the scatter plots are equal to the
%   displayed correlation coefficients.
%
% Input Arguments:
%
%   X - numObs-by-numVars matrix or tabular array of numObs observations on
%       numVars variables.
%
% Optional Input Parameter Name/Value Pairs:
%
%   NAME        VALUE
%
%   'type'      String indicating the type of correlation coefficient to
%               compute. Values are:
%
%               'Pearson'  Pearson's linear correlation coefficient
%
%               'Kendall'  Kendall's rank correlation coefficient (tau)
%
%               'Spearman' Spearman's rank correlation coefficient (rho)
%
%               The default is 'Pearson'.
%
%   'rows'      String indicating how to treat NaN values in the data.
%               Values are:
%
%               'all'       Use all rows, regardless of NaNs
%
%               'complete'  Use only rows with no NaNs
%
%               'pairwise'  Use rows with no NaNs in column i or j to
%                           compute R(i,j)
%
%               The default is 'pairwise'.
%
%   'tail'      String indicating the alternative hypothesis Ha used to
%               compute the PValue output. Values are:
%
%               'both'	Ha: Correlation is not zero
%
%               'right'	Ha: Correlation is greater than zero
%
%               'left'  Ha: Correlation is less than zero
%
%               The default is 'both'.
%
%	'varNames' 	Cell vector of variable name strings of length numVars to
%               be used in the plots. Names are truncated to the first five
%               characters. The default for matrix X is {'var1','var2',...}.
%               The default for dataset array X is X.Properties.VarNames.
%
%   'testR'     String indicating whether or not to test for significant
%               correlations and highlight them in red. Values are 'off'
%               and 'on'. The default is 'off'.
%
%   'alpha'     Scalar level for tests of correlation significance. Values
%               must be between 0 and 1. The default value is 0.05.
%
% Output Arguments:
%
%	R - numVars-by-numVars correlation matrix of X displayed in the plots.
%
%	PValue - numVars-by-numVars matrix of p-values corresponding to
%       elements of R, used to test the hypothesis of no correlation
%       against the alternative of a nonzero correlation.
%
% Notes:
%
%   o P-values for Pearson's correlation are computed by transforming the
%     correlation to create a t statistic with numObs-2 degrees of freedom.
%     The transformation is exact when X is normal. P-values for Kendall's
%     and Spearman's rank correlations are computed using either the exact
%     permutation distributions (for small sample sizes), or large-sample
%     approximations. P-values for two-tailed tests are computed by
%     doubling the more significant of the two one-tailed p-values.
%
%   o Using the 'pairwise' option for the 'rows' parameter may return a
%     correlation matrix that is not positive definite. The 'complete'
%     option always returns a positive definite matrix, but in general the
%     estimates are based on fewer observations.
%
%   o Use the GNAME function to identify points in the plots.
%
% Example:
%
%   load Data_Canada
%   corrplot(DataTable)
%   gname(dates)
%
% See also COLLINTEST, CORR, GNAME.

% Copyright 2012 The MathWorks, Inc.

% Handle dataset array inputs:

if isa(X,'dataset')
    
    try
    
        X = dataset2table(X);
    
    catch 
    
        error(message('econ:corrplot:DataNotConvertible'))
    
    end
    
end

% Parse inputs and set defaults:

parseObj = inputParser;
parseObj.addRequired('X',@XCheck);
parseObj.addParamValue('type','Pearson',@typeCheck);
parseObj.addParamValue('rows','pairwise',@rowsCheck);
parseObj.addParamValue('tail','both',@tailCheck);
parseObj.addParamValue('varNames',{},@varNamesCheck);
parseObj.addParamValue('testR','off',@testRCheck);
parseObj.addParamValue('alpha',0.05,@alphaCheck);

parseObj.parse(X,varargin{:});

X = parseObj.Results.X;
corrType = parseObj.Results.type;
whichRows = parseObj.Results.rows;
tail = parseObj.Results.tail;
varNames = parseObj.Results.varNames;
testRFlag = strcmpi(parseObj.Results.testR,'on');
alpha = parseObj.Results.alpha;

numVars = size(X,2);

% Create variable names:

if isempty(varNames)
    
    if isa(X,'table')

    	varNames = X.Properties.VariableNames;

    else

        varNames = strcat({'var'},num2str((1:numVars)','%-u'));
        
    end

else

    if length(varNames) < numVars

        error(message('econ:corrplot:VarNamesTooFew'))

    elseif length(varNames) > numVars

        error(message('econ:corrplot:VarNamesTooMany'))
        
    end

end

% Truncate variable names to first five characters:
varNames = cellfun(@(s)[s,'     '],varNames,'UniformOutput',false);
varNames = cellfun(@(s)s(1:5),varNames,'UniformOutput',false);

% Convert table to double for numeric processing:

if isa(X,'table')
    
    try
    
        X = table2array(X);
        X = double(X);
    
    catch 
    
        error(message('econ:corrplot:DataNotConvertible'))
    
    end
    
end

% Compute plot information:

[R,PValue] = corr(X,'type',corrType,'rows',whichRows,'tail',tail);

Mu = nanmean(X);
Sigma = nanstd(X);
Z = bsxfun(@minus,X,Mu);
Z = bsxfun(@rdivide,Z,Sigma);
ZLims = [nanmin(Z(:)),nanmax(Z(:))];

% Basic plot:

figure('Tag','corrPlotFigure')
[H,Ax,bigAx] = gplotmatrix(X,[],[],[],'.',2,[],'hist',varNames,varNames);

% Format plot:

set(H(logical(eye(numVars))),'EdgeColor','c')
sXlabels = get(Ax,'XLabel');
set([sXlabels{:}],'FontWeight','bold','Color',[0 0 0.6])
set([sXlabels{:}],'FontWeight','bold','Color',[0 0 0.6])
set(get(bigAx,'Title'),'String','{\bf Correlation Matrix}')

for i = 1:numVars
        
    for j = 1:numVars
        
        set(get(bigAx,'Parent'),'CurrentAxes',Ax(i,j))
        set(Ax(i,j),'XLim',Mu(j)+(1.1)*ZLims*Sigma(j),...
                    'YLim',Mu(i)+(1.1)*ZLims*Sigma(i))
        axis normal   
            
        if i ~= j
            
            hls = lsline;
            set(hls,'Color','m','Tag','lsLines');
            plotPos = get(Ax(i,j),'Position');
            
            if testRFlag && (PValue(i,j) < alpha)
                
                corrColor = 'r';
                
            else
                
                corrColor = 'k';
                
            end
            
            annotation('textbox',plotPos,...
                       'String',num2str(R(i,j),'%3.2f'),...
                       'FontWeight','Bold',...
                       'Color',corrColor,...
                       'EdgeColor','none','Tag','corrCoefs')
            
        end
        
    end
    
end

nargoutchk(0,2);

if nargout > 0
    
    varargout = {R,PValue};
    
end

%-------------------------------------------------------------------------
% Check input X
function OK = XCheck(X)

if ischar(X)
    
    error(message('econ:corrplot:DataNonNumeric'))
            
elseif isempty(X)

    error(message('econ:corrplot:DataUnspecified'))

elseif isvector(X)

    error(message('econ:corrplot:DataIsVector'))

else

    OK = true;

end

%-------------------------------------------------------------------------
% Check value of 'type' parameter
function OK = typeCheck(corrType)

if ~isvector(corrType)

    error(message('econ:corrplot:CorrTypeNonVector'))

elseif isnumeric(corrType)

    error(message('econ:corrplot:CorrTypeNumeric'))

elseif ~ismember(lower(corrType),{'pearson','kendall','spearman'})

    error(message('econ:corrplot:CorrTypeInvalid'))

else

    OK = true;

end

%-------------------------------------------------------------------------
% Check value of 'rows' parameter
function OK = rowsCheck(whichRows)

if ~isvector(whichRows)

    error(message('econ:corrplot:RowsParamNonVector'))

elseif isnumeric(whichRows)

    error(message('econ:corrplot:RowsParamNumeric'))

elseif ~ismember(lower(whichRows),{'all','complete','pairwise'})

    error(message('econ:corrplot:RowsParamInvalid'))

else

    OK = true;

end

%-------------------------------------------------------------------------
% Check value of 'tail' parameter
function OK = tailCheck(tail)

if ~isvector(tail)

    error(message('econ:corrplot:TailParamNonVector'))

elseif isnumeric(tail)

    error(message('econ:corrplot:TailParamNumeric'))

elseif ~ismember(lower(tail),{'both','right','left'})

    error(message('econ:corrplot:TailParamInvalid'))

else

    OK = true;

end

%-------------------------------------------------------------------------
% Check value of 'varNames' parameter
function OK = varNamesCheck(varNames)
    
if ~isvector(varNames)

    error(message('econ:corrplot:VarNamesNonVector'))

elseif isnumeric(varNames) || (iscell(varNames) && any(cellfun(@isnumeric,varNames)))

    error(message('econ:corrplot:VarNamesNumeric'))

else

    OK = true;

end

%-------------------------------------------------------------------------
% Check value of 'testR' parameter
function OK = testRCheck(testR)

if ~isvector(testR)

    error(message('econ:corrplot:testRNonVector'))

elseif isnumeric(testR)

    error(message('econ:corrplot:testRNumeric'))

elseif ~ismember(lower(testR),{'off','on'})

    error(message('econ:corrplot:testRInvalid'))

else

    OK = true;

end

%-------------------------------------------------------------------------
% Check value of 'alpha' parameter
function OK = alphaCheck(alpha)
    
if ~isnumeric(alpha)

    error(message('econ:corrplot:AlphaNonNumeric'))

elseif ~isscalar(alpha)

    error(message('econ:corrplot:AlphaNonScalar'))

elseif alpha < 0 || alpha > 1

    error(message('econ:corrplot:AlphaOutOfRange'))

else

    OK = true;

end