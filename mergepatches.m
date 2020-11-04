function np = mergepatches(p)
% mergepatches   Merges patches based on shared element sides.
%   np = mergepatches(p) merges patches defined in structure p,
%   with required fields c, v, nc, nEl. Patches are merged by 
%   reducing the number of rows of p.c and adjusting the entries 
%   of p.v, and a new structure is returned to np. 
%

% Quit if there's only one patch
if length(p.nEl) == 1
   return
end

% Patch indices
ends = cumsum(p.nEl(:));
begs = [1; ends(1:end-1)+1];

% Check uniqueness of p.c
uc = unique(p.c, 'rows', 'stable');

% Arrays of node coordinates
% Do this instead of relying on x1, y1, etc. because
% we don't know if those were calculated assuming
% Cartesian or geographic
nodec = p.c(p.v, :);
n1 = nodec(1:ends(end), :);
n2 = nodec(ends(end)+1:2*ends(end), :);
n3 = nodec(2*ends(end)+1:end, :);

% Index nodal coordinates into unique coordinate array
[~, n1i] = ismember(n1, uc, 'rows');
[~, n2i] = ismember(n2, uc, 'rows');
[~, n3i] = ismember(n3, uc, 'rows');

% Prepare output fields
np.c = uc; % Unique coordinates are new full coordinates
np.v = [n1i, n2i, n3i]; % Node array is new indices
for i = 1:length(begs)
   np.nc(i) = size(unique(np.c(np.v(begs(i):ends(i), :), :), 'rows'), 1);
end
np.nEl = p.nEl; % Not changing element counts