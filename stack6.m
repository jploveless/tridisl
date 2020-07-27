function b = stack6(a)
% stack6   Converts an n-by-6 array to a 6n-by-1 column vector.
%   stack6(A) converts the n-by-6 array A to a 6n-by-1 column vector
%   with order [A(1, 1) A(1, 2)...A(1, 6)...A(n, 1) A(n, 2)...A(n, 6)]'
%
%   B = stack6(A) returns the output to vector B.
%
%   See also: stack3, unstack3, stack2, unstack2
%

b = reshape(a', 6*size(a, 1), 1);