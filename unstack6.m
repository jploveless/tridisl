function b = unstack6(a)
% unstack6   Converts a 6n-by-1 column vector to an n-by-6 array.
%   unstack3(A) converts the 6n-by-1 column vector A to a n-by-6 array
%   with order [A(1) A(2) A(3) A(4) A(5) A(6); ...; A(end-5) A(end-4)...A(end)]
%
%   B = unstack6(A) returns the output to array B.
%
%   See also: stack6, unstack3, stack3, stack2, unstack2
%

b = reshape(a', 6, size(a, 1)/6)';