function els = edgeelements(c, v)
% EDGEELEMENTS  Finds elements lining the edge of a mesh.
%   [elements, nodes] = EDGEELEMENTS(c, v) finds the 
%   indices of elements lining the edges of the mesh defined by 
%   coordinate array c and vertex ordering array v, returning the 
%   indices to fields top, bot, side of structure els. 
% 

% Allocate space for edge matrices
[els.top, els.bot, els.side] = deal(false(size(v, 1), 1));

% Get ordered edge coordinates
elo = OrderedEdges(c, v);

% Arrays of all element side pairs
side1 = sort(v(:, 1:2), 2);
side2 = sort(v(:, 2:3), 2);
side3 = sort(v(:, [3, 1]), 2);

% Match sides pairs with perimeter pairs
selo = sort(elo);
[~, side1_in_edge_idx] = ismember(selo', side1, 'rows');
[~, side2_in_edge_idx] = ismember(selo', side2, 'rows');
[~, side3_in_edge_idx] = ismember(selo', side3, 'rows');

% Remove zeros from arrays
side1_in_edge_idx = side1_in_edge_idx(side1_in_edge_idx ~= 0);
side2_in_edge_idx = side2_in_edge_idx(side2_in_edge_idx ~= 0);
side3_in_edge_idx = side3_in_edge_idx(side3_in_edge_idx ~= 0);

% Get depth of nodes
side1_depths = abs(c([side1(side1_in_edge_idx, :), v(side1_in_edge_idx, 3)], 3));
side2_depths = abs(c([side2(side2_in_edge_idx, :), v(side2_in_edge_idx, 1)], 3));
side3_depths = abs(c([side3(side3_in_edge_idx, :), v(side3_in_edge_idx, 2)], 3));

side1_depths = reshape(side1_depths, length(side1_depths)/3, 3);
side2_depths = reshape(side2_depths, length(side2_depths)/3, 3);
side3_depths = reshape(side3_depths, length(side3_depths)/3, 3);

% Top elements are those where the depth difference between the non-edge node
% and the mean of the edge nodes is greater than the depth difference between
% the edge nodes themselves
top1 = (side1_depths(:, 3) - mean(side1_depths(:, 1:2), 2)) > abs(side1_depths(:, 2) - side1_depths(:, 1));
top2 = (side2_depths(:, 3) - mean(side2_depths(:, 1:2), 2)) > abs(side2_depths(:, 2) - side2_depths(:, 1));
top3 = (side3_depths(:, 3) - mean(side3_depths(:, 1:2), 2)) > abs(side3_depths(:, 2) - side3_depths(:, 1));

els.top(side1_in_edge_idx(top1)) = true;
els.top(side2_in_edge_idx(top2)) = true;
els.top(side3_in_edge_idx(top3)) = true;

% Bottom elements are those where the depth difference between the non-edge node
% and the mean of the edge nodes is more negative than the depth difference between
% the edge nodes themselves
bot1 = (side1_depths(:, 3) - mean(side1_depths(:, 1:2), 2)) < -abs(side1_depths(:, 2) - side1_depths(:, 1));
bot2 = (side2_depths(:, 3) - mean(side2_depths(:, 1:2), 2)) < -abs(side2_depths(:, 2) - side2_depths(:, 1));
bot3 = (side3_depths(:, 3) - mean(side3_depths(:, 1:2), 2)) < -abs(side3_depths(:, 2) - side3_depths(:, 1));

els.bot(side1_in_edge_idx(bot1)) = true;
els.bot(side2_in_edge_idx(bot2)) = true;
els.bot(side3_in_edge_idx(bot3)) = true;

% Side elements are a set difference between all edges and tops, bottoms
els.side(side1_in_edge_idx) = true;
els.side(side2_in_edge_idx) = true;
els.side(side3_in_edge_idx) = true;
els.side(els.top) = false;
els.side(els.bot) = false;