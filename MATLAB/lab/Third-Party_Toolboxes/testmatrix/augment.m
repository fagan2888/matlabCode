function C = augment(A, alpha)
%AUGMENT  Augmented system matrix.
%         AUGMENT(A, ALPHA) is the square matrix
%         [ALPHA*EYE(m) A; A' ZEROS(n)] of dimension m+n, where A is m-by-n.
%         It is the symmetric and indefinite coefficient matrix of the
%         augmented system associated with a least squares problem
%         minimize NORM(A*x-b).  ALPHA defaults to 1.
%         Special case: if A is a scalar, n say, then AUGMENT(A) is the
%                       same as AUGMENT(RANDN(p,q)) where n = p+q and
%                       p = ROUND(n/2), that is, a random augmented matrix
%                       of dimension n is produced.
%         The eigenvalues of AUGMENT(A) are given in terms of the singular
%         values s(i) of A (where m>n) by
%                  1/2 +/- SQRT( s(i)^2 + 1/4 ),  i=1:n  (2n eigenvalues),
%                  1,  (m-n eigenvalues).
%         If m < n then the first expression provides 2m eigenvalues and the
%         remaining n-m eigenvalues are zero.
%
%         See also SPAUGMENT.

%         Reference:
%         G.H. Golub and C.F. Van Loan, Matrix Computations, Second
%         Edition, Johns Hopkins University Press, Baltimore, Maryland,
%         1989, sec. 5.6.4.

[m, n] = size(A);
if nargin < 2, alpha = 1; end

if max(m,n) == 1
   n = A;
   p = round(n/2);
   q = n - p;
   A = randn(p,q);
   m = p; n = q;
end

C = [alpha*eye(m) A; A' zeros(n)];
