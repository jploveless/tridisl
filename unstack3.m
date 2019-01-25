function b = unstack3(a)
% unstack3   Converts a 3n-by-1 column vector to an n-by-3 array.
%   unstack3(A) converts the 3n-by-1 column vector A to a n-by-3 array
%   with order [A(1) A(2) A(3); A(4) A(5) A(6); ...; A(end-2) A(end-1) A(end)]
%
%   B = unstack3(A) returns the output to array B.
%
%   See also: stack3, stack2, unstack2
%

b = reshape(a', 3, size(a, 1)/3)';