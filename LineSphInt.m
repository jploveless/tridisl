function [v3a, v3b] = LineSphInt(v1, v2, c, r)
% LineSphInt   Calculates the intersection between a line (segment) and a sphere.
%    
%
%

dpx = v2(:, 1) - v1(:, 1);
dpy = v2(:, 2) - v1(:, 2);
dpz = v2(:, 3) - v1(:, 3);

a = dpx.^2 + dpy.^2 + dpz.^2;
b = 2*(dpx.*(v1(:, 1) - c(:, 1)) + dpy.*(v1(:, 2) - c(:, 2)) + dpz.*(v1(:, 3) - c(:, 3)));
c = c(:, 1).^2 + c(:, 2).^2 + c(:, 3).^2 +...
	 v1(:, 1).^2 + v1(:, 2).^2 + v1(:, 3).^2 -...
	 2*(c(:, 1).*v1(:, 1) + c(:, 2).*v1(:, 2) + c(:, 3).*v1(:, 3)) -...
	 r.^2;
dett = sqrt(b.^2 - 4*a.*c);
ua = (-b + dett)./(2*a);
ub = (-b - dett)./(2*a);

v3a = v1 + repmat(ua, 1, 3).*(v2 - v1);
v3b = v1 + repmat(ub, 1, 3).*(v2 - v1);
