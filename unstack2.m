function b = unstack2(a)
% unstack2   Converts a 2n-by-1 column vector to an n-by-2 array.
%   unstack2(A) converts the 2n-by-1 column vector A to a n-by-2 array
%   with order [A(1) A(2); A(3) A(4); ...; A(end-1) A(end)]
%
%   B = unstack2(A) returns the output to array B.
%
%   See also: stack3, unstack3, stack2
%

b = reshape(a', 2, size(a, 1)/2)';