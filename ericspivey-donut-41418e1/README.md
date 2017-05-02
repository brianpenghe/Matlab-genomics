# donut
Donut plot function for MATLAB. Can also elect to use as a standard pie chart, but with explicit control of the section colors.

function donout = donut(numdat,varargin)
% numdat: number data. Each column is a catagory, each row represents
%   a separate set of data
% varargin{1}: cell of legend entries, one string for each column of numdat,
%   default is none, eg. {'First','Second','Third'}
% varargin{2}: cell of colors, one row of 3 RGB values for each category (column of numdat)
% varargin{3}: if 'pie', will make a standard pie chart
% Examples:
%   donut([50,20,10;40,30,15],{'First','Second','Third'},{'r','g','b'});
%   donut([50,20,10],{'First','Second','Third'},[],'pie');
%   donut([50,20,10;40,30,15],[],{[ .945 .345 .329],[ .376 .741 .408],[ .365 .647 .855 ]});
