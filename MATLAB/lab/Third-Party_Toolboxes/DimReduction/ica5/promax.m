% promax() - perform Promax oblique rotation after orthogonal Varimax 
%            rotation of the rows of the input data. A method for 
%            linear decomposition by "rotating to simple structure."
% Usage:
%             >> [R] = promax(data,ncomps);
%       else  >> [R,V] = promax(data,ncomps,maxit);
%
% Inputs:
%     data    - Promax operates on rows of the input data matrix
%     ncomps  - operate on the N largest PCA components (default|0 -> all)
%     maxit   - maximum number of iterations {default|0 -> 5}
%
% Outputs:
%     R       - is the non-orthogonal Promax rotation matrix 
%                 i.e.,  >> promax_rotated_data = R*data;
%     V       - is the orthogonal Varimax rotation matrix 
%                 i.e.,  >> varimax_rotated_data = V*data;

% Colin Humphries, CNL / Salk Institute June 1998
% formatted and modified to return V by Scott Makeig, 6/23/98
% reset maxit default to 5, added ncomps -sm 7/8/98
%
% Reference: 
%
% Hendrickson AE and White PO (1964) Promax: A quick method for rotation 
% to oblique simple structure, Br J of Stat Psych, X:xxx-xxx.

function [R,V] = promax(data,ncomps,maxit)

DEFAULT_POWER     = 4;
DEFAULT_TOLERANCE = 1e-5;
MAX_ITERATIONS    = 5;
NEAR_ZERO         = 1e-8;

powr = DEFAULT_POWER; 
tol = DEFAULT_TOLERANCE;

if nargin < 1
  help promax
  return
end
if isempty(data)
  help promax
  return
end

if nargin < 2
   ncomps = 0;
end
chans = size(data,1)
if ncomps == 0
   ncomps = chans
end

if nargin < 3
  maxit = 0;
end
if maxit == 0
  maxit = MAX_ITERATIONS;
end

if ncomps < chans
  [eigenvectors,eigenvalues,compressed,datamean] = pcsquash(data,ncomps);
  data = compressed;
  clear compressed;
  eigenvectors = eigenvectors(:,1:ncomps); % make non-square
  eigenwts = pinv(eigenvectors); % find forward (non-square) weight matrix
end

R = varimax(data); % run Varimax on the (projected) data
B = R*data;        % compute rotated data
V = R;             % save Varimax matrix as V
if ncomps < chans
 V = V*eigenwts;   % include PCA reduction matrix
end
B = B';            % transpose
R = R';
continue = 1;
fprintf(...
  'Finding oblique Promax rotation using exponent %g and tolerance %g\n',...
                                                  powr,tol)
it = 1;
Pz = zeros(size(B));
while continue & it <= MAX_ITERATIONS
  P = Pz;
  ii = find(abs(B) > NEAR_ZERO); % avoid division by 0
  P(ii) = (abs(B(ii).^(powr+1)))./B(ii);
  tmp = inv(B'*B)*B'*P;
  tmp = normalcol(tmp);
  Rn = R*tmp;
  B = B*tmp;
  distnew = dot(Rn(:),R(:));
  if it > 1
    delta = abs(distnew-distold);
    if delta < tol
      continue = 0;
    end
    fprintf('#%d delta %f\n',it,delta)
    if isnan(delta)
      continue = 0;
    end
  end
  R = Rn;
  distold = distnew;
  it = it+1;
end
B = B';
R = R';
if ncomps < chans
   R = R*eigenwts; % include the pcsquash() compression
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function n=normalcol(m)

if isempty(m)
  fprintf('normalcol() has empty input!\n');
  return
end
[mr,mc] = size(m);
n = sqrt(ones./sum(m.*m));
n = ones(mr,1)*n;
n = n.*m;