function x=centersig(x,dim)
% function x=centersig(x,dim)
% center (-mean) on dim, default =1 
if (nargin<2 || isempty(dim)); dim=1;end
dims=ndims(x);
nx=permute(x,[dim,1:(dim-1),(dim+1):dims]);
dd=size(nx);
nx=reshape(nx,dd(1),[]);
nx=reshape(zscore(nx),dd);% bsxfun(@minus,nx,mean(nx,1))
x=permute(nx,[2:dim,1,(dim+1):dims]);