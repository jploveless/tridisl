function s = makestressfields(s, st, sts)
% makestressfields  Adds stress fields to a structure from a vector
%   s = makestressfields(s, st) adds fields to structure s for stress
%   components extracted from vector st. The fields created are
%   sxx, syy, szz, sxy, sxz, syz. The rows of st are assumed to be 
%   stacked in this order for a particular coordinate. 
%
%  s = makestressfields(s, st, sts) also adds fields for the component
%  uncertainties from vector sts. 

s.sxx = st(1:6:end);
s.syy = st(2:6:end);
s.szz = st(3:6:end);
s.sxy = st(4:6:end);
s.sxz = st(5:6:end);
s.syz = st(6:6:end);

if exist('sts', 'var')
   s.sxxs = sts(1:6:end);
   s.syys = sts(2:6:end);
   s.szzs = sts(3:6:end);
   s.sxys = sts(4:6:end);
   s.sxzs = sts(5:6:end);
   s.syzs = sts(6:6:end);
end