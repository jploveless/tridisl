function w = MakeTriSmooth(share, dists)
%
% MakeTriSmooth produces a smoothing matrix based on the scale-dependent
% umbrella operator (Desbrun et al., 1999; Resor, 2004).
%
% Inputs:
%   share		= n x 3 array of indices of the up to 3 elements sharing a side 
%					  with each of the n elements
%   dists		= n x 3 array of distances between each of the n elements and its
%					  up to 3 neighbors
%
% Outputs:
%   w				= n x n smoothing matrix
%

n = size(share, 1);
n3 = n*3;

% allocate space for the smoothing matrix
%w = zeros(n);
%W = zeros(3*n);
w = spalloc(n3, n3, 27*n);
%w = spalloc(n, 3*n, 9*n);

% make a design matrix for Laplacian construction
s = share;
s(s ~= 0) = 1;

% sum the distances between each element and its neighbors
sdists = sum(dists, 2);
lcoeff = 2./sdists; % leading coefficient

% replace zero distances with 1
dists(find(~dists)) = 1;
% take the reciprocal of the distances
idists = 1./dists;

% diagonal terms
selfs = -lcoeff.*sum(idists.*s, 2);

% off diagonals
offdi = repmat(lcoeff, 1, 3).*idists.*s;

% place the weights into the smoothing operator
for i = 1:n
   for j = 1:3
      w(3*i-(3-j), 3*i-(3-j)) = selfs(i);
      if share(i, j) ~= 0;
         k = 3*i - [2 1 0];
         m = 3*share(i, j) - [2 1 0];
         p = sub2ind(size(w), k, m);
         w(p) = offdi(i, j);
      end
   end
end	

