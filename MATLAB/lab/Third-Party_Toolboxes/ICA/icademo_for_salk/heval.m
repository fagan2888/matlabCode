function h = heval(w, x, S, a, b, pltfun)

% w = un-mixing matrix in M*K-vector
% x = mixed signal data (size K x ndata)
% h = estimated output entropy

% unpack W
[M, n] = size(x);
K = length(w) / M;
W = reshape(w, K, M);
a = a(:, ones(1, n));
b = b(:, ones(1, n));

% form output data set
y = W*x;
t = tanh(y);

%Y = a.*erf(y) + b.*t; % NB: CPU and memory

% jsize(a,'a'); jsize(b,'b');

dY = a/sqrt(pi) .* exp(-0.5*y.^2) + b.*(1 - t.^2); % NB: CPU and memory

clear a b t

% get non-linear contribution to entropy
s = abs(dY) + 1e-20;

% get approximate linear contribution to entropy
C = det(W*S*W');

h = -( (1/n)*sum(sum(log(s))) + 0.5*log(C) );

% progress report
if ~isempty(pltfun)
   feval(pltfun, K, M, w, h, x);
end

