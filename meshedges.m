function H = meshedges(c, v, nel, varargin)
%
% MESHEDGES plots outlines of a triangulated mesh.
%
%   MESHEDGES(C, V, NEL) plots the triangulated mesh edges using the vertex 
%   coordinates contained in C and the element vertex indices contained in V.
%   C is an n x 2 or n x 3 array of values containing the x, y or x, y, and z 
%   values of each of the n vertices.  V is an m x 3 array, each line of which 
%   contains the indices of the 3 vertices that make up each of the m triangular
%   elements. If C is n x 2, a 2-D representation of the mesh will be plotted
%   and if C is n x 3, the full 3-D mesh will be plotted. NEL contains the number
%   of elements in each distinct entity, so that individual outlines can be plotted.
%   It should be the case that sum(NEL) = size(V, 1).
%
%   MESHEDGES(C, V, NEL, AX) plots the mesh edges in the axes specified with AX. 
%   AX can be an axis handle or a figure number. The default behavior is to plot 
%   the mesh in a new figure window.
%
%   H = MESHEDGES(...) returns the patch objects to the handle H.
%

% Default figure (new) and line spec
fign = [];
lspec = {'color', 'k', 'linewidth', 1};

% parse optional color input
if nargin == 4 % If only one optional input, 
   fign = varargin{1}; % Axis/figure specification
elseif nargin > 4 % If more than one optional input
   if ~ischar(varargin{1})
      fign = varargin{1};
      lspec = varargin(2:end);
   else
      fign = [];
      lspec = varargin(1:end);
   end
end

% make the plot
if isempty(fign)
   figure
   ax = gca;
else
   if strcmp(class(fign), 'matlab.ui.Figure') % if it's actually a figure number
	   figure(fign);
	   ax = gca;
	   hold on
	elseif strcmp(class(fign), 'matlab.graphics.axis.Axes')
       ax = fign;
       hold on
	elseif strcmp(class(fign), 'double') 
	   if rem(fign, 1) == 0
	   	   figure(fign);
     	   ax = gca;
	       hold on 
       else % otherwise it's an axis handle
		   ax = fign;
		   hold on
	   end
	end
end

% Element IDs for each mesh 
ends = cumsum(nel);
begs = [1; ends(1:end-1)+1];
H = [];

for i = 1:length(nel)
   ol = OrderedEdges(c, v(begs(i):ends(i), :));
   h = line(c(ol, 1), c(ol, 2), c(ol, 3), 'parent', ax);
   for j = 1:length(lspec)/2
      set(h, lspec{2*j-1}, lspec{2*j});
   end
   H = [H; h];
end
%caxis = [min(color), max(color)];
