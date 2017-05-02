function donut = donut(numdat,varargin)
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

% Default Values, if no variable arguments in
legtext = [];
colormap lines
clrmp = colormap;
ispie = 0;
width = 0.95;
if length(varargin)>0
    legtext = varargin{1};
    if length(varargin)>1
        if ~isempty(varargin{2})
            clrmp = varargin{2};
        else
            colormap lines
            clrmp = colormap;
        end
        if length(varargin)>2
            if isempty(find(strcmp(varargin,'pie')))==0; 
                ispie = 1;
            else
                width=varargin{3};
            end
        end
    end
end

rings = size(numdat,1); % nuber of rings in plot
cats = size(numdat,2); % number of categories in each ring/set

donout = nan(size(numdat));
for i = 1:rings
    tot = nansum(numdat(i,:)); % total things
    donout(i,:)=numdat(i,:)./tot;
    fractang = (pi/2)+[0,cumsum((numdat(i,:)./tot).*(2*pi))];
    for j = 1:cats
        if ispie==1
            r0 = 0;
            r1 = width;
        else
            r0 = i;
            r1 = i+width;
        end
        a0 = fractang(j);
        a1 = fractang(j+1);
        if iscell(clrmp)
            cl = clrmp{j};
        else
            cl = clrmp(j,:);
        end
        polsect(a0,a1,r0,r1,cl);
    end
    if i==rings
        legend1 = legend(legtext);
        wi = legend1.Position(3);
        Xlm = xlim;
        widx = diff(Xlm);
        unitwi = widx.*wi;
        xlim([Xlm(1),Xlm(2)+unitwi])
    end
end

function pspatch = polsect(th0,th1,rh0,rh1,cl)
% This function creates a patch from polar coordinates

a1 = linspace(th0,th0);
r1 = linspace(rh0,rh1);
a2 = linspace(th0,th1);
r2 = linspace(rh1,rh1);
a3 = linspace(th1,th1);
r3 = linspace(rh1,rh0);
a4 = linspace(th1,th0);
r4 = linspace(rh0,rh0);
[X,Y]=pol2cart([a1,a2,a3,a4],[r1,r2,r3,r4]);

p=patch(X,Y,cl); % Note: patch function takes text or matrix color def
axis equal
pspatch = p;
