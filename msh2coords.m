function [c, v, nc, nEl] = msh2coords(file)
%
% MSH2COORDS extracts coordinate and vertex information from a Gmsh .msh file.
%
%   [C,V] = MSH2COORDS(FILE) extracts the coordinates and vertex ordering of 
%   triangular elements from the Gmsh .msh file named FILE.  The coordinates
%   are returned to the n x 3 array C, arranged with the x, y, and z locations
%   of coordinates in the three columns.  V is an m x 3 array containing the 
%   indices of the 3 vertices making up each of the m triangular elements.
%

% open file as character array
in             = opentxt(file);

%%%%%%%%%%%%%
% Version 2 %
%%%%%%%%%%%%%

% determine version number
if strcmp(in(2, 1), '2')

% extract number of nodes and elements
nnode          = str2double(in(5,:));
ne             = str2double(in(8+nnode,:));

c              = str2num(in(6:5+nnode,:));
c              = c(:,2:end);

% find 1-D elements and ignore
d1             = 9+nnode; % start at line of first element listing
sp             = strfind(in(d1,:),' '); % find the locations of spaces in that line
while str2num(in(d1,sp(1)+1)) == 1 % while the first char. after the first space = 1... 
    d1         = d1+1; % skip that line: it's a one-dimensional element
    sp         = strfind(in(d1,:),' '); % make a new index of space locations
end
v              = str2num(in(d1:8+nnode+ne,:));
v              = v(:,end-2:end);

nc             = size(c, 1);
nEl            = size(v, 1);

%%%%%%%%%%%%%
% Version 4 %
%%%%%%%%%%%%%
elseif strcmp(in(2, 1:3), '4 0')

% Find flags
flags = findstr(in(:, 1)', '$');

% Allocate space for nc and nEl arrays
nent = str2num(in(flags(3)+1, :)); nent = nent(3);
nc = zeros(nent, 1);
nEl = nc;

% Nodes start at 5th flag + 1, end at 6th - 1
nodekeep = str2num(in(flags(5)+1, :)); % Get number of elements
nodekeep = zeros(nodekeep(2), 3); % Allocate space for element array
nodes = in(flags(5)+2:flags(6)-1, :);

j = 1;
% Step through element rows
while j < size(nodes, 1)
   % Get length of entity
   lent = str2num(nodes(j, :)); lent = lent(end);
   % Loops through that entity's nodes
   if lent > 0
      for i = j+(1:lent)
         % Convert to numbers
         nodetest = str2num(nodes(i, :));
         % Check size
         if size(nodetest, 2) == 4 % If it contains 3 coordinates
            nodekeep(nodetest(1), :) = nodetest(2:4); % Save its coordinates
         end
         j = i+1;
      end
   else
       j = j+1;
   end
end
c = nodekeep;

% Elements start at 7th flag + 1, end at 8th flag - 1
elkeep = str2num(in(flags(7)+1, :)); % Get number of elements
elkeep = zeros(elkeep(2), 3); % Allocate space for element array
els = in(flags(7)+2:flags(8)-1, :); % Get all element rows

j = 1;
% Step through element rows
while j < size(els, 1)
   % Get length of entity
   lent = str2num(els(j, :)); nent = lent(2); lent = lent(end);
   % Loops through that entity's elements
   for i = j+(1:lent)
      % Convert to numbers
      eltest = str2num(els(i, :));
      % Check size
      if size(eltest, 2) == 4 % If it's a triangle,
         elkeep(eltest(1), :) = eltest(2:4); % Save its nodes
         nEl(nent) = lent;
      end
      j = i+1;
   end
end
% Trim empty rows
v = elkeep(sum(elkeep, 2) ~= 0, :);

%%%%%%%%%%%%%%%
% Version 4.1 %
%%%%%%%%%%%%%%%
elseif strcmp(in(2, 1:3), '4.1')

% Find flags
flags = findstr(in(:, 1)', '$');

% Allocate space for nc and nEl arrays
nent = str2num(in(flags(3)+1, :)); nent = nent(3);
nc = zeros(nent, 1);
nEl = nc;

% Nodes start at 5th flag + 1, end at 6th - 1
nodekeep = str2num(in(flags(5)+1, :)); % Get number of nodes
nodekeep = zeros(nodekeep(2), 3); % Allocate space for node array
nodes = in(flags(5)+2:flags(6)-1, :);

j = 1;
% Step through node rows
while j < size(nodes, 1)
  % Get length of entity
  lent = str2num(nodes(j, :)); lent = lent(end);
  if lent ~= 0
     % Loops through that entity's nodes
     for i = (j+lent) + (1:lent)
        % Convert to numbers
        nodetest = str2num(nodes(i, :));
        % Check size
        if size(nodetest, 2) == 3 % If it contains 3 coordinates
           idx = str2num(nodes(i-lent, :));
           nodekeep(idx, :) = nodetest; % Save its coordinates
        end
        j = i+1;
     end
  else
     j = j+1;
  end
end
c = nodekeep;

% Elements start at 7th flag + 1, end at 8th flag - 1
elkeep = str2num(in(flags(7)+1, :)); % Get number of elements
elkeep = zeros(elkeep(2), 3); % Allocate space for element array
els = in(flags(7)+2:flags(8)-1, :); % Get all element rows

j = 1;
% Step through element rows
while j < size(els, 1)
  % Get length of entity
  lent = str2num(els(j, :)); nent = lent(2); lent = lent(end);
  % Loops through that entity's elements
  for i = j+(1:lent)
     % Convert to numbers
     eltest = str2num(els(i, :));
     % Check size
     if size(eltest, 2) == 4 % If it's a triangle,
        elkeep(eltest(1), :) = eltest(2:4); % Save its nodes
        nEl(nent) = lent;
     end
     j = i+1;
  end
end
% Trim empty rows
v = elkeep(sum(elkeep, 2) ~= 0, :);

end

% Determine number of coordinates in each entity
ends = cumsum(nEl);
begs = [1; ends(1:end-1)+1];
for i = 1:length(nEl)
   nc(i) = length(unique(v(begs(i):ends(i), :)));
end