function H = bar3c(Z,x,y,w,C)
%% 3D bar plot from matrix (colored by height)
% function H = bar3c(Z,x,y,w,C)
%
% Input: Z - NxM matrix
%        x - 1xN grid (default: 1:N)
%        y - 1xM grid (default: 1:M)
%        w - 1x2 bar half-widths (default: full half-width)
%        C - Kx3 colormap or 
%            NxMx3 bar colors (default: colormap(gray))
% Output: H - matrix of surf handles
%
% bar3c creates a 3D colored bar plot by plotting each bar as an individual
% surface object with its own color.
%
% Example (Gaussian bar plot):
%   M = 50; % grid resolution
%   x = linspace(-3,3,M); % x-grid
%   y = linspace(-3,3,M); % y-grid
%   C = [0.3 -0.2; -0.2 0.6]; % covariance
%   [X,Y] = meshgrid(x,y);
%   XY = [X(:) Y(:)]; % grid pairs
%   Z = 1/sqrt(det(2*pi*C))*exp(-1/2*sum((XY/C).*XY,2));
%   Z = reshape(Z,[M,M]);
%   figure
%   bar3c(Z,x,y,[],jet(50))
%
% Johannes Traa - July 2013

[N,M] = size(Z);

%% check inputs
if nargin < 2 || isempty(x); x = 1:N; end
if nargin < 3 || isempty(y); y = 1:M; end
if nargin < 4 || isempty(w); w = [x(2)-x(1) y(2)-y(1)]/2; end
if nargin < 5 || isempty(C); C = colormap(gray); end

%% x and y info for surfs
Hx = cell(1,N); % x values of surf
Hy = cell(1,M); % y values of surf
for i=1:N
  X = x(i) + [-w(1) -w(1) w(1) w(1)];
  Hx{i} = repmat(X,[4,1]);
end
for j=1:M
  Y = y(j) + [-w(2) -w(2) w(2) w(2)]';
  Hy{j} = repmat(Y,[1,4]);
end

%% bar coloring
if ismatrix(C)
  r = ceil((Z-min(Z(:)))/(max(Z(:))-min(Z(:)))*size(C,1));
  r(r(:)==0) = 1;
end

%% make bars
hold on

H = zeros(N,M); % surf handles
Hz = zeros(4,4); %+min(Z(:)); % z values of surf
for i=1:N
  for j=1:M
    Hz(2:3,2:3) = ones(2,2)*Z(i,j);
    
    % bar color
    if ismatrix(C); C_ij = C(r(i,j),:);
    else            C_ij = reshape(C(i,j,:),[1,3]);
    end
    
    % plot bar
    H(i,j) = surf(Hx{i},Hy{j},Hz,'FaceColor',C_ij,'EdgeColor','k');
  end
end

view(-50,40)
axis vis3d tight
grid on
drawnow

%% output
if nargout < 1; clear H; end