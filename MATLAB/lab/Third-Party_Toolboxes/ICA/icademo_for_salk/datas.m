function mixt = datas(nr, nc, nt)

% nr = image rows
% nc = image columns

% e.g. m = datas(32,32,100);

[x, y] = meshgrid(linspace(0, 1, nr), linspace(0, 1, nc));

% (2) 3 5 7 9 11 13
im1 = sin(2*pi*2*x);
im2 = sin(2*pi*3*y);
im3 = sin(2*pi*5*x).*sin(2*pi*5*y);

im4 = rand(nr, nc);
%im4 = randn(nr, nc); % gets mixed up!

im1 = im1(:); im1 = im1-mean(im1); im1 = im1/std(im1);
im2 = im2(:); im2 = im2-mean(im2); im2 = im2/std(im2);
im3 = im3(:); im3 = im3-mean(im3); im3 = im3/std(im3);
im4 = im4(:); im4 = im4-mean(im4); im4 = im4/std(im4);

fprintf('Images ...\n');
jfig(1); 
subplot(2, 2, 1); pnshow( reshape(im1, nr, nc) ); title('Original IC 1');
subplot(2, 2, 2); pnshow( reshape(im2, nr, nc) ); title('Original IC 2');
subplot(2, 2, 3); pnshow( reshape(im3, nr, nc) ); title('Original IC 3');
subplot(2, 2, 4); pnshow( reshape(im4, nr, nc) ); title('Original IC 4');
drawnow;

t = linspace(0, 1, nt);

t1 = t;
t2 = t.^2;
t3 = randn(1, nt);
t4 = 10*t; t4 = t4-floor(t4);

t1 = t1-mean(t1); t1 = t1/std(t1);
t2 = t2-mean(t2); t2 = t2/std(t2);
t3 = t3-mean(t3); t3 = t3/std(t3);
t4 = t4-mean(t4); t4 = t4/std(t4);

mixt = im1*t1+im2*t2+im3*t3+im4*t4;

fprintf('Time courses ...\n');
jfig(2); clf;
subplot(2, 2, 1); plot( t1 ); title('Original Time course 1');
subplot(2, 2, 2); plot( t2 );title('Original Time course 2');
subplot(2, 2, 3); plot( t3 );title('Original Time course 3');
subplot(2, 2, 4); plot( t4 );title('Original Time course 4');