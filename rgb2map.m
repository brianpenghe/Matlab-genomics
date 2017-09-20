function ind=rgb2map(varargin)
%RGB2MAP  Convert RGB colors to indexed colormap colors.
%   IND = RGB2MAP(RGB) converts the RGB image RGB (M-by-N-by-3 array) to an
%   indexed image IND (M-by-N matrix) using the colormap of the current figure.
%   If no figure is open, the default colormap is used.
%   
%   IND = RGB2MAP(R,G,B) converts the RGB image with equal size matrices R, G,
%   and B to an indexed image IND (same size as R, G, and B) using the current
%   figure colormap. If no figure is open, the default colormap is used.
%   
%   IND = RGB2MAP(CMAP) converts the RGB colormap to an indexed colormap using
%   the current figure colormap. If no figure is open, the default colormap is
%   used.CMAP is an M-by-3 matrix with elements in the interval 0 to 1 and
%   columns representing the intensity of red, blue, and green, respectively.
%   
%   IND = RGB2MAP(...,MAP) converts the RGB image or colormap to an indexed
%   image or colormap IND (M-by-N matrix) using the RGB colormap MAP. MAP is an
%   M-by-3 matrix with elements in the interval 0 to 1 and columns representing
%   the intensity of red, blue, and green, respectively.
%   
%   IND = RGB2MAP(...,MAPNAME) converts the RGB image or colormap to an indexed
%   image or colormap IND (M-by-N matrix) using the built-in RGB colormap
%   function specified by the string MAPNAME.
%
%   Example:
%       img = imread('peppers.png'); map = parula(256);
%       ind = rgb2map(img,map);
%       figure; imshow(ind,'Colormap',map);
%   
%   Class support:
%       RGB inputs may be class uint8, uint16, single, or double. CMAP inputs
%       must be doubles. The output IND is class uint8.
%   
%   See also COLORMAP, IND2RGB, RGB2IND, RGB2LAB, MAKECFORM, APPLYCFORM,
%            LAB2DOUBLE.

%   See: http://stackoverflow.com/a/30062029/2278029

%   Andrew D. Horchler, horchler @ gmail . com, Created 5-2-15
%   Revision: 1.1, 6-20-15


% CIE Delta E color difference standard to use: 76 or 94
CIEDeltaEstandard = 76;

% Validate data and allocate output
switch nargin
    case {1,2}
        x = varargin{1};
        if ndims(x) == 3
            sz = size(x);
            if sz(3) ~= 3
                error('rgb2map:InvalidInputSizeRGB',...
                      'RGB must be M-by-N-by-3 array.');
            end
            validateattributes(x,{'uint8','uint16','double','single'},...
                                 {'real'},'rgb2map','RGB',1);
            
            x = reshape(x,[sz(1)*sz(2) 3]);
         	ind = zeros(sz(1),sz(2),'uint8');
        elseif ismatrix(x)
            sz = size(x);
            if sz(2) ~= 3
                error('rgb2map:InvalidSizeForColormap',...
                      'Input colormap CMAP must be M-by-3 matrix.');
            end
            validateattributes(x,{'double'},{'real','nonempty','nonsparse'},...
                                 'rgb2map','CMAP',1);
            if any(x(:) < 0) || any(x(:) > 1)
                error('rgb2map:InvalidMapValues',...
                      'Colormap CMAP cannot have values outside [0,1] range.');
            end
            
            ind = zeros(sz(1),1,'uint8');
        else
            error('rgb2map:InvalidInputSize',...
                  'Input must be M-by-3 matrix or M-by-N-by-3 array.');
        end
    case {3,4}
        validateattributes(varargin{1},{'uint8','uint16','double','single'},...
                                       {'real','2d'},'rgb2map','R',1);
        validateattributes(varargin{2},{'uint8','uint16','double','single'},...
                                       {'real','2d'},'rgb2map','G',2);
        validateattributes(varargin{3},{'uint8','uint16','double','single'},...
                                       {'real','2d'},'rgb2map','B',3);
        
        sz = size(varargin{1});
        if ~isequal(sz,size(varargin{2}),size(varargin{3}))
            error('rgb2map:InputSizeMismatch',...
                  'R, G, and B must all be the same size.');
        end
        
        x = [varargin{1}(:) varargin{2}(:) varargin{3}(:)];
        ind = zeros(sz,'uint8');
    otherwise
        error('rgb2map:WrongInputNum','Wrong number of input arguments.');
end

% Validate optional color map
if nargin == 2 || nargin == 4
    map = varargin{end};
    if ischar(map)
        names = {'autumn','bone','colorcube','cool','copper','flag','gray',...
                 'hot','hsv','jet','lines','pink','prism','spring','summer',...
                 'white','winter'};
        if ~any(strcmp(map,names))
            error('rgb2map:InvalidColormapName',...
                  'Colormap name must be %sor ''%s''.',...
                  sprintf('''%s'', ',names{1:end-1}),names{end});
        end
        
        if numel(findobj('type','figure')) > 0
            map = feval(map,size(get(gcf,'Colormap'),1));
        else
            map = feval(map,size(get(0,'DefaultFigureColormap'),1));
        end
    elseif isnumeric(map)
        if ~ismatrix(map) || size(map,2) ~= 3
            error('rgb2map:InvalidSizeForColormap',...
                  'Colormap MAP must be M-by-3 matrix.');
        end
        validateattributes(map,{'double'},{'real','nonempty','nonsparse'},...
                             'rgb2map','MAP',nargin);
        if any(map(:) < 0) || any(map(:) > 1)
            error('rgb2map:InvalidMapValues',...
                  'Colormap MAP cannot have values outside [0,1] range.');
        end
    else
        error('rgb2map:InvalidColormap',...
             ['Colormap must be an M-by-3 matrix or a string specifying the '...
              'name of a built-in colormap function.']);
    end
else
    if numel(findobj('type','figure')) > 0
        map = get(gcf,'Colormap');
    else
        map = get(0,'DefaultFigureColormap');
    end
end

% Set up converter from RGB to CIE 1976 L*a*b* (CIELAB)
cf = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));

% Convert RGB colormap to CIELAB
map = lab2double(applycform(map, cf));

% Convert RGB data to CIELAB
x = lab2double(applycform(x, cf));

% Find nearest indexed color in MAP for each RGB pixel
n = numel(ind);
m = min(n,256);
map = repmat(permute(map,[3 2 1]),m,1,1);
if CIEDeltaEstandard == 76
    f = @(block)minDeltaE76(block,map);
else
    f = @(block)minDeltaE94(block,map);
end
for i = 1:m:n-m+1
    ind(i:i+m-1) = f(x(i:i+m-1,:));
end
ind(i+m:end) = minDeltaE94(x(i+m:end,:),map(1:n-m-i+1,:,:));


function ind=minDeltaE76(block,map)
%MINDELTAE76  Find index minimum CIE 1976 delta E for each L*a*b* triplet

[~,ind] = min(sum(bsxfun(@minus,map,block).^2,2),[],3);
ind = uint8(ind-1);


function ind=minDeltaE94(block,map)
%MINDELTAE94  Find index minimum CIE 1994 delta E for each L*a*b* triplet

dLab = bsxfun(@minus,map,block).^2;
C1 = sqrt(bsxfun(@plus,map(:,3,:).^2,block(:,2,:).^2));
C2 = sqrt(bsxfun(@plus,map(:,2,:).^2,block(:,3,:).^2));
dC = (C1-C2).^2;
[~,ind] = min(dLab(:,1,:)+dC./(1+0.045*C1).^2+(sum(dLab(:,2:3,:),2)-dC)./(1+0.015*C2).^2,[],3);
ind = uint8(ind-1);