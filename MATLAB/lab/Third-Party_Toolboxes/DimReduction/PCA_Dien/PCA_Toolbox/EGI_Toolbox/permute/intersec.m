function v = intersec(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9) % INTERSEC Form the intersection of 'sets'.%   V = INTERSEC(X,Y) forms the intersection of the elements in X and Y,%   removing repeated elements. X and Y may be any size, V will be%   a sorted row vector. %   The function accepts 0 to 10 input arguments,%   for example U=INTERSEC(X) or U=INTERSEC(X,Y,Z).  % Uses: union% Author: Robert Piche, Tampere University of Technology, Finland%         (piche@butler.cc.tut.fi)    % Last revised: Jan 18, 1994 if nargin==0  v = [];elseif nargin==1  v = union(x0(:).');else  if nargin>2    arglist='x1';    for k=3:nargin, arglist=[arglist ',x' num2str(k-1) ]; end    x1 = eval(['intersec(' arglist ')']);  end  v = sort([union(x0) union(x1)]);   n = length(v);  if n > 0, v = v([0 ~(v(2:n)-v(1:n-1))]); endend